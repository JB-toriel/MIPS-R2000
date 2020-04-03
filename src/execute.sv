//-----------------------------------------------------
	// This is design of the execution stage of the pipeline
	// Design Name : EX
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

module ALU_ctrl_unit ( ALU_op, fnc_code, ALU_ctrl );

	// Inputs Declaration
	input [1:0] ALU_op;
	input [5:0] fnc_code;

	// Ouputs Declaration
	output reg [3:0] ALU_ctrl;

	// Code starts Here
	always @ (ALU_op, fnc_code)

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

module ALU ( op_1, sign_ext, op_2, ALU_ctrl, zero, res );

	// Inputs Declaration
	input [3:0] ALU_ctrl;
	input [31:0] op_1, sign_ext, op_2;

	// Ouputs Declaration
	output zero;
	output reg [31:0] res;

	// Code starts Here
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


module EX ( data_1, data_2, ALU_ctrl, rs, rt, rd, ex, m_EX, wb_EX, imm, zero, res, write_register, m_MEM, wb_MEM/*, ...*/);

	// Inputs declaration
	input [4:0] rs, rt, rd;
	input [3:0] ALU_ctrl;
	input [31:0] imm, data_1, data_2;
	input reg [3:0] ex;
	input reg [2:0] m_EX;
	input reg [1:0] wb_EX;

	// Outputs declaration
	output zero;
	output reg [31:0] res;
	output reg [4:0] write_register;
	output reg [2:0] m_MEM;
	output reg [1:0] wb_MEM;

	// Variables declaration
	wire [1:0] ALU_op;
	wire [5:0] fnc_code;
	wire [31:0] op_2;


	// Code starts here
	assign ALU_op = ex[2:1];		  // 2 bits to select which operation to do with the ALU
	assign fnc_code = imm[5:0]; 	  // function code of R-type instructions
	assign op_2 = ex[0] ? imm : data_2; // Mux to chose between data_2 or the immediate sign extended

	execute_MUX_RTRD mux_RTRD ( rt, rd, ex, write_register);

	ALU_ctrl_unit alu_ctrl_unit(

  		.ALU_op 		(	ALU_op		), // input	 [1:0]
  		.fnc_code   (	fnc_code 	), // input	 [5:0]
  		.ALU_ctrl  	(	ALU_ctrl  )  // input	 [3:0]
	);

	ALU alu(

  	.op_1 		(	data_1		), // input	 [31:0]
  	.sign_ext (	imm   		), // input	 [31:0]
		.op_2 		(	op_2  		), // output [31:0]
		.ALU_ctrl (	ALU_ctrl	), // output [3:0]
		.zero 		(	zero			), // output
		.res 			(	res				)  // output [31:0]
	);



	always @ ( m_EX or wb_EX ) begin
		m_MEM <= m_EX;
		wb_MEM <= wb_EX;
	end

endmodule // End of module EX
