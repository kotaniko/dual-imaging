LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY parity_generator IS
  PORT (
    data : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    test : IN STD_LOGIC;
    packet : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END parity_generator;

ARCHITECTURE logic OF parity_generator IS
  SIGNAL parity : STD_LOGIC;
  SIGNAL parity_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL parity_ii : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL parity_iii : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
  stage_1 :
  FOR i IN 0 TO 6 GENERATE
    parity_i(i) <= data(i * 2 + 1) XOR data(i * 2);
  END GENERATE;

  stage_2 :
  FOR i IN 0 TO 2 GENERATE
    parity_ii(i) <= parity_i(i * 2 + 1) XOR parity_i(i * 2);
  END GENERATE;
  parity_ii(3) <= parity_i(6) XOR data(14);

  stage_3 :
  FOR i IN 0 TO 1 GENERATE
    parity_iii(i) <= parity_ii(i * 2 + 1) XOR parity_ii(i * 2);
  END GENERATE;

  parity <=
    parity_iii(1) XOR parity_iii(0) WHEN test = '0' ELSE
    '0';
  packet <= data & parity;

END logic;