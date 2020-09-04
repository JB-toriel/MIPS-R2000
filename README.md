
# Design of the MIPS R2000

Design of a 5 stages pipeline MIPS R2000.

-------------------

## Language: 
* SystemVerilog


## Tools: 
* [Modelsim- Mentor Graphics](https://www.mentor.com/products/fv/modelsim/) - Modelisation and simulations
* [EDA Playground](https://www.edaplayground.com/) - Modelisation and simulations
* [SpyGlass Lint - Synopsis](https://www.synopsys.com/verification/static-and-formal-verification/spyglass/spyglass-lint.html) - Design analysis
* [Design vision - Synopsis](https://www.synopsys.com/implementation-and-signoff/rtl-synthesis-test/design-compiler-graphical.html) - Synthesis
* [Innovus - Cadence](https://www.cadence.com/en_US/home/tools/digital-design-and-signoff/soc-implementation-and-floorplanning/innovus-implementation-system.html) - Place & Root



## Directories:

#### Test Programs: These files are read by the ram in the Test Bench
- **./instructions.txt** : Test all the instructions excepte load and store ones (23 instructions)
- **./load_store.txt** : Test the load and store instructions (7 instructions)

- **./Fibonacci.txt** : Small programm that conpute the terms of Fibonacci sequence

#### Modules:
- **./src/** : Contains all the modules of stages
    + **TOP Module** ----------->  *./MIPS.sv*
    + **IF/ID satge** ------------->  *./fetch.sv*
    + **ID/EX stage** ------------> *./decode.sv* 
    + **EX/MEM stage** --------> *./execute.sv* 
    + **MEM/WB stage** -------> *./memory.sv* 
    + **WB** ---------------------->./writeback.sv/
 #### Test Bench:
 * **./test_bench/** : Contains all the test bench
    + ./test_bench.sv/
    
 #### SpyGlass Lint reports:
 * **./spyglass/** 
    + **Run summury** --------------->  *./Run_Summury.txt* : Spyglass run summuray
    + **Reports** ---------------------->  *./moresimple.rpt* : Spyglass report
    + **All spyglass project** -------->  *./spyglass.rar*
 #### Synthesis reports and netlist:
 * **./synthesis/** 
    + **Reports** ------------->  *./reports/* : Synthesis reports such as area, power, etc.
    + **Netlist** -------------->  *./netmips.v*
    + **Old reports** -------->  *./old_reports.rar* : Previous Synthesis reports
    
 ## Instruction set:
    + J, JAL, BEQ, BNE : Branches and Jumps (4)
    + ADDI, ADDIU, SLTIU, ANDIU, ANDI, ORI, XORI : Imediate Operations (7)
    + LB, LW, LHU, SB, SH, SW, LBU : Load and Store (7)
    + ADD, SUB, AND, OR, XOR, NOR, SLT, SLL, SRL, SRA, SRA, LUI : R-Type (12)
    + Total = 30 Instructions
    
---------------------------------

 ## Authors:
 * de Sainte Marie Nils & Edde Jean-Baptiste - Master's students at **Grenoble INP Phelma**


