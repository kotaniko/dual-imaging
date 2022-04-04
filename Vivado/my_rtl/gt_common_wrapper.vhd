LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_misc.ALL;
USE ieee.std_logic_1164.ALL;

LIBRARY UNISIM;
USE UNISIM.Vcomponents.ALL;

--***************************** Entity Declaration ****************************

ENTITY gt_common_wrapper IS
    GENERIC (
        -- Simulation attributes
        WRAPPER_SIM_GTRESET_SPEEDUP : STRING := "FALSE"; -- Set to "TRUE" to speed up sim reset
        PLL0REFCLKSEL : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
        PLL1REFCLKSEL : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010"
    );
    PORT (
        ---------------------------- Common Block - Ports --------------------------
        gt0_gtrefclk0_in : IN STD_LOGIC;
        gt0_gtrefclk1_in : IN STD_LOGIC;
        gt0_pll0lock_out : OUT STD_LOGIC;
        gt0_pll1lock_out : OUT STD_LOGIC;
        gt0_pll0lockdetclk_in : IN STD_LOGIC;
        gt0_pll1lockdetclk_in : IN STD_LOGIC;
        gt0_pll0refclklost_out : OUT STD_LOGIC;
        gt0_pll1refclklost_out : OUT STD_LOGIC;

        --____________________________COMMON PORTS_______________________________{
        gt0_pll0outclk_i : OUT STD_LOGIC;
        gt0_pll1outclk_i : OUT STD_LOGIC;
        gt0_pll0outrefclk_i : OUT STD_LOGIC;
        gt0_pll1outrefclk_i : OUT STD_LOGIC;
        gt0_pll0reset_in : IN STD_LOGIC;
        gt0_pll1reset_in : IN STD_LOGIC

        --____________________________COMMON PORTS_______________________________}
    );
END gt_common_wrapper;

ARCHITECTURE STRUCTURE OF gt_common_wrapper IS

    --***************************** Parameter Declarations ************************
    CONSTANT PLL0_FBDIV_IN : INTEGER := 5;
    CONSTANT PLL1_FBDIV_IN : INTEGER := 5;
    CONSTANT PLL0_FBDIV_45_IN : INTEGER := 5;
    CONSTANT PLL1_FBDIV_45_IN : INTEGER := 5;
    CONSTANT PLL0_REFCLK_DIV_IN : INTEGER := 1;
    CONSTANT PLL1_REFCLK_DIV_IN : INTEGER := 1;

    --***************************** Wire Declarations *****************************
    SIGNAL tied_to_ground_i : STD_LOGIC;
    SIGNAL tied_to_ground_vec_i : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL tied_to_vcc_i : STD_LOGIC;

    ATTRIBUTE equivalent_register_removal : STRING;
    SIGNAL cpllpd_quad0_wait : STD_LOGIC_VECTOR(95 DOWNTO 0) := x"FFFFFFFFFFFFFFFFFFFFFFFF";
    SIGNAL cpllreset_quad0_wait : STD_LOGIC_VECTOR(127 DOWNTO 0) := x"000000000000000000000000000000FF";
    ATTRIBUTE equivalent_register_removal OF cpllpd_quad0_wait : SIGNAL IS "no";
    ATTRIBUTE equivalent_register_removal OF cpllreset_quad0_wait : SIGNAL IS "no";
    SIGNAL cpllpd_ovrd_quad0_i : STD_LOGIC;
    SIGNAL cpllreset_ovrd_quad0_i : STD_LOGIC;
    SIGNAL cpllreset_pll1_i : STD_LOGIC;
