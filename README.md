# sMDT_FPGA
FPGA development for sMDT cosmic ray station. Currently, the Arty A7 makes coincidence logic for the cosmic ray test of Michigan State sMDT mini-chamber using two pieces of scintillator. The aim is to allow the FPGA board to record sMDT data (within the mini-chamber) to output data on muon trajectory. The hardware needed is 1 Arty A7 FPGA board. 


## Tutorial
Please refer to the tutorial branch if you are not familiar with FPGA.

Some material which are helpful for starting FPGA programming:

1.[Arty A7 reference manual](https://digilent.com/reference/programmable-logic/arty-a7/reference-manual)

2.[VHDL introduction](https://faculty-web.msoe.edu/johnsontimoj/EE3921/files3921/Book_FreeRangeVHDL.pdf): The code will mainly in VHDL language. So refer to this 'Free Range HDL' to learn how to write VHDL.

In the tutorial branch, the project create the AND logic controlled by the switches on the borad. If the sw[0] and sw[1](see the notation in the mannul or on the board) are on the led[0] will be on.

### Preparation

The hardware needed in this tutorial will be the Arty A7 FPGA borad and a micro-b USB cable that can transfer data. Download the Vivado on computer and put all file under a new project.

### Run

First step is to run synthesis in vivado, run implementation, and generate bitstream. Connect the device to the computer using the micro-USB cable. When the power light is on, go to the device manager in vivado and auto-connect the board. Finally, select Program Device on the top of the window. 

### Data

The data for the current programming logic can be found in the two_scintillator branch of this repository. You can find more information in that branch's ReadMe file. 
