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

#### Modules:
- **./src/** : Contains all the modules of stages
    + **TOP Module** ------------>  *./MIPS.sv/*
    + **IF/ID satge** ----------->  *./fetch.sv/*
    + **ID/EX stage** ----------> *./decode.sv/* 
    + **EX/MEM stage** ------> *./execute.sv/* 
    + **MEM/WB stage** ------> *./memory.sv/* 
    + **WB** ----------------------->./writeback.sv/
 #### Test Bench:
 * **./test_bench/** : Contains all the test bench
    + ./test_bench.sv/
    
 #### SpyGlass Lint reports:
 * **./spyglass/** 
 #### Synthesis reports:
 * **./synthesis/** 
---------------------------------

 ## Authors:
 * de Sainte Marie Nils & Edde Jean-Baptiste - Fourth year Master's students at **Grenoble INP Phelma**


