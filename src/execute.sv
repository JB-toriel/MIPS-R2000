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

module forwarding_unit ( rs_id, rt_id, rd_ex, reg_write_ex, rd_wb, reg_write_wb, forward_a, forward_b);
  
  //Inputs declaration
  input [4:0] rs_id, rt_id, rd_ex, rd_wb;
  input reg_write_ex, reg_write_wb;
 
  //Outputs declaration
  output reg [1:0] forward_a, forward_b;
  
  //Actual code
  always_comb
    begin
		if ( reg_write_ex && rd_ex!=0 && rd_ex==rs_id ) 
			forward_a=2;
		else if ( reg_write_wb && rd_wb!=0 && rd_wb==rs_id )
			forward_a=1;
		else if ( ~reg_write_ex ) 
			forward_a=0;
      
		if ( reg_write_wb && rd_wb!=0 && rd_wb==rs_id ) 
			forward_b=2;
      	else if ( reg_write_wb && rd_wb!=0 && rd_wb==rs_id )
			forward_b=1;
      	else if ( reg_write_wb==1 ) 
			forward_b<=0;
      
    end
  
endmodule // End of module forwarding_unit

module execute_MUX_RTRD ( rt, rd, ex, write_register);

	//Inputs declaration
	input [4:0] rt, rd;
	input [3:0] ex;

	//Outputs declaration
	output reg [4:0] write_register;

	//Actual code
	assign write_register = ex[3] ? rd : rt;

endmodule // execute_MUX_RTRD

module ALU_ctrl_unit ( ALU_op, fnc_code, ALU_ctrl );

	// Inputs Declaration
	input [1:0] ALU_op;
	input [5:0] fnc_code;

	// Ouputs Declaration
	output reg [3:0] ALU_ctrl;

	// Variables declaration
	parameter ADD = 4'b0000;
	parameter SUB = 4'b0001;
	parameter AND = 4'b0010;
	parameter OR = 4'b0011;
	parameter SHFT_L = 4'b0111;
	parameter NOR = 4'b1001;

	// Code starts Here
	always @(ALU_op, fnc_code)
		begin
        	case(ALU_op)
            	0: ALU_ctrl <= ADD;
                1: ALU_ctrl <= SUB;
                2: begin 
					case(fnc_code)
						32: ALU_ctrl <= ADD; 	// ADD
						34: ALU_ctrl <= SUB; 	// SUB
						36: ALU_ctrl <= AND; 	// AND
						37: ALU_ctrl <= OR; 	// OR
						39: ALU_ctrl <= SHFT_L; // Set on less than
						42: ALU_ctrl <= NOR; 	// NOR
						default: ALU_ctrl <= 4'b1111; 
					endcase
                end
                //3: ALU_ctrl <= AND;    
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

	// Variables declaration
	parameter ADD = 4'b0000;
	parameter SUB = 4'b0001;
	parameter AND = 4'b0010;
	parameter OR = 4'b0011;
	parameter SHFT_L = 4'b0111;
	parameter NOR = 4'b1001;

	// Code starts Here
	assign zero = (res==0); // zero flag = 0 if the result is 0

	always @(ALU_ctrl, op_1, op_2)
		begin
			case(ALU_ctrl)
				   AND: res <=   op_1 & op_2; 		  // AND
				    OR: res <=   op_1 | op_2; 		  // OR
				   ADD: res <=   op_1 + op_2; 		  // ADD
				   SUB: res <=   op_1 - op_2; 		  // SUB
				SHFT_L: res <=   op_1 < op_2 ? 1 : 0; // Set on less than
				   NOR: res <= ~(op_1 | op_2); 	   	  // NOR
			   default: res <= 0;
			endcase
		end

endmodule // End of module ALU


module EX ( clk, data_1, data_2, rs, rt, rd, ex, m_EX, wb_EX, imm, zero, res, write_register, write_data_ex, m_MEM, wb_MEM/*, ...*/);

	// Inputs declaration
	input clk;
	input [4:0] rs, rt, rd;
	input [31:0] imm, data_1, data_2;
	input [3:0] ex;
	input [2:0] m_EX;
	input [1:0] wb_EX;

	// Outputs declaration
	output reg zero;
	output reg [31:0] res;
	output reg [4:0] write_register;
	output reg [2:0] m_MEM;
	output reg [1:0] wb_MEM;
	output reg [31:0] write_data_ex;


	// Variables declaration
	wire [1:0] forward_a, forward_b;
	wire [1:0] ALU_op;
	wire [3:0] ALU_ctrl;
	wire [5:0] fnc_code;
	wire [31:0] op_1, op_2, op_21;

	reg old_zero;
	reg [31:0] old_res;
	reg [4:0] old_write_register;

	// Code starts here
	assign ALU_op 	= ex[2:1];		  // 2 bits to select which operation to do with the ALU
	assign fnc_code = imm[5:0]; 	  // function code of R-type instructions
	
	assign op_1 	= forward_a==0 ? data_1 : (forward_a==1 ? write_data_ex : res);
	assign op_21 	= forward_b==0 ? data_2 : (forward_b==1 ? write_data_ex : res);
	assign op_2 	= ex[0] ? imm : op_21; // Mux to chose between "data_2" or the immediate sign extended

	execute_MUX_RTRD mux_RTRD ( rt, rd, ex, old_write_register);

	ALU_ctrl_unit alu_ctrl_unit(

  		.ALU_op 	(	ALU_op	  ), // input	 [1:0]
  		.fnc_code   (	fnc_code  ), // input	 [5:0]
  		.ALU_ctrl  	(	ALU_ctrl  )  // input	 [3:0]
	);

	ALU alu(

		.op_1 	  (	op_1		), // input	 [31:0]
		.sign_ext (	imm   		), // input	 [31:0]
		.op_2 	  (	op_2  		), // output [31:0]
		.ALU_ctrl (	ALU_ctrl	), // output [3:0]
		.zero 	  (	old_zero	), // output
		.res 	  (	old_res		)  // output [31:0]
	);
	
	forwarding_unit fw_unit ( rs, rt, old_write_register, wb_EX[0], write_register, wb_MEM[0], forward_a, forward_b);

	always_ff @ ( posedge clk ) begin
		m_MEM <= m_EX;
		wb_MEM <= wb_EX;
		res <= old_res;
		write_register <= old_write_register;
		zero <= old_zero;
		write_data_ex <= data_2;
	end

endmodule // End of module EX
