Here is a README.md file description for your repository, incorporating the project details and a dedicated section for the regression testing script.

# Asynchronous FIFO in SystemVerilog
## Project Overview
This repository contains the RTL implementation and verification environment for an Asynchronous FIFO (First-In-First-Out) designed in SystemVerilog. An asynchronous FIFO is crucial for safely transferring data across two different, unsynchronized clock domains (read and write) without data loss or metastability issues.

The design relies on converting binary pointers to Gray code before passing them through a synchronization stage to ensure only one bit changes at a time, minimizing the risk of synchronization failures.

## Architecture and Modules
The architecture is modularly divided into several SystemVerilog files:

asynchronous_fifo_top.svh: The top-level wrapper that instantiates and connects all the sub-modules.

fifo_memory.svh: A dual-port RAM structure that stores the incoming data.

**wptr_handle.svh**: Manages the write pointer, converts it to Gray code, and computes the full flag to prevent overflow.

rptr_handle.svh: Manages the read pointer, converts it to Gray code, and computes the empty flag to prevent reading garbage data.

flop_synchroniser.svh: A 2-stage flip-flop synchronizer used to pass the read and write pointers safely across the asynchronous clock domains.

async_fifo_TB.svh: The testbench environment that verifies the design. It uses dynamically randomized clock periods for both the read and write clocks to thoroughly test the asynchronous boundaries. It pushes data into a queue and compares popped data against expected values.

## Regression Testing
To ensure the design's robustness under various timing conditions, the project includes an automated regression testing flow managed by a TCL script (run_async_regression.tcl).

## How the Script Works
The TCL script automates the compilation, simulation, and reporting steps for ModelSim/QuestaSim environments. It tests the FIFO against multiple random seed values to guarantee that corner cases are caught over varied random clock frequencies.

### Environment Setup: 
The script defines the directories for RTL, Testbench (TB), and logs. It safely clears any previous work libraries and initializes a fresh one.

### Compilation: 
It explicitly compiles all SystemVerilog RTL files (flop_synchroniser.svh, rptr_handle.svh, wptr_handle.svh, fifo_memory.svh, asynchronous_fifo_top.svh) and the testbench file.

### Multi-Seed Simulation: 
The script loops over an array of 10 distinct seeds (1 through 10). For each seed, it launches a command-line simulation (vsim -c) utilizing the seed to randomize the read and write clock periods.

### Log Analysis: 
Simulation output for each seed is piped to a dedicated log file (seed_X.log). The script parses these logs dynamically to search for the string TEST_RESULT: PASS.

## Running the Regression
To run the regression, simply execute the TCL script in your simulation environment:

### Tcl
source run_async_regression.tcl
Upon completion, review the printed console summary or open async_fifo_regression_report.txt to verify that all seeds passed successfully.

## Report Generation: 
After all seeds complete, the script produces a centralized summary file named async_fifo_regression_report.txt. This report lists each seed and indicates whether the simulation run resulted in a PASS or FAIL.

Running the Regression
