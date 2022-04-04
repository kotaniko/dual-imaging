#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "sleep.h"
#include "xiic.h"
#include "xgpio.h"
#include "xv_demosaic.h"
#include "xv_gamma_lut.h"
#include "math.h"
#include "OV5640.h"

#define CAM1_I2C XPAR_IIC_0_BASEADDR
#define CAM2_I2C XPAR_IIC_1_BASEADDR
#define CAM_I2C_ADDRESS 0x3c
#define GPIO_CAM1_PWUP 0b01
#define GPIO_CAM2_PWUP 0b10
#define GPIO_LEDG 0b100
#define IMG_WIDTH 1920
#define IMG_HEIGHT 1080

int init();
int Write_Camera_Reg(UINTPTR, u16, u8);
void Read_Camera_Reg(UINTPTR, u16, u8*);
void Calc_gamma(float);
int Init_Pcam5C(UINTPTR);
void Init_Demosaic(XV_demosaic*, u16);
void Init_Gamma_LUT(XV_gamma_lut*, u16);

enum ErrorState {
    CAMERA_ID, CAMERA_CLKSEL, CAMERA_SOFTPWDN, CAMERA_CFG_INIT, CAMERA_CFG_1080P, CAMERA_CFG_AWB, CAMERA_SOFTPWUP
};
u8 errorState = 0;

XGpio GpioInst;
XV_demosaic DemosaicInst1;
XV_demosaic DemosaicInst2;
XV_gamma_lut GammaLutInst1;
XV_gamma_lut GammaLutInst2;

u16 gamma_reg[1024];

int main() {
    init_platform();

    xil_printf("v2.7\r\n");
    // Initialize the GPIO driver
    int Status = XGpio_Initialize(&GpioInst, XPAR_GPIO_0_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        return Status;
    }

    // Green LED off
    XGpio_DiscreteSet(&GpioInst, 1, GPIO_LEDG);

    Status = init();

    if (Status == XST_SUCCESS) {
        xil_printf("Init success\r\n");
        // Green LED on
        XGpio_DiscreteClear(&GpioInst, 1, GPIO_LEDG);
    } else {
        xil_printf("Init failed:errState %d\r\n",errorState);
    }

    cleanup_platform();
    return 0;
}

int init() {
    int Status = XST_SUCCESS;

    // Reset Cameras
    XGpio_DiscreteClear(&GpioInst, 1, GPIO_CAM1_PWUP | GPIO_CAM2_PWUP);
    usleep(100000);
    // PWUP Camera 1
    XGpio_DiscreteSet(&GpioInst, 1, GPIO_CAM1_PWUP);
    usleep(50000);
    // PWUP Camera 2
    XGpio_DiscreteSet(&GpioInst, 1, GPIO_CAM2_PWUP);
    usleep(50000);
    xil_printf("Cam reset done\r\n");

    Status = Init_Pcam5C(CAM1_I2C);
    if (Status != XST_SUCCESS) {
        return Status;
    }
    xil_printf("Cam1 done\r\n");

    Status = Init_Pcam5C(CAM2_I2C);
    if (Status != XST_SUCCESS) {
        return Status;
    }
    xil_printf("Cam2 done\r\n");

    Init_Demosaic(&DemosaicInst1, XPAR_XV_DEMOSAIC_0_DEVICE_ID);
    Init_Demosaic(&DemosaicInst2, XPAR_XV_DEMOSAIC_1_DEVICE_ID);
    xil_printf("Init_Demosaic done\r\n");

    Calc_gamma(1.6);
    Init_Gamma_LUT(&GammaLutInst1, XPAR_XV_GAMMA_LUT_0_DEVICE_ID);
    Init_Gamma_LUT(&GammaLutInst2, XPAR_XV_GAMMA_LUT_1_DEVICE_ID);
    xil_printf("Init_Gamma_LUT done\r\n");

    return XST_SUCCESS;
}

