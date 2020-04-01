//-----------------------------------------------------
	// This is design of the execution stage of the pipeline
	// Design Name : IF
	// File Name   : execute.sv
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

module execute_MUX_DATA2 ( data_2, imm, ex, alu_op2);

	//Inputs declaration
	input [31:0] imm, data_2;
	input reg [3:0] ex;

	//Outputs declaration
	output reg [31:0] alu_op2;

	//Actual code
	always @ ( ex[0] ) begin
		case (ex[0])
			0: alu_op2 <= data_2;
			1: alu_op2 <= imm;
		endcase
	end
endmodule // execute_MUX_DATA1


module execute_MUX_RTRD ( rt, rd, ex, write_register);

	//Inputs declaration
	input [4:0] rt, rd;
	input reg [3:0] ex;

	//Outputs declaration
	output reg [4:0] write_register;

	//Actual code
	always @ ( ex[3] ) begin
		case (ex[3])
			0: assign write_register = rt;
			1: assign write_register = rd;
		endcase
	end
endmodule // execute_MUX_RTRD


module EX ( clk, data_1, data_2, rs, rt, rd, ex, m_EX, wb_EX, imm, res, write_register, alu_op2, m_MEM, wb_MEM/*, ...*/);

	//Inputs declaration
	input clk;
	input [4:0] rs, rt, rd;
	input [31:0] imm, data_1, data_2;
	input reg [3:0] ex;
	input reg [2:0] m_EX;
	input reg [1:0] wb_EX;

	//Outputs declaration
	output reg res;
	output reg [31:0] alu_op2;
	output reg [4:0] write_register;
	output reg [2:0] m_MEM;
	output reg [1:0] wb_MEM;

	//Actual code
	execute_MUX_DATA2 mux_DATA2 ( data_2, imm, ex, alu_op2);
	execute_MUX_RTRD mux_RTRD ( rt, rd, ex, write_register);

	always @ ( m_EX or wb_EX ) begin
		m_MEM <= m_EX;
		wb_MEM <= wb_EX;
	end

endmodule // End of EX module
