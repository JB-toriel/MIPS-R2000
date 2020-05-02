//-----------------------------------------------------
	// This is the TOP level design of the processor
	// Design Name : MIPS
	// File Name   : MIPS.sv
	// Function    :
	// Authors     : de Sainte Marie Nils - Edde Jean-Baptiste
//-----------------------------------------------------

/*
module NAME (PORTS LIST);

	PORTS DECLARATION
	VARIABLES DECLARATION

	MODULES INSTANTIATION
	ASSIGNMENT
	initial AND always BLOCS
	TASKS AND FUNCTIONS

endmodule
*/


module MIPS (clk, rst, pc_rom, inst_rom, ram_size, ram_read, ram_write, ram_data, ram_word, ram_adr);


  //Inputs Declaration
    input clk, rst;
    //ROM
    input [31:0] inst_rom;
    //RAM
    input [31:0] ram_word;

  //Outputs Declaration
    //ROM
    output [31:0] pc_rom;
    //RAM
    output [1:0] ram_size;
    output ram_read, ram_write;
    output [31:0] ram_data;
    output [31:0] ram_adr;

  //Variables declaration

    //------For fetch stage------//


    //------For memory stage-----//

      // for pc registers
      reg hold_pc, hold_if;
      reg [31:0] pc_out;
      reg [31:0] inst_out;

    //------For decode stage------//

      wire br;
      reg [31:0] pc_ex;
      // for register mapping
      wire [31:0] write_data_reg;
      wire reg_write;
      reg [4:0] write_register;
      wire [4:0] rs, rt, rd;
      wire [31:0] imm, pc_branch;
      reg [31:0] data_1, data_2;

    //------For control unit------//

      reg jump;
      reg exception;
      reg [5:0] ex;
      reg [3:0] m;
      reg [1:0] wb;
      reg flush_ex;

    //------For execute stage------//

      reg [3:0] m_MEM;
      reg [1:0] wb_MEM;
      reg [31:0] res;
      reg [31:0] write_data_ex;
      reg [4:0] write_register_ex;
      wire zero, over;

    //------For memory stage------//

      reg [4:0] write_register_mem;
      reg [1:0] wb_WB;
      reg [31:0] address_WB, read_data;

    //------For WriteBack stage------//



  //------Modules Instantiation------//
  IF instruction_fetch ( clk, inst_rom, rst, hold_pc, hold_if, pc_branch, br, exception, pc_rom, pc_out, inst_out );

  ID instruction_decode ( .clk(clk), .rst(rst), .pc(pc_out), .inst_in (inst_out), .write_register(write_register),
              .write_data_reg(write_data_reg), .reg_write(reg_write), .exception(exception),
              .jump(jump), .rs(rs), .rt(rt), .rd(rd), .imm(imm), .data_1(data_1), .data_2(data_2),
              .flush_id(over), .wb(wb), .m(m), .ex(ex), .pc_branch(pc_branch), .br(br), .hold_pc(hold_pc),
              .hold_if(hold_if), .flush_ex(flush_ex), .pc_ex(pc_ex)
              );

  EX execute ( clk, pc_ex, data_1, data_2, rs, rt, rd, ex, m, wb, wb_WB[1], write_register_mem, flush_ex, write_data_reg, imm, zero, over, res, write_register_ex, write_data_ex, m_MEM, wb_MEM );

  MEM memory ( clk, ram_word, wb_MEM, m_MEM, res, write_data_ex, write_register_ex, wb_WB, read_data, address_WB, write_register_mem, ram_data, ram_adr, ram_read, ram_write, ram_size );


  WB writeback ( wb_WB, read_data, address_WB, write_register_mem, write_data_reg, write_register, reg_write );

endmodule