int Write_Camera_Reg(UINTPTR BaseAddr, u16 regAddr, u8 regVal) {
    u8 sendData[3] = { (u8) (regAddr >> 8), (u8) (regAddr & 0xff), regVal };
    u8 buf;
    // Send regVal to regAddr
    XIic_Send(BaseAddr, CAM_I2C_ADDRESS, sendData, 3, XIIC_STOP);
    XIic_WriteReg(BaseAddr, XIIC_CR_REG_OFFSET, XIIC_CR_TX_FIFO_RESET_MASK);
    usleep(50);
    // Confirm the written data @ regAddr
    XIic_Send(BaseAddr, CAM_I2C_ADDRESS, sendData, 2, XIIC_REPEATED_START);
    //XIic_Send(BaseAddr, CAM_I2C_ADDRESS, sendData, 2, XIIC_STOP);
    XIic_Recv(BaseAddr, CAM_I2C_ADDRESS, &buf, 1, XIIC_STOP);

    if (regAddr == 0x3008) {
        return XST_SUCCESS;
    } else if (regVal != buf) {
        //xil_printf("Write reg failed @ 0x%04x\r\n", regAddr);
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}

void Read_Camera_Reg(UINTPTR BaseAddr, u16 regAddr, u8 *val) {
    u8 regAddrOrd[2] = { (u8) (regAddr >> 8), (u8) (regAddr & 0xff) };
    XIic_Send(BaseAddr, CAM_I2C_ADDRESS, regAddrOrd, 2, XIIC_REPEATED_START);
    XIic_Recv(BaseAddr, CAM_I2C_ADDRESS, val, 1, XIIC_STOP);
}

void Calc_gamma(float gamma_val) {
    for (int i = 0; i < 1024; i++) {
        gamma_reg[i] = (pow((i / 1024.0), (1 / gamma_val)) * 1024.0);
    }
}

int Init_Pcam5C(UINTPTR Camera_I2C) {
    int Status = XST_SUCCESS;

    u8 buf[2];
    Read_Camera_Reg(Camera_I2C, 0x300a, &buf[0]);
    Read_Camera_Reg(Camera_I2C, 0x300b, &buf[1]);

    if ((buf[0] != 0x56) || (buf[1] != 0x40)) {
        errorState = CAMERA_ID;
        return XST_FAILURE;
    }

    Status = Write_Camera_Reg(Camera_I2C, 0x3103, 0x11);
    if (Status != XST_SUCCESS) {
        errorState = CAMERA_CLKSEL;
        return Status;
    }
    usleep(10);

    Status = Write_Camera_Reg(Camera_I2C, 0x3008, 0x82);
    if (Status != XST_SUCCESS) {
        errorState = CAMERA_SOFTPWDN;
        return Status;
    }

    usleep(10000);

    u8 word_counter = 0;
    while (cfg_init[word_counter].addr != 0xffff) {
        Status |= Write_Camera_Reg(Camera_I2C, cfg_init[word_counter].addr,
                cfg_init[word_counter].data);
        word_counter++;
        usleep(10);
    }
    if (Status != XST_SUCCESS) {
        errorState = CAMERA_CFG_INIT;
        return Status;
    }

    word_counter = 0;
    while (cfg_1080p_30fps[word_counter].addr != 0xffff) {
        Status |= Write_Camera_Reg(Camera_I2C, cfg_1080p_30fps[word_counter].addr,
                cfg_1080p_30fps[word_counter].data);
        word_counter++;
        usleep(10);
    }
    if (Status != XST_SUCCESS) {
        errorState = CAMERA_CFG_1080P;
        return Status;
    }

    word_counter = 0;
    while (cfg_simple_awb[word_counter].addr != 0xffff) {
        Status |= Write_Camera_Reg(Camera_I2C, cfg_simple_awb[word_counter].addr,
                cfg_simple_awb[word_counter].data);
        word_counter++;
        usleep(10);
    }
    if (Status != XST_SUCCESS) {
        errorState = CAMERA_CFG_AWB;
        return Status;
    }

    Status = Write_Camera_Reg(Camera_I2C, 0x3008, 0x02);
    if (Status != XST_SUCCESS) {
        xil_printf("Camera softPWUP err\r\n");
        return Status;
    }
    usleep(200);

    return Status;
}

void Init_Demosaic(XV_demosaic *XV_demosaic_inst, u16 DeviceId) {
    XV_demosaic_Initialize(XV_demosaic_inst, DeviceId);
    XV_demosaic_Set_HwReg_bayer_phase(XV_demosaic_inst, 3);
    XV_demosaic_Set_HwReg_width(XV_demosaic_inst, IMG_WIDTH);
    XV_demosaic_Set_HwReg_height(XV_demosaic_inst, IMG_HEIGHT);
    XV_demosaic_EnableAutoRestart(XV_demosaic_inst);
    XV_demosaic_Start(XV_demosaic_inst);
}

void Init_Gamma_LUT(XV_gamma_lut *XV_gamma_lut_inst, u16 DeviceId) {
    XV_gamma_lut_Initialize(XV_gamma_lut_inst, DeviceId);
    XV_gamma_lut_Set_HwReg_video_format(XV_gamma_lut_inst, 0);
    XV_gamma_lut_Set_HwReg_width(XV_gamma_lut_inst, IMG_WIDTH);
    XV_gamma_lut_Set_HwReg_height(XV_gamma_lut_inst, IMG_HEIGHT);
    XV_gamma_lut_Write_HwReg_gamma_lut_0_Bytes(XV_gamma_lut_inst, 0, (char *) gamma_reg, 2048);
    XV_gamma_lut_Write_HwReg_gamma_lut_1_Bytes(XV_gamma_lut_inst, 0, (char *) gamma_reg, 2048);
    XV_gamma_lut_Write_HwReg_gamma_lut_2_Bytes(XV_gamma_lut_inst, 0, (char *) gamma_reg, 2048);
    XV_gamma_lut_EnableAutoRestart(XV_gamma_lut_inst);
    XV_gamma_lut_Start(XV_gamma_lut_inst);
}
