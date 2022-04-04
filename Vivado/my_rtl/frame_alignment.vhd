LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY frame_alignment IS
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
        axis_aresetn_out : OUT STD_LOGIC;
        peripheral_aresetn : IN STD_LOGIC;
        rcv_ready : IN STD_LOGIC
    );
END frame_alignment;

ARCHITECTURE Behavioral OF frame_alignment IS
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
    ATTRIBUTE X_INTERFACE_INFO OF axis_aresetn_out : SIGNAL IS "xilinx.com:signal:reset:1.0 axis_aresetn_out RST";
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aclk : SIGNAL IS "ASSOCIATED_BUSIF S_AXIS:M_AXIS, ASSOCIATED_RESET axis_aresetn:axis_aresetn_out";
    ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aresetn_out : SIGNAL IS "POLARITY ACTIVE_LOW";

    CONSTANT startOfFrame : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0841";
    TYPE State_type IS (RUN, HOLD);

BEGIN

    PROCESS (axis_aclk, peripheral_aresetn)
        VARIABLE State : State_type;
    BEGIN
        IF (peripheral_aresetn = '0') THEN
            State := HOLD;
        ELSIF (axis_aclk'event AND axis_aclk = '1') THEN
            m_axis_tdata <= s_axis_tdata;
            m_axis_tlast <= s_axis_tlast;
            m_axis_tkeep <= s_axis_tkeep;
            CASE State IS
                WHEN HOLD =>
                    IF (rcv_ready = '1' AND s_axis_tvalid = '1' AND s_axis_tdata = startOfFrame) THEN
                        State := RUN;
                        m_axis_tvalid <= '1';
                    ELSE
                        m_axis_tvalid <= '0';
                    END IF;
                WHEN RUN =>
                    m_axis_tvalid <= s_axis_tvalid;
            END CASE;
        END IF;
    END PROCESS;

    axis_aresetn_out <= axis_aresetn AND peripheral_aresetn;

END Behavioral;