//-----------------------------------------------------
	// This is design of the writeback stage of the pipeline
	// Design Name : WB
	// File Name   : writeback.sv
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


module WB ( clk, wb, read_data, address_WB, write_register_mem, write_data_reg, write_register, reg_write/*, ...*/ );

	//Inputs declaration
	input clk;
	input [31:0] read_data, address_WB;
	input [1:0] wb;
	input [4:0] write_register_mem;

	//Outputs declaration
	output  [31:0] write_data_reg;
	output  [4:0] write_register;
	output reg_write;


	//------Code starts Here------//
	assign reg_write = wb[1];
	assign write_data_reg = wb[0] ? read_data : address_WB; 
	assign write_register = write_register_mem;

endmodule // End of WB module
