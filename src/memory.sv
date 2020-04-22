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


module MEM ( clk, ram, wb_MEM, m, address_MEM, write_data_mem, write_register_ex, wb, read_data, address_WB, write_register_mem/*, ...*/ );

	//Inputs declaration
	input clk;
	input [1:0] m;
	input [1:0] wb_MEM;
	input [4:0] write_register_ex;
	input [31:0] address_MEM, write_data_mem;
	input reg [31:0] ram [0:31];

	//Outputs declaration
	output reg [31:0] read_data, address_WB;
	output reg [1:0] wb;
	output reg [4:0] write_register_mem;

	//Variables DECLARATION
	integer i;
	wire [31:0] old_address_WB;
	reg [31:0] old_read_data;


	//------Code starts Here------//
	assign old_address_WB = address_MEM;

	always_comb
		begin
			if (m[1]) old_read_data = ram[address_MEM];
			if (m[0]) ram[address_MEM] = write_data_mem;
		end

	always_ff @ ( posedge clk )
		begin
			wb <= wb_MEM;
			write_register_mem <= write_register_ex;
			address_WB <= old_address_WB;
			read_data <= old_read_data;
		end

endmodule // End of MEM module
