//-----------------------------------------------------
	// This is the test bench of th fetch stage design 
	// Design Name : fetch_tb
	// File Name   : fetch_tb.sv
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

module fetch_tb; 
  
	reg clk; 
	reg br, except;

	// for pc register
	reg [31:0] pc_out;

	// for pc mux
	reg [31:0] sign, fixed;
	
	parameter CLK_PERIOD = 10;
	
	always #(CLK_PERIOD/2.0) clk = ~clk;
	
	// Instantiation of design under test
	IF Instruction_fetch ( clk, sign, fixed, br, except, pc_out );

	// Test bench starts Here
	initial
		begin
			sign = 0; fixed = 0;
			br = 0; except = 0;
			clk = 1;
			#100
			$display( "End of simulation time is %d", $time );
			$finish(1);
		end

endmodule // End of Module fetch_tb
