LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reduce_fps IS
    PORT (
        m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tlast : OUT STD_LOGIC;
        m_axis_tkeep : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tlast : IN STD_LOGIC;
        s_axis_tkeep : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        axis_aclk : IN STD_LOGIC;
        axis_aresetn : IN STD_LOGIC;
        reduce_ratio : STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END reduce_fps;

ARCHITECTURE Behavioral OF reduce_fps IS
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF axis_aclk : SIGNAL IS "xilinx.com:signal:clock:1.0 axis_aclk CLK";
    ATTRIBUTE X_INTERFACE_INFO OF axis_aresetn : SIGNAL IS "xilinx.com:signal:reset:1.0 axis_aresetn RST";
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aclk : SIGNAL IS "ASSOCIATED_BUSIF S_AXIS:M_AXIS, ASSOCIATED_RESET axis_aresetn";

    SIGNAL axis_tdata_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL axis_tlast_s : STD_LOGIC;
    SIGNAL axis_tkeep_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
    CONSTANT startOfFrame : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0841";
BEGIN
    PROCESS (axis_aclk, axis_aresetn)
        VARIABLE counter : STD_LOGIC_VECTOR(5 DOWNTO 0);
    BEGIN
        IF (axis_aresetn = '0') THEN
            counter := REDUCE_RATIO;
        ELSIF (axis_aclk'event AND axis_aclk = '1') THEN
            m_axis_tdata <= s_axis_tdata;
            m_axis_tlast <= s_axis_tlast;
            m_axis_tkeep <= s_axis_tkeep;

            IF (s_axis_tvalid = '1' AND s_axis_tdata = startOfFrame) THEN
                counter := counter(4 DOWNTO 0) & counter(5);
            END IF;

            IF (counter(5) = '1') THEN
                m_axis_tvalid <= s_axis_tvalid;
            ELSE
                m_axis_tvalid <= '0';
            END IF;

        END IF;
    END PROCESS;

END Behavioral;