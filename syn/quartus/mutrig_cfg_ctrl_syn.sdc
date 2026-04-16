create_clock -name controller_clk -period 5.818 [get_ports {controller_clk}]
create_clock -name spi_clk -period 22.727 [get_ports {spi_clk}]

set_clock_groups -asynchronous \
    -group [get_clocks {controller_clk}] \
    -group [get_clocks {spi_clk}]
