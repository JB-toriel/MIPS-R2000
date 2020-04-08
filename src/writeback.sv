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


module WB ( clk, wb, read_data, address_WB, reg_WB, write_data_reg, write_register, reg_write/*, ...*/);
	input clk;

	//Inputs declaration
	input reg [31:0] read_data, address_WB;
	input reg [1:0] wb;
	input reg [4:0] reg_WB;

	//Inputs declaration
	output [31:0] write_data_reg;
	output [4:0] write_register;
	output logic reg_write;

	reg [31:0] write_data_reg;
	reg [4:0] write_register;

	//Actual code
	assign reg_write = wb[1];
	assign old_write_data_reg = wb[0] ? read_data : address_WB; // Mux to chose between data_2 or the immediate sign extended
	assign old_write_register = reg_WB;

	always_ff @ (posedge clk) begin
		write_register <= old_write_register;
		write_data_reg <= old_write_data_reg;
	end

endmodule // End of WB module
