set_global_assignment -entity "clk_pll" -library "lib_clk_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clk_pll" -library "lib_clk_pll" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "clk_pll" -library "lib_clk_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clk_pll" -name SPD_FILE [file join $::quartus(sip_path) "clk_pll.spd"]

set_global_assignment -library "lib_clk_pll" -name MISC_FILE [file join $::quartus(sip_path) "clk_pll_sim/clk_pll.vo"]
