library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aurora_8b10b_reset is
    Port ( clock            : in STD_LOGIC;
           peri_reset       : in STD_LOGIC;
           gt_reset     : out STD_LOGIC;
           system_reset : out STD_LOGIC);
end aurora_8b10b_reset;

architecture Behavioral of aurora_8b10b_reset is

  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO of clock: SIGNAL is "xilinx.com:signal:clock:1.0 clock CLK";
  ATTRIBUTE X_INTERFACE_INFO of peri_reset: SIGNAL is "xilinx.com:signal:reset:1.0 peri_reset RST";
  ATTRIBUTE X_INTERFACE_PARAMETER of peri_reset: SIGNAL is "POLARITY ACTIVE_HIGH";
  ATTRIBUTE X_INTERFACE_PARAMETER of gt_reset: SIGNAL is "POLARITY ACTIVE_HIGH";
  ATTRIBUTE X_INTERFACE_PARAMETER of system_reset: SIGNAL is "POLARITY ACTIVE_HIGH";

begin
  process (clock, peri_reset)
    variable counter : integer range 0 to 300;
  begin
    if (peri_reset = '1') then
        counter := 0;
        gt_reset <= '1';
        system_reset <= '1';
    elsif (clock'event and clock = '1') then
      if (counter = 0 and peri_reset = '0') then
        gt_reset <= '0';
        system_reset <= '1';
        counter := 1;
      elsif (counter = 128) then
        gt_reset <= '1';
      elsif (counter = 140) then
        gt_reset <= '0';
      elsif (counter = 268) then
        system_reset <= '0';
      end if;

      if (counter > 0 and counter <= 268) then
        counter := counter + 1;
      end if;

    end if;

  end process;

end Behavioral;
