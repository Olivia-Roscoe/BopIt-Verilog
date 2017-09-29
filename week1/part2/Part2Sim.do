# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog fill.v

#load simulation using mux as the top level simulation module
vsim fill



#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {CLOCK_50} 0 0ns, 1 {10ns} -r 20ns
force {KEY[0]} 0
run 25 ns 

#Case 1: Create a Red 4X4 pixel at 32X32, then clear everything
force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1
force {SW[9]} 1
force {SW[8]} 0
force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 20 ns

force {KEY[3]} 0
run 20 ns

force {KEY[3]} 1
force {SW[9]} 1
force {SW[8]} 0
force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 20 ns

force {KEY[1]} 0
run 20 ns

force {KEY[1]} 1
force {SW[9]} 1
force {SW[8]} 0
force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 500 ns

force {KEY[2]} 0
run 20ns

force {KEY[2]} 1
run 500 ns

#Case 1 ends here