LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY stream_mod IS
    GENERIC (
        BIT5 : STD_LOGIC := '0'
    );
    PORT (
        m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tready : IN STD_LOGIC;
        m_axis_tlast : OUT STD_LOGIC;
        m_axis_tkeep : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tready : OUT STD_LOGIC;
        s_axis_tuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        s_axis_tlast : IN STD_LOGIC;
        s_axis_tkeep : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        axis_aclk : IN STD_LOGIC;
        axis_aresetn : IN STD_LOGIC
    );
END stream_mod;

ARCHITECTURE Behavioral OF stream_mod IS
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tready : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TREADY";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tready : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TREADY";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tuser : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TUSER";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF axis_aclk : SIGNAL IS "xilinx.com:signal:clock:1.0 axis_aclk CLK";
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aclk : SIGNAL IS "ASSOCIATED_BUSIF S_AXIS:M_AXIS, ASSOCIATED_RESET axis_aresetn";

    CONSTANT startOfFrame : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0841";
    CONSTANT startOfFrameAlt : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"1082";
    SIGNAL axis_tdata_i : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    axis_tdata_i <=
        startOfFrameAlt WHEN s_axis_tdata = startOfFrame ELSE
        startOfFrameAlt WHEN s_axis_tdata = startOfFrame(15 DOWNTO 6) & '1' & startOfFrame(4 DOWNTO 0) ELSE
        startOfFrame WHEN s_axis_tuser(0) = '1' ELSE
        s_axis_tdata;

    m_axis_tdata <= axis_tdata_i(15 DOWNTO 6) & BIT5 & axis_tdata_i(4 DOWNTO 0);

    m_axis_tvalid <= s_axis_tvalid;
    m_axis_tlast <= s_axis_tlast;
    m_axis_tkeep <= s_axis_tkeep;
    s_axis_tready <= m_axis_tready;

END Behavioral;