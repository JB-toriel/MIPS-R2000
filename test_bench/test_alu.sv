//-----------------------------------------------------
	// This is the test bench of the fetch and decode stage design
	// Design Name : test_ALU
	// File Name   : test_alu.sv
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


module test_ALU;

	reg clk;
	
	// Inputs
	reg sel;
	reg [3:0] ALU_ctrl;
	reg [31:0] op_1, data_2, sign_ext;
	
	wire [31:0] op_2;
	
	// Outputs
	reg zero;
	reg [31:0] res;

	parameter CLK_PERIOD = 10;

	always #(CLK_PERIOD/2.0) clk = ~clk;

	// Instantiation of design under test
	ALU alu ( op_1, data_2, sign_ext, sel, op_2, ALU_ctrl, zero, res );

	// Test bench starts Here
	initial
		begin
          	$dumpfile("dump.vcd"); 
			$dumpvars;
			op_1 <= 1;
			data_2 <= 2;
			sign_ext <= 3;
			clk <= 1;
			sel <= 0;
			ALU_ctrl = 0;  #5
			ALU_ctrl = 1;  #5
			ALU_ctrl = 2;  #5
			ALU_ctrl = 6;  #5
			ALU_ctrl = 7;  #5
			ALU_ctrl = 12; #5
			sel <= 1;	   
			ALU_ctrl = 0;  #5
			ALU_ctrl = 1;  #5
			ALU_ctrl = 2;  #5
			ALU_ctrl = 6;  #5
			ALU_ctrl = 7;  #5
			ALU_ctrl = 12; #5
			#1000
			$display( "End of simulation time is %d", $time );
			$stop;
		end

endmodule // End of Module test_fetch