BEGIN
    --********************************* Main Body of Code**************************

    tied_to_ground_i <= '0';
    tied_to_ground_vec_i(63 DOWNTO 0) <= (OTHERS => '0');
    tied_to_vcc_i <= '1';

    cpllreset_pll1_i <= cpllreset_ovrd_quad0_i OR gt0_pll1reset_in;

    PROCESS (gt0_gtrefclk1_in)
    BEGIN
        IF (gt0_gtrefclk1_in'event AND gt0_gtrefclk1_in = '1') THEN
            cpllpd_quad0_wait <= cpllpd_quad0_wait(94 DOWNTO 0) & '0';
            cpllreset_quad0_wait <= cpllreset_quad0_wait(126 DOWNTO 0) & '0';
        END IF;
    END PROCESS;

    cpllpd_ovrd_quad0_i <= cpllpd_quad0_wait(95);
    cpllreset_ovrd_quad0_i <= cpllreset_quad0_wait(127);
    --_________________________________________________________________________
    --_________________________________________________________________________
    --_________________________GTPE2_COMMON____________________________________

    gtpe2_common_0_i : GTPE2_COMMON
    GENERIC MAP
    (
        -- Simulation attributes
        SIM_RESET_SPEEDUP => WRAPPER_SIM_GTRESET_SPEEDUP,
        SIM_PLL0REFCLK_SEL => ("001"),
        SIM_PLL1REFCLK_SEL => ("001"),
        SIM_VERSION => ("2.0"),

        PLL0_FBDIV => PLL0_FBDIV_IN,
        PLL0_FBDIV_45 => PLL0_FBDIV_45_IN,
        PLL0_REFCLK_DIV => PLL0_REFCLK_DIV_IN,
        PLL1_FBDIV => PLL1_FBDIV_IN,
        PLL1_FBDIV_45 => PLL1_FBDIV_45_IN,
        PLL1_REFCLK_DIV => PLL1_REFCLK_DIV_IN,
        ------------------COMMON BLOCK Attributes---------------
        BIAS_CFG => (x"0000000000050001"),
        COMMON_CFG => (x"00000000"),

        ----------------------------PLL Attributes----------------------------
        PLL0_CFG => (x"01F03DC"),
        PLL0_DMON_CFG => ('0'),
        PLL0_INIT_CFG => (x"00001E"),
        PLL0_LOCK_CFG => (x"1E8"),
        PLL1_CFG => (x"01F03DC"),
        PLL1_DMON_CFG => ('0'),
        PLL1_INIT_CFG => (x"00001E"),
        PLL1_LOCK_CFG => (x"1E8"),
        PLL_CLKOUT_CFG => (x"00"),

        ----------------------------Reserved Attributes----------------------------
        RSVD_ATTR0 => (x"0000"),
        RSVD_ATTR1 => (x"0000")
    )
    PORT MAP
    (
        DMONITOROUT => OPEN,
        ------------- Common Block  - Dynamic Reconfiguration Port (DRP) -----------
        DRPADDR => tied_to_ground_vec_i(7 DOWNTO 0),
        DRPCLK => tied_to_ground_i,
        DRPDI => tied_to_ground_vec_i(15 DOWNTO 0),
        DRPDO => OPEN,
        DRPEN => tied_to_ground_i,
        DRPRDY => OPEN,
        DRPWE => tied_to_ground_i,
        ---------------------------- Common Block - Ports --------------------------
        BGRCALOVRDENB => tied_to_vcc_i,
        GTEASTREFCLK0 => tied_to_ground_i,
        GTEASTREFCLK1 => tied_to_ground_i,
        GTGREFCLK0 => tied_to_ground_i,
        GTGREFCLK1 => tied_to_ground_i,
        GTREFCLK0 => gt0_gtrefclk0_in,
        --GTREFCLK1 => tied_to_ground_i,
        GTREFCLK1 => gt0_gtrefclk1_in,
        GTWESTREFCLK0 => tied_to_ground_i,
        GTWESTREFCLK1 => tied_to_ground_i,
        PLL0FBCLKLOST => OPEN,
        PLL0LOCK => gt0_pll0lock_out,
        PLL0LOCKDETCLK => gt0_pll0lockdetclk_in,
        PLL0LOCKEN => tied_to_vcc_i,
        PLL0OUTCLK => gt0_pll0outclk_i,
        PLL0OUTREFCLK => gt0_pll0outrefclk_i,
        --PLL0PD => pll0pd_in,
        PLL0PD => '0',
        PLL0REFCLKLOST => gt0_pll0refclklost_out,
        PLL0REFCLKSEL => PLL0REFCLKSEL,
        --PLL0RESET => cpllreset_quad0_i,
        PLL0RESET => gt0_pll0reset_in,
        PLL1FBCLKLOST => OPEN,
        PLL1LOCK => gt0_pll1lock_out,
        --PLL1LOCKDETCLK => tied_to_ground_i,
        PLL1LOCKDETCLK => gt0_pll1lockdetclk_in,
        PLL1LOCKEN => tied_to_vcc_i,
        PLL1OUTCLK => gt0_pll1outclk_i,
        PLL1OUTREFCLK => gt0_pll1outrefclk_i,
        --PLL1PD => cpllpd_ovrd_quad0_i,
        PLL1PD => '0',
        PLL1REFCLKLOST => gt0_pll1refclklost_out,
        PLL1REFCLKSEL => PLL1REFCLKSEL,
        --PLL1RESET => cpllreset_pll1_i,
        PLL1RESET => gt0_pll1reset_in,
        PLLRSVD1 => "0000000000000000",
        PLLRSVD2 => "00000",
        PMARSVDOUT => OPEN,
        REFCLKOUTMONITOR0 => OPEN,
        REFCLKOUTMONITOR1 => OPEN,
        ----------------------------- Common Block Ports ---------------------------
        BGBYPASSB => tied_to_vcc_i,
        BGMONITORENB => tied_to_vcc_i,
        BGPDB => tied_to_vcc_i,
        BGRCALOVRD => "11111",
        PMARSVD => "00000000",
        RCALENB => tied_to_vcc_i

    );

END STRUCTURE;