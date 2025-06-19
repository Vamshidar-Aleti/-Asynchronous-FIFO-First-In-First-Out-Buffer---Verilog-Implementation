# Asynchronous-FIFO-First-In-First-Out-Buffer---Verilog-Implementation
This project implements an Asynchronous FIFO in Verilog with parameterized data and address widths. The design allows for data transfer between two clock domains using Gray code pointer synchronization, ensuring reliable communication between different frequency clocks.
✅ Features
Parameterizable DATA_WIDTH and ADDR_WIDTH

Dual-clock operation (wr_clk, rd_clk)

Gray code conversion for metastability protection

Full and Empty flag generation

Synchronized read/write pointers across clock domains

Clear separation between write and read logic

Testbench with:

Reset validation

Full/empty conditions

Write, read, and simultaneous operations

Waveform dump support for GTKWave

📁 Files Included
async_fifo.v: RTL implementation of the asynchronous FIFO

async_fifo_tb.v: Testbench verifying FIFO functionality

async_fifo_tb.vcd: Optional VCD output for waveform viewing

🛠️ Tools Used
Simulator: Any Verilog simulator (tested on Icarus Verilog & ModelSim)

Waveform Viewer: GTKWave (optional for .vcd)
