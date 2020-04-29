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


module forwarding_unit ( rs_id, rt_id, rd_ex, reg_write_ex, rd_wb, reg_write_wb, forward_a, forward_b );

	//Inputs declaration
	input [4:0] rs_id, rt_id, rd_ex, rd_wb;
	input reg_write_ex, reg_write_wb;

	//Outputs declaration
	output [1:0] forward_a, forward_b;

	//Variables declaration
	reg [1:0] fw_a, fw_b;


	//------Code starts Here------//
	always_comb
		begin
			fw_a = 0;
			fw_b = 0;

			if ( reg_write_ex && (rd_ex!=0) && (rd_ex==rs_id) )
				fw_a = 2;
			if ( reg_write_wb && (rd_wb!=0) && rd_ex!=rs_id && rd_wb==rs_id )
				fw_a = 1;
			if ( reg_write_ex && (rd_ex!=0) && (rd_ex==rt_id) )
				fw_b = 2;
			if ( reg_write_wb && (rd_wb!=0) && rd_ex!=rt_id && rd_wb==rt_id )
				fw_b = 1;
		end

	assign forward_a = fw_a;
	assign forward_b = fw_b;

endmodule // End of module forwarding_unit


module execute_MUX_RTRD ( rt, rd, ex, write_register );

	//Inputs declaration
	input [4:0] rt, rd;
	input [5:0] ex;

	//Outputs declaration
	output [4:0] write_register;


	//------Code starts Here------//
	assign write_register = ( ex == 6'b001110 ) ? rd : (ex[5] ? rd : rt);

endmodule // End of module execute_MUX_RTRD


module ALU_ctrl_unit ( ALU_op, fnc_code, ALU_ctrl );

	//Inputs Declaration
	input [3:0] ALU_op;
	input [5:0] fnc_code;

	//Ouputs Declaration
	output reg [3:0] ALU_ctrl;

	//Variables declaration
	parameter ADD = 4'b0000;
	parameter SUB = 4'b0001;
	parameter AND = 4'b0010;
	parameter  OR = 4'b0011;
	parameter XOR = 4'b0100;
	parameter NOR = 4'b0101;
	parameter SLT = 4'b0110;
	parameter SLL = 4'b1010;
	parameter SRL = 4'b1011;
	parameter SRA = 4'b1100;
	parameter LUI = 4'b1101;


	//------Code starts Here------//
	always_comb
		begin
        	case( ALU_op )
				0: ALU_ctrl = ADD;
				1: ALU_ctrl = SUB;
				2: begin
						case(fnc_code)
							0: ALU_ctrl = SLL; // Shift left logical
							2: ALU_ctrl = SRL; // rigth
							3: ALU_ctrl = SRA; // Arithmetic
							4: ALU_ctrl = SLL; // Shift left logical
							6: ALU_ctrl = SRL; // rigth
							7: ALU_ctrl = SRA; // Arithmetic
							32: ALU_ctrl = ADD; // ADD
							6'b100001: ALU_ctrl = ADD; // ADDU
							34: ALU_ctrl = SUB; // SUB
							36: ALU_ctrl = AND; // AND
							37: ALU_ctrl = OR;  // OR
							38: ALU_ctrl = XOR;
							39: ALU_ctrl = NOR; // NOR
							42: ALU_ctrl = SLT; // Set on less than
							default: ALU_ctrl = 4'b1111;
						endcase
					end
				3: ALU_ctrl = AND;
				4: ALU_ctrl = OR;
				5: ALU_ctrl = SLT;
				6: ALU_ctrl = LUI;
				7: ALU_ctrl = ADD;
				default: ALU_ctrl = 4'b1111;
			endcase
		end

endmodule // End of module ALU_ctrl_unit


module ALU ( op_1, fnc_code, op_2, ALU_ctrl, zero, over, res );

	//Inputs Declaration
	input [3:0] ALU_ctrl;
	input [5:0] fnc_code;
	input [31:0] op_1, op_2;

	//Ouputs Declaration
	output zero;
	output reg over;
	output reg [31:0] res;

	//Variables declaration
	parameter ADD = 4'b0000;
	parameter SUB = 4'b0001;
	parameter AND = 4'b0010;
	parameter  OR = 4'b0011;
	parameter XOR = 4'b0100;
	parameter NOR = 4'b0101;
	parameter SLT = 4'b0110;
	parameter SLL = 4'b1010;
	parameter SRL = 4'b1011;
	parameter SRA = 4'b1100;
	parameter LUI = 4'b1101;



	//------Code starts Here------//
	assign zero = (res==0); // zero flag = 0 if the result is 0

	always_comb
		begin
			case(ALU_ctrl)
				AND: res =   	op_1 & op_2;
				OR:  res =   	op_1 | op_2;
				ADD: res = 		op_1 + op_2;
				SUB: res = 		op_1 - op_2;
				XOR: res = 		op_1 ^ op_2;
				NOR: res =    ~(op_1 | op_2);
				SLT: res =   	op_1 < op_2 ? 1 : 0;  // Set on less than
				SLL: res =	  op_2 << op_1;
				SRA: res =	 	op_2 >>> op_1;
				SRL: res =	 	op_2 >> op_1;
				LUI: res = 		op_2 << 16;
			   default: res = 0;
			endcase
			if( fnc_code==32 || fnc_code==34 )
				over = (op_1[31] == op_2[31]) && (res[31] == ~op_1[31]);
			else
				over = 0;
		end

endmodule // End of module ALU


module EX ( clk, pc, data_1, data_2, rs, rt, rd, ex, m_EX, wb_EX, wb_WB, rd_WB, flush_ex, write_data_reg, imm, zero, over, res, write_register_ex, write_data_ex, m_MEM, wb_MEM/*, ...*/ );

	// Inputs declaration
	input clk;
	input [31:0] pc;
	input [4:0] rs, rt, rd, rd_WB;
	input [31:0] imm, data_1, data_2;
	input [5:0] ex;
	input [2:0] m_EX;
	input wb_WB;
	input [1:0] wb_EX;
	input flush_ex;
  input [31:0] write_data_reg;

	//Outputs declaration
	output reg zero;
  output over;
	output reg [31:0] res;
	output reg [4:0] write_register_ex;
	output reg [2:0] m_MEM;
	output reg [1:0] wb_MEM;
	output reg [31:0] write_data_ex;


	//Variables declaration
	wire overflow, old_zero;
	wire [1:0] forward_a, forward_b;
	wire [3:0] ALU_op;
	wire [3:0] ALU_ctrl;
	wire [5:0] fnc_code;
	reg [31:0] op_1, op_2, op_21;
	wire [3:0] m_EX_mux;
	wire [2:0] wb_EX_mux;

	reg [31:0] old_res;
	reg [4:0] old_write_register_ex;


	//------Modules Instantiation------//
	execute_MUX_RTRD mux_RTRD ( rt, rd, ex, old_write_register_ex );

	ALU_ctrl_unit alu_ctrl_unit(

  		.ALU_op   	(	ALU_op	  ), // input	 [2:0]
  		.fnc_code   (	fnc_code  ), // input	 [5:0]
  		.ALU_ctrl  	(	ALU_ctrl  )  // input	 [3:0]
	);

	ALU alu(

		.op_1 	  (	op_1		  ), // input	 [31:0]
		.fnc_code (	imm[5:0]	), // input	 [31:0]
		.op_2 	  (	op_2  		), // output [31:0]
		.ALU_ctrl (	ALU_ctrl	), // output [3:0]
		.zero 	  (	old_zero	), // output
		.over 	  (	overflow	    ), // output
		.res 	  	(	old_res		)  // output [31:0]

	);

	forwarding_unit fw_unit ( rs, rt, write_register_ex, wb_MEM[1], rd_WB, wb_WB, forward_a, forward_b );


	//------Code starts Here------//
	assign over = ex==6'b100100 ? overflow : 0;
	assign ALU_op 	= ex[4:1];		  // 2 bits to select which operation to do with the ALU
	assign fnc_code = imm[5:0]; 	  // function code of R-type instructions

	always_comb
		begin
			if ( ex == 6'b001110 ) begin
				op_1 = pc;
				op_21 = 8;
			end
			else
				begin
					if ( ex == 6'b100100 && fnc_code <= 3 )
						op_1 = imm[10:6];
					else
						begin
							case(forward_a)
								0: op_1 = data_1;
								1: op_1 = write_data_reg;
								2: op_1 = res;
								default: op_1 = data_1;
							endcase
						end
					case(forward_b)
						0: op_21 = data_2;
						1: op_21 = write_data_reg;
						2: op_21 = res;
						default: op_21 = data_2;
					endcase
				end
				case(ex[0])
						1: op_2 = imm;
						0: op_2 = op_21;
						default: op_2 = op_21;
					endcase
			end

	assign m_EX_mux  = flush_ex ? 0 : m_EX;
	assign wb_EX_mux = flush_ex ? 0 : wb_EX;

	always_ff @( posedge clk )
		begin
			m_MEM <= m_EX_mux;
			wb_MEM <= wb_EX_mux;
			res <= old_res;
			write_register_ex <= old_write_register_ex;
			zero <= old_zero;
			write_data_ex <= op_21;
		end

endmodule // End of module EX
