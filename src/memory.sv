//-----------------------------------------------------
	// This is design of the memory stage of the pipeline
	// Design Name : IF
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


module MEM ( wb_MEM, m, zero, address_MEM, write_data_mem, reg_MEM, wb, read_data, address_WB, PCSrc, reg_WB/*, ...*/);

	//Inputs declaration
	input reg [2:0] m;
	input reg [1:0] wb_MEM;
	input reg [4:0] reg_MEM;
	input logic zero;
	input reg [31:0] address_MEM, write_data_mem;

	//Outputs declaration
	output reg [31:0] read_data, address_WB;
	output reg [1:0] wb;
	output reg [4:0] reg_WB;
	output logic PCSrc;

	//Variables DECLARATION
	reg [31:0] memory [0:31];
	integer i;
	initial
    begin
      for(i = 0; i < 32; i = i + 1)
        begin
          memory[i]=i;
        end
  	end

	//Actual code
	assign PCSrc = ( m[2] & zero);
	assign address_WB = address_MEM;
	assign reg_WB = reg_MEM;
	assign wb = wb_MEM;


	always @ ( m ) begin
		if (m[1]) read_data <= memory[address_MEM];
		if (m[0]) memory[address_MEM] = write_data_mem;
	end




endmodule // End of MEM module
