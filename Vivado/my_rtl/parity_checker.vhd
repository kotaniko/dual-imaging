LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY parity_checker IS
  PORT (
    s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_tvalid : IN STD_LOGIC;
    axis_aclk : IN STD_LOGIC;
    axis_aresetn : IN STD_LOGIC;
    flip_on_match : OUT STD_LOGIC;
    parity_error : OUT STD_LOGIC
  );
END parity_checker;

ARCHITECTURE logic OF parity_checker IS
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdata : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tvalid : SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axis_aclk : SIGNAL IS "xilinx.com:signal:clock:1.0 axis_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF axis_aresetn : SIGNAL IS "xilinx.com:signal:reset:1.0 axis_aresetn RST";
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aclk : SIGNAL IS "ASSOCIATED_BUSIF S_AXIS, ASSOCIATED_RESET axis_aresetn";

  SIGNAL flip_on_match_i : STD_LOGIC;
  SIGNAL parity : STD_LOGIC;
  SIGNAL parity_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL parity_ii : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL parity_iii : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
  PROCESS (axis_aclk, axis_aresetn)
  BEGIN
    IF (axis_aresetn = '0') THEN
      parity_error <= '0';
      flip_on_match_i <= '0';
    ELSIF (axis_aclk'event AND axis_aclk = '1') THEN
      IF (s_axis_tvalid = '1' AND parity /= s_axis_tdata(0)) THEN
        parity_error <= '1';
      END IF;
      IF (s_axis_tvalid = '1' AND s_axis_tdata(15 DOWNTO 1) = "101" & x"555") THEN
        flip_on_match_i <= NOT flip_on_match_i;
      END IF;
    END IF;
  END PROCESS;

  stage_1 :
  FOR i IN 0 TO 6 GENERATE
    parity_i(i) <= s_axis_tdata(i * 2 + 2) XOR s_axis_tdata(i * 2 + 1);
  END GENERATE;

  stage_2 :
  FOR i IN 0 TO 2 GENERATE
    parity_ii(i) <= parity_i(i * 2 + 1) XOR parity_i(i * 2);
  END GENERATE;
  parity_ii(3) <= parity_i(6) XOR s_axis_tdata(15);

  stage_3 :
  FOR i IN 0 TO 1 GENERATE
    parity_iii(i) <= parity_ii(i * 2 + 1) XOR parity_ii(i * 2);
  END GENERATE;

  parity <= parity_iii(1) XOR parity_iii(0);
  flip_on_match <= flip_on_match_i;

END logic;