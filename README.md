# Design of the MIPS R2000

Design of a 5 stages pipeline MIPS R2000.

-------------------

## Language: 
* SystemVerilog


## Tools: 
* [Modelsim](https://www.mentor.com/products/fv/modelsim/) - Modelisation and simulations
* [EDA Playground](https://www.edaplayground.com/) - Modelisation and simulations
* [SpyGlass Lint](https://www.synopsys.com/verification/static-and-formal-verification/spyglass/spyglass-lint.html) - Design analysis



## Directories:

##### Modules:
- **./src/** : Contains all the modules of stages
    + **IF/ID satge** ----------->  *./fetch.sv/*
    + **ID/EX stage** ----------> *./decode.sv/* 
    + **EX/MEM stage** ------> *./execute.sv/* 
    + **MEM/WB stage** ------> *./memory.sv/* 
    + **WB** ----------------------->./writeback.sv/
 ##### Test Bench:
 * **./test_bench/** : Contains all the test benches
    + ./test_bench.sv/
 
---------------------------------

 ## Authors:
 * de Sainte Marie Nils & Edde Jean-Baptiste - Fourth year Master's students at **Grenoble INP Phelma**


