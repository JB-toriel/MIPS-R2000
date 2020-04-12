//-----------------------------------------------------
	// This is design of the ALU
	// Design Name : ALU
	// File Name   : alu.sv
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

module ALU_ctrl_unit ( ALU_op, fnc_code, ALU_ctrl );

	// Inputs Declaration
	input [1:0] ALU_op;
	input [5:0] fnc_code;
	
	// Ouputs Declaration
	output reg [3:0] ALU_ctrl;

	// Code starts Here
	always 
		begin
			case(fnc_code)
				32: ALU_ctrl <= 4'b0010; // ADD
				34: ALU_ctrl <= 4'b0110; // SUB
				36: ALU_ctrl <= 4'b0000; // AND
				37: ALU_ctrl <= 4'b0001; // OR
				39: ALU_ctrl <= 4'b1100; // Set on less than
				42: ALU_ctrl <= 4'b0111; // NOR
				default: ALU_ctrl <= 4'b1111;  
			endcase			
		end

endmodule // End of module ALU_ctrl_unit

module ALU ( op_1, data_2, sign_ext, sel, op_2, ALU_ctrl, zero, res );

	// Inputs Declaration
	input sel;
	input [3:0] ALU_ctrl;
	input [31:0] op_1, data_2, sign_ext, op_2;
	
	// Ouputs Declaration
	output zero;
	output reg [31:0] res;

	// Code starts Here
	assign op_2 = sel ? sign_ext : data_2; // Mux to chose between data_2 or the immediate sign extended
	
	assign zero = (res==0); // zero flag = 0 if the result is 0
	
	always @(ALU_ctrl, op_1, op_2)
		begin
			case(ALU_ctrl)
				4'b0000: res <=   op_1 & op_2; 		   // AND
				4'b0001: res <=   op_1 | op_2; 		   // OR
				4'b0010: res <=   op_1 + op_2; 		   // ADD
				4'b0110: res <=   op_1 - op_2; 		   // SUB
				4'b0111: res <=   op_1 < op_2 ? 1 : 0; // Set on less than
				4'b1100: res <= ~(op_1 | op_2); 	   // NOR
			endcase			
		end

endmodule // End of module ALU

