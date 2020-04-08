//-----------------------------------------------------
	// This is the test bench of the fetch and decode stage design
	// Design Name : test_fetch
	// File Name   : test_fetch.sv
	// Function    :
	// Authors     : de Sainte Marie Nils - Edde Jean-Baptiste
//-----------------------------------------------------

/*
module NOM (LISTE DES PORTS);

DECLARATION DES PORTS
DECLARATION DES PARAMETRES

`include "NOM DE FICHIER";

DECLARATIONS DE VARIABLES
AFFECTATIONS
INSTANCIATIONS DE SOUS-MODULES
BLOCS initial ET always
TACHES ET FONCTIONS

endmodule
*/


module test_fetch;

	reg clk;

	//------For fetch stage------//

		// for pc registers
		reg [31:0] pc_out;
		reg [31:0] inst_out;

		// for pc mux
		reg br, except;
		reg [31:0] sign, fixed;

	//------For decode stage------//
		wire equal;
		// for register mapping
		wire [31:0] write_data_reg;
		wire reg_write;
		reg [4:0] write_register;
		wire [4:0] rs, rt, rd;
		wire [31:0] imm;
		reg [31:0] data_1, data_2;

		// for control unit
		logic jump;
		logic exception;
		reg [3:0] ex;
		reg [2:0] m;
		reg [1:0] wb;

	//------For execute stage------//
		reg [2:0] m_MEM;
		reg [1:0] wb_MEM;
		reg [31:0] res;
		reg zero;
		wire [3:0] ALU_ctrl;
		reg [31:0] write_data_ex;

	//------For memory stage------//
		reg [4:0] reg_WB, write_register_wb;
		reg [1:0] wb_WB;
		reg [31:0] address_WB, read_data;
		logic PCSrc;

	//------For WriteBack stage------//
		reg [4:0] write_register_WB;


	parameter CLK_PERIOD = 10;

	always #(CLK_PERIOD/2.0) clk = ~clk;

	// Instantiation of design under test
	IF instruction_fetch ( clk, sign, fixed, br, except, pc_out, inst_out );
	ID instruction_decode ( .clk(clk), .inst_in (inst_out), .write_register(write_register), .write_data_reg(write_data_reg), .reg_write(reg_write), .exception(exception),
	 			.jump(jump), .rs(rs), .rt(rt), .rd(rd), .imm(imm), .data_1(data_1), .data_2(data_2), .equal(equal), .wb(wb), .m(m), .ex(ex) );
  EX execute ( clk, data_1, data_2, rs, rt, rd, ex, m, wb, imm, zero, res, write_register, write_data_ex, m_MEM, wb_MEM );
	MEM memory ( clk, wb_MEM, m_MEM, zero, res, write_data_ex, write_register, wb_WB, read_data, address_WB, PCSrc, reg_WB );
	WB writeback ( clk, wb_WB, read_data, address_WB, reg_WB, write_data_reg, write_register_WB, reg_write );



	// Test bench starts Here
	initial
		begin
			sign = 0; fixed = 0;
			br = 0; except = 0;
			clk = 1;
			#100
			$display( "End of simulation time is %d", $time );
			$stop;
		end


endmodule // End of Module test_fetch
