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
		
		// for register mapping
		wire write_data;
		wire reg_write;
		wire [4:0] rs, rt, rd;
		wire [31:0] imm;
		wire [31:0] data_1, data_2;


	parameter CLK_PERIOD = 10;

	always #(CLK_PERIOD/2.0) clk = ~clk;

	// Instantiation of design under test
	IF instruction_fetch ( clk, sign, fixed, br, except, pc_out, inst_out );
	ID Instruction_decode ( .clk(clk), .inst_in (inst_out), .write_data(write_data), .reg_write(reg_write), .rs(rs), .rt(rt), .rd(rd), .imm(imm), .data_1(data_1), .data_2(data_2)/*, ...*/);

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

