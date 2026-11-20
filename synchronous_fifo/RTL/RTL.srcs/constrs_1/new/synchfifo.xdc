
# ============================================================
# Synchronous FIFO - Timing Constraints
# Target clock: 100 MHz
# Clock period: 10 ns
# ============================================================

# Primary system clock
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.200 [get_clocks sys_clk]
