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


module decode_HAZARD_UNIT ( rt_id, rs_id, rt_ex, mem_Read, mux_ctrl_unit, hold_pc, hold_if );

	//Inputs declaration
	input [4:0] rt_id, rs_id, rt_ex;
	input mem_Read;

	//Outputs declaration
	output reg mux_ctrl_unit;
	output reg hold_pc, hold_if;

	//------Code starts Here------//
	always_comb
		begin
			hold_pc = 0;
			hold_if = 0;
			mux_ctrl_unit = 0;

			if ( mem_Read && (rt_ex==rs_id || rt_ex==rt_id) )
				begin
					hold_pc = 1;
					hold_if = 1;
					mux_ctrl_unit = 1;
				end
		end

endmodule // End of module decode_HAZARD_UNIT


module decode_REG_MAPP ( clk, rst, rs, rt, write_register, write_data_reg, reg_write, data_1, data_2 );

	//Inputs declaration
	input clk, rst;
	input [4:0] rs, rt;
	input reg_write;
	input [4:0] write_register;
	input [31:0] write_data_reg;

	//Outputs declaration
	output [31:0] data_1, data_2;

	//Variables declaration
	reg [31:0] reg_file [0:31];
	integer i;


	//------Code starts Here------//

	assign data_1 = reg_file[rs];//Read process
	assign data_2 = reg_file[rt];

	always_ff @ (posedge clk, posedge rst) begin //Write process
		if (rst) begin
			for (int i = 0; i < 31; i++) begin
				reg_file[i] = 0;
			end
		end
		else if (~rst) begin
			if (reg_write) begin
				reg_file[write_register] <= write_data_reg;
			end
		end
	end

endmodule // End of module decode_REG_MAPP module


module decode_CONTROL_UNIT ( inst_in, mux_ctrl_unit, flush_id, exception, jump, flush_ex, wb, m, ex );

	//Inputs declaration
	input mux_ctrl_unit, flush_id;
	input [31:0] inst_in; /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Utilise ton tous les bits ?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

	//Outputs declaration
	output flush_ex;
	output reg exception, jump;
	output reg [5:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;

	//Variables declaration
	parameter R = 6'b000000;
	parameter ADDI = 6'b001000;
	parameter ADDIU = 6'b001001;
	parameter ANDI = 6'b001100;
	parameter BEQ = 6'b000100;
	parameter BNE = 6'b000101;
	parameter J = 6'b000010;

	//parameter SLL = 4'b1010;

	//------Code starts Here------//
	assign flush_ex = flush_id;

	always_comb
		begin
			if ( mux_ctrl_unit || flush_id )
				begin
					ex = 6'b000000;
					m = 3'b000;
					wb = 2'b00;
					jump = 0;
					exception = 0;
				end
			else begin
			casex (inst_in[31:26])
				R:
				begin
					ex = 6'b100100;
					m = 3'b000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				ADDI:
				begin
					ex = 6'b000001;
					m = 3'b000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				ADDIU:
				begin
					ex = 6'b000001;
					m = 3'b000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				ANDI:
				begin
					ex = 6'b000111;
					m = 3'b000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				BEQ:
				begin
					ex = 6'bX00010;
					m = 3'b100;
					wb = 2'b0X;
					jump = 1;
					exception = 0;
				end
				BNE:
				begin
					ex = 6'bX00100;
					m = 3'b100;
					wb = 2'b0X;
					jump = 1;
					exception = 0;
				end
				J:
				begin
					ex = 6'b000000;
					m = 3'b000;
					wb = 2'b00;
					jump = 1;
					exception = 0;
				end
				6'b100011:
				begin
					ex = 6'b000001;
					m = 3'b010;
					wb = 2'b11;
					jump = 0;
					exception = 0;
				end
				6'b101011:
				begin
					ex = 6'bX00001;
					m = 3'b001;
					wb = 2'b0X;
					jump = 0;
					exception = 0;
				end
				default:
				begin
					ex = 6'b000000;
					m = 4'b000;
					wb = 2'b00;
					jump = 0;
					exception = 1;
				end
			endcase
		end
	end

endmodule // End of module decode_CONTROL_UNIT


module ID ( clk, rst, pc, inst_in, write_register, write_data_reg, reg_write, exception, jump, rs, rt, rd, imm, data_1, data_2, flush_id, wb, m, ex, br, pc_branch, hold_pc, hold_if, flush_ex/*, ...*/ );

	//Inputs declaration
	input clk, rst;
	input [31:0] inst_in, write_data_reg, pc;
	input reg_write, flush_id;
	input [4:0] write_register;

	//Outputs declaration
	output reg hold_pc, hold_if;
	output exception, jump, flush_ex;
	output reg [4:0] rs, rt, rd;
	output reg [31:0] imm, data_1, data_2;
	output reg br;
	output [31:0] pc_branch;

	output reg [5:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;

	//Variables declaration
	reg mux_ctrl_unit;
	wire [4:0] old_rs, old_rt, old_rd;
	wire [31:0] old_imm;

	reg [5:0] old_ex;
	reg [2:0] old_m;
	reg [1:0] old_wb;
	reg [31:0] old_data_1, old_data_2;


	//------Modules Instantiation------//
	decode_REG_MAPP reg_MAPP ( clk, rst, old_rs, old_rt, write_register, write_data_reg, reg_write, old_data_1, old_data_2 );

	decode_CONTROL_UNIT control_UNIT ( inst_in, mux_ctrl_unit, flush_id, exception, jump, flush_ex, old_wb, old_m, old_ex );

	decode_HAZARD_UNIT hazard_unit ( old_rt, old_rs, rt, m[1], mux_ctrl_unit, hold_pc, hold_if);


	//------Code starts Here------//
		assign old_rs = inst_in[25:21];
		assign old_rt = inst_in[20:16];
		assign old_rd = inst_in[15:11];
		assign old_imm = {16'h0000, inst_in[15:0]};

	assign pc_branch = {pc[31:16], pc[15:0] + (inst_in[15:0] << 2)};

	always_comb
		begin
			case (old_ex[4:0])
				5'b00010: br = (old_data_1 == old_data_2) & jump;
				5'b00100: br = (old_data_1 != old_data_2) & jump;
				default: br = 0;
			endcase
		end

	always_ff @( posedge clk )
		begin
			ex <= old_ex;
			m <= old_m;
			wb <= old_wb;
			imm <= old_imm;
			rs <= old_rs;
			rt <= old_rt;
			rd <= old_rd;
			data_1 <= old_data_1;
			data_2 <= old_data_2;
		end

endmodule // End of ID module
