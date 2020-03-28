//-----------------------------------------------------
	// This is design of the fetch stage of the pipeline
	// Design Name : IF
	// File Name   : fetch.sv
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

module decode_REG_MAPP ( rs, rt, rd, data_1, data_2 );

	// Inputs Declaration
	input [4:0] rs, rt, rd;
	
	// Ouputs Declaration
	output reg [31:0] data_1, data_2;
	
	
	//------Variable declaration------//
	reg [31:0] registers [0:31];
	integer i;
	
	// Code starts Here
	always @(rs or rt)
		begin
			data_1 <= registers[rs];
			data_2 <= registers[rt];
		end
		
	initial
		begin
			for(i = 0; i < 32; i = i + 1)
				begin
					registers[i]=i;
				end
		end

endmodule // End of decode_REG_MAPP

module ID ( inst_in, rs, rt, rd, imm, data_1, data_2/*, ...*/);
	
	// Inputs Declaration
	input [31:0] inst_in;
	
	// Ouputs Declaration
	output reg [32:0] imm;
	output reg [32:0] data_1, data_2;
	output reg [4:0] rs, rt, rd;
	
	// Code starts Here
  	always @(inst_in)
		begin
			//opcode <= inst_in[31:26];
			rs  <= inst_in[25:21];
			rt  <= inst_in[20:16];
			rd  <= inst_in[15:11];
			imm <= {16'h0000, inst_in[15:0]};
		end
	
	decode_REG_MAPP reg_MAPP(

		.rs 	(	rs   ),  // input	[4:0]
  		.rt 	(	rt   ),  // input	[4:0]
		.rd 	(	rd   ),  // input	[4:0]
		.data_1 ( data_1 ),  // output [31:0]
		.data_2 ( data_2 )   // output [31:0]
	);
	
endmodule // End of ID module
