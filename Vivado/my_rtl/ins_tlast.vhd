LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ins_tlast IS
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
        axis_aresetn : IN STD_LOGIC
    );
END ins_tlast;

ARCHITECTURE Behavioral OF ins_tlast IS
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF m_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tlast : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
    ATTRIBUTE X_INTERFACE_INFO OF s_axis_tkeep : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aclk : SIGNAL IS "ASSOCIATED_BUSIF S_AXIS:M_AXIS, ASSOCIATED_RESET axis_aresetn";

    CONSTANT startOfFrame : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0841";
    SIGNAL axis_tdata_i : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL axis_tvalid_i : STD_LOGIC;

BEGIN

    PROCESS (axis_aclk)
    BEGIN
        IF (axis_aclk'event AND axis_aclk = '1') THEN
            axis_tdata_i <= s_axis_tdata;
            axis_tvalid_i <= s_axis_tvalid;
        END IF;
    END PROCESS;

    PROCESS (axis_aclk, axis_aresetn)
        VARIABLE counter : INTEGER RANGE 0 TO 1080;
    BEGIN
        IF (axis_aresetn = '0') THEN
            counter := 0;
        ELSIF (axis_aclk'event AND axis_aclk = '1') THEN
            m_axis_tdata <= s_axis_tdata;
            m_axis_tvalid <= s_axis_tvalid;
            m_axis_tkeep <= s_axis_tkeep;

            IF (s_axis_tdata = startOfFrame) THEN
                counter := 0;
            END IF;

            IF (s_axis_tvalid = '1' AND s_axis_tlast = '1') THEN
                counter := counter + 1;
            END IF;

            IF (counter = 1080) THEN
                m_axis_tlast <= s_axis_tlast;
            ELSE
                m_axis_tlast <= '0';
            END IF;

        END IF;
    END PROCESS;
END Behavioral;