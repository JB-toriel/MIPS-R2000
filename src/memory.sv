//-----------------------------------------------------
	// This is design of the memory stage of the pipeline
	// Design Name : MEM
	// File Name   : memory.sv
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

/*
	Inputs : internally must always be of type net, externally the inputs can be connected to a variable of type reg or net.
	Outputs : internally can be of type net or reg, externally the outputs must be connected to a variable of type net.
	Inouts : internally or externally must always be type net, can only be connected to a variable net type.
*/


module MEM ( clk, wb_MEM, m, zero, address_MEM, write_data_mem, write_register_ex, wb, read_data, address_WB, write_register_mem/*, ...*/ );

	//Inputs declaration
	input clk;
	input [2:0] m;
	input [1:0] wb_MEM;
	input [4:0] write_register_ex;
	input zero;
	input [31:0] address_MEM, write_data_mem;

	//Outputs declaration
	output reg [31:0] read_data, address_WB;
	output reg [1:0] wb;
	output reg [4:0] write_register_mem;

	//Variables DECLARATION
	integer i;
	reg [31:0] old_read_data, old_address_WB;
	reg [31:0] memory [0:31];


	//------Code starts Here------//
	initial
		begin
			for(i = 0; i < 32; i = i + 1)
				memory[i]=i;
			memory[31] = 32'hFFFF_FFFF;
		end

	assign old_address_WB = address_MEM;

	always @ ( m )
		begin
			if (m[1]) old_read_data <= memory[address_MEM];
			if (m[0]) memory[address_MEM] = write_data_mem;
		end

	always_ff @ ( posedge clk )
		begin
			wb <= wb_MEM;
			write_register_mem <= write_register_ex;
			address_WB <= old_address_WB;
			read_data <= old_read_data;
		end

endmodule // End of MEM module
