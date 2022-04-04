LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY axis_sig_ext IS
    PORT (
        m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tready : IN STD_LOGIC;
        m_axis_tlast : OUT STD_LOGIC;
        m_axis_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tready : OUT STD_LOGIC;
        s_axis_tlast : IN STD_LOGIC;
        s_axis_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        axis_aclk : IN STD_LOGIC;
        m_axis_tready_ext : OUT STD_LOGIC
    );
END axis_sig_ext;

ARCHITECTURE Behavioral OF axis_sig_ext IS
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tready : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TREADY";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tready : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TREADY";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO of axis_aclk: SIGNAL is "xilinx.com:signal:clock:1.0 axis_aclk CLK";
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER of axis_aclk: SIGNAL is "ASSOCIATED_BUSIF S_AXIS:M_AXIS";
BEGIN
    m_axis_tdata <= s_axis_tdata;
    m_axis_tvalid <= s_axis_tvalid;
    s_axis_tready <= m_axis_tready;
    m_axis_tlast <= s_axis_tlast;
    m_axis_tkeep <= s_axis_tkeep;
    m_axis_tready_ext <= m_axis_tready;
END Behavioral;