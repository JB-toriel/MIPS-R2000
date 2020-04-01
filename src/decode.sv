//-----------------------------------------------------
	// This is design of the decode stage of the pipeline
	// Design Name : ID
	// File Name   : decode.sv
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

module decode_REG_MAPP ( clk, rs, rt, rd, write_data, reg_write, data_1, data_2 );

	// Inputs Declaration
  	input clk, reg_write;
	input [4:0] rs, rt, rd;
  	input [31:0] write_data;
	
	// Ouputs Declaration
	output [31:0] data_1, data_2;
	
	
	//------Variable declaration------//
	reg [31:0] registers [0:31];
	integer i;
	
	// Code starts Here
	assign data_1 = registers[rs];
	assign data_2 = registers[rt];
  
  	always @(posedge clk)
    	begin
      		if(reg_write) registers[rd] <= write_data;
    	end
		
	initial
		begin
			for(i = 0; i < 32; i = i + 1)
				begin
					registers[i]=i;
				end
		end

endmodule // End of decode_REG_MAPP

module ID ( clk, inst_in, write_data, reg_write, rs, rt, rd, imm, data_1, data_2, /*, ...*/);
	
	// Inputs Declaration
  	input clk, reg_write;
	input [31:0] inst_in;
  	input [31:0] write_data;
	
	// Ouputs Declaration
	output  [32:0] imm;
	output  [32:0] data_1, data_2;
	output  [4:0] rs, rt, rd;
	
	// Code starts Here
  
	//assign opcode = inst_in[31:26];
	assign rs  = inst_in[25:21];
  	assign rt  = inst_in[20:16];
	assign rd  = inst_in[15:11];
	assign imm = {16'h0000, inst_in[15:0]};
	
	decode_REG_MAPP reg_MAPP(
      
      	.clk		( clk	 	 ),  // input
      	.rs 		( rs   	 	 ),  // input	[4:0]
      	.rt 		( rt    	 ),  // input	[4:0]
      	.rd 		( rd    	 ),  // input	[4:0]
      	.write_data ( write_data ),  // input   [31:0]
      	.reg_write 	( reg_write  ),  // input   [31:0]
      	.data_1 	( data_1 	 ),  // output  [31:0]
      	.data_2 	( data_2 	 )   // output  [31:0]
	);
	
endmodule // End of ID module
