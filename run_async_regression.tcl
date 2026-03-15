set RTL_DIR "../rtl"
set TB_DIR "../tb"
set LOG_DIR "log"
set LIB_NAME "work"

set seeds { 1 2 3 4 5 6 7 8 9 10}

file mkdir $LOG_DIR

puts "Preparing library $LIB_NAME ..."

# Remove existing library directory safely (OS-level)
if {[file exists $LIB_NAME]} {
    puts "Library exists – removing directory at OS level"
    catch {file delete -force $LIB_NAME}
}

vlib $LIB_NAME

vmap $LIB_NAME $LIB_NAME

#compile the RTL files
puts "Compiling RTL files..."

vlog -sv $RTL_DIR/flop_synchroniser.svh
vlog -sv $RTL_DIR/rptr_handle.svh
vlog -sv $RTL_DIR/wptr_handle.svh
vlog -sv $RTL_DIR/fifo_memory.svh
vlog -sv $RTL_DIR/asynchronous_fifo_top.svh

#compile TB file
vlog -sv $TB_DIR/async_fifo_TB.svh

set rpt [open "async_fifo_regression_report.txt" w]

puts $rpt "ASYNC FIFO REGRESSION REPORT"
puts $rpt "-----------------------------"
puts $rpt ""

foreach s $seeds {
    set log "$LOG_DIR/seed_${s}.log"
    
    puts "Running simulation with seed $s"
    puts $rpt "Seed $s :"

    vsim -c -sv_seed $s \
        $LIB_NAME.async_fifo_TB \
        -do "run -all" \
        -l $log
    
    set fh [open $log r]
    set txt [read $fh]
    close $fh

    if {[string match "*TEST_RESULT: PASS*" $txt]} {
        puts "   PASS"
        puts $rpt "   PASS"
    } else {
        puts "   FAIL"
        puts $rpt "   FAIL"
    }
    puts $rpt ""

}

puts $rpt "======================"
puts $rpt "Regression completed"
close $rpt

puts ""
puts "Regression finished successfully."
puts "Summary: fifo_regression_report.txt"
quit