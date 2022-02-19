set_global_assignment -entity "scandubclk_pll" -library "lib_scandubclk_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "scandubclk_pll" -library "lib_scandubclk_pll" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "scandubclk_pll" -library "lib_scandubclk_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_scandubclk_pll" -name SPD_FILE [file join $::quartus(sip_path) "scandubclk_pll.spd"]

set_global_assignment -library "lib_scandubclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "scandubclk_pll_sim/scandubclk_pll.vo"]
