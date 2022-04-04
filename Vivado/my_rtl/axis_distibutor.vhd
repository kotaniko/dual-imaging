LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY axis_distibutor IS
    PORT (
        s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tlast : IN STD_LOGIC;
        s_axis_tkeep : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        m00_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        m00_axis_tvalid : OUT STD_LOGIC;
        m00_axis_tlast : OUT STD_LOGIC;
        m00_axis_tkeep : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m01_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        m01_axis_tvalid : OUT STD_LOGIC;
        m01_axis_tlast : OUT STD_LOGIC;
        m01_axis_tkeep : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        axis_aclk : IN STD_LOGIC
    );
END axis_distibutor;

ARCHITECTURE Behavioral OF axis_distibutor IS
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF m01_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 M01_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF m01_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 M01_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF m01_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 M01_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF m01_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 M01_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF axis_aclk : SIGNAL IS "xilinx.com:signal:clock:1.0 axis_aclk CLK";
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aclk : SIGNAL IS "ASSOCIATED_BUSIF S_AXIS:M00_AXIS:M01_AXIS";

BEGIN
    m00_axis_tdata <= s_axis_tdata(15 DOWNTO 6) & '0' & s_axis_tdata(4 DOWNTO 0);
    m01_axis_tdata <= s_axis_tdata(15 DOWNTO 6) & '0' & s_axis_tdata(4 DOWNTO 0);
    m00_axis_tlast <= s_axis_tlast;
    m01_axis_tlast <= s_axis_tlast;
    m00_axis_tkeep <= s_axis_tkeep;
    m01_axis_tkeep <= s_axis_tkeep;
    m00_axis_tvalid <=
        s_axis_tvalid WHEN s_axis_tdata(5) = '0' ELSE
        '0';
    m01_axis_tvalid <=
        s_axis_tvalid WHEN s_axis_tdata(5) = '1' ELSE
        '0';
END Behavioral;