set gtpe2_channel [get_cells -hier -regexp .*aurora.*/gtpe2_i]
set rxsysclksel_pins [get_pins $gtpe2_channel/RXSYSCLKSEL]
#set txsysclksel_pins [get_pins $gtpe2_channel/TXSYSCLKSEL]
set old_net [get_nets -of_objects $rxsysclksel_pins]
set new_net [get_nets -of_objects [get_pins $gtpe2_channel/RX8B10BEN]]
disconnect_net -net $old_net -objects $rxsysclksel_pins
#disconnect_net -net $old_net -objects $txsysclksel_pins
connect_net -net $new_net -objects $rxsysclksel_pins
#connect_net -net $new_net -objects $txsysclksel_pins
get_nets -of_objects $rxsysclksel_pins
#get_nets -of_objects $txsysclksel_pins
