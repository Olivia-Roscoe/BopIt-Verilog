
vlib work
vlog ProjectWeek1.v rateDivision.v inputCheck.v fill.v
vsim ProjectWeek1
log {/*}
add wave {/*}
add wave {sim:/ProjectWeek1/d1/*}
add wave {sim:/ProjectWeek1/i1/*}
add wave {sim:/ProjectWeek1/f1/*}
add wave {sim:/ProjectWeek1/f1/*}

force {CLOCK_50} 0 0ns , 1 {10ns} -r 20ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1

run 5 ns
force {KEY[0]} 0
run 25 ns
force {KEY[0]} 1
run 20 ns


force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 0
run 30 ns
force {KEY[3]} 1
run 70 ns

force {KEY[1]} 0
run 30 ns
force {KEY[1]} 1
run 70 ns

force {KEY[2]} 0
run 30 ns
force {KEY[2]} 1
run 80 ns

force {KEY[1]} 0
run 55 ns
force {KEY[1]} 1
run 70 ns

force {KEY[3]} 0
run 30 ns
force {KEY[3]} 1
run 70 ns



run 4000 ns
