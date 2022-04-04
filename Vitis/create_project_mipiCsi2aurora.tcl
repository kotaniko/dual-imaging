setws -switch
app create -name {CamAxiController} -hw {../Vivado/hardwareDesign/mipiCsi2aurora_hw.xsa} -proc {microblaze_0} -os {standalone} -template {Empty Application(C)}
bsp config sleep_timer "axi_timer_0"
bsp write
bsp regenerate
importsources -name {CamAxiController} -path {my_src}
app build -name {CamAxiController}
