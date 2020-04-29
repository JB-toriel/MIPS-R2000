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


module MEM ( clk, ram_word, wb_MEM, m, address_MEM, write_data_mem, write_register_ex, wb, read_data, address_WB, write_register_mem, ram_data, ram_adr, ram_read, ram_write );

	//Inputs declaration
	input clk;
	input [1:0] m;
	input [1:0] wb_MEM;
	input [4:0] write_register_ex;
	input [31:0] address_MEM, write_data_mem;
	input [31:0] ram_word;

	//Outputs declaration
	output ram_read, ram_write;
	output reg [31:0] read_data, address_WB;
	output reg [1:0] wb;
	output reg [4:0] write_register_mem;
	output [31:0] ram_data;
	output [31:0] ram_adr;

	//Variables DECLARATION
	wire [31:0] old_address_WB;
	wire [31:0] old_read_data;


	//------Code starts Here------//
	assign old_address_WB = address_MEM;
	assign old_read_data = ram_word;
	assign ram_read = m[1];
	assign ram_write = m[0];
  assign ram_adr = address_MEM;
	assign ram_data = write_data_mem;

  always_ff @ ( posedge clk )
		begin
			wb <= wb_MEM;
			write_register_mem <= write_register_ex;
			address_WB <= old_address_WB;
			read_data <= old_read_data;
		end

endmodule // End of MEM module
