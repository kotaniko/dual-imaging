LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY blink IS
    PORT (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        LED : OUT STD_LOGIC
    );
END blink;

ARCHITECTURE Behavioral OF blink IS
    SIGNAL DATA_A : STD_LOGIC_VECTOR(24 DOWNTO 0);
BEGIN
    PROCESS (CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            DATA_A <= (OTHERS => '0');
        ELSIF (CLK'event AND CLK = '1') THEN
            DATA_A <= DATA_A + '1';
        END IF;
    END PROCESS;

    LED <= DATA_A(24);

END Behavioral;