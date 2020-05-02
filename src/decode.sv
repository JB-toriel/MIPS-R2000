//-----------------------------------------------------
	// This is design of the decode stage of the pipeline
	// Design Name : ID
	// File Name   : decode.sv
	// Function    :
	// Authors     : de Sainte Marie Nils - Edde Jean-Baptiste
//-----------------------------------------------------

/*
module NAME (PORTS LIST);

	PORTS DECLARATION
	VARIABLES DECLARATION

	MODULES INSTANTIATION
	ASSIGNMENT
	initial AND always BLOCS
	TASKS AND FUNCTIONS

endmodule
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

	always_ff @( negedge clk, posedge rst ) //Write process
		begin
			if ( rst )
				begin
					for ( i = 0; i < 32; i++ )
						reg_file[i] <= 0;
				end
			else if ( reg_write )
				reg_file[write_register] <= write_data_reg;
		end

endmodule // End of module decode_REG_MAPP module


module decode_CONTROL_UNIT ( inst_in, mux_ctrl_unit, flush_id, exception, jump, flush_ex, wb, m, ex );

	//Inputs declaration
	input mux_ctrl_unit, flush_id;
	input [31:26] inst_in;

	//Outputs declaration
	output flush_ex;
	output reg exception, jump;
	output reg [5:0] ex;
	output reg [3:0] m;
	output reg [1:0] wb;

	//Variables declaration
	parameter R = 6'b000000;
	parameter J = 6'b000010;
	parameter JAL = 6'b000011;
	parameter BEQ = 6'b000100;
	parameter BNE = 6'b000101;
	parameter ADDI = 6'b001000;
	parameter ADDIU = 6'b001001;
	parameter SLTI = 6'b001010;
	parameter SLTIU = 6'b001011;
	parameter ANDI = 6'b001100;
	parameter ORI = 6'b001101;
	parameter XORI = 6'b001110;
	parameter LUI = 6'b001111;
	parameter LB = 6'b100000;
	parameter LW = 6'b100011;
	parameter LHU = 6'b100101;
	parameter SB = 6'b101000;
	parameter SH = 6'b101001;
	parameter SW = 6'b101011;
	parameter LBU = 6'b100100;

	//------Code starts Here------//
	assign flush_ex = flush_id;

	always_comb
		begin
			if ( mux_ctrl_unit || flush_id )
				begin
					ex = 6'b000000;
					m = 4'b0000;
					wb = 2'b00;
					jump = 0;
					exception = 0;
				end
			else begin
			case (inst_in[31:26])
				R:
				begin
					ex = 6'b100100;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				ADDI:
				begin
					ex = 6'b000001;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				ADDIU:
				begin
					ex = 6'b000001;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				ANDI:
				begin
					ex = 6'b000111;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				BEQ:
				begin
					ex = 6'b000010;//
					m = 4'b0000;
					wb = 2'b00;
					jump = 1;
					exception = 0;
				end
				BNE:
				begin
					ex = 6'b000100;//
					m = 4'b0000;
					wb = 2'b00;
					jump = 1;
					exception = 0;
				end
				J:
				begin
					ex = 6'b000110;
					m = 4'b0000;
					wb = 2'b00;
					jump = 1;
					exception = 0;
				end
				JAL:
				begin
					ex = 6'b001110;
					m = 4'b0000;
					wb = 2'b10;
					jump = 1;
					exception = 0;
				end
				ORI:
				begin
					ex = 6'b001001;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				LUI:
				begin
					ex = 6'b001101;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				SLTI:
				begin
					ex = 6'b001011;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				SLTIU:
				begin
					ex = 6'b001011;
					m = 4'b0000;
					wb = 2'b10;
					jump = 0;
					exception = 0;
				end
				LB:
				begin
					ex = 6'b000001;
					m = 4'b0110;
					wb = 2'b11;
					jump = 0;
					exception = 0;
				end
				LW:
				begin
					ex = 6'b000001;
					m = 4'b0010;
					wb = 2'b11;
					jump = 0;
					exception = 0;
				end
				LHU:
				begin
					ex = 6'b000001;
					m = 4'b1010;
					wb = 2'b11;
					jump = 0;
					exception = 0;
				end
				LBU:
				begin
					ex = 6'b000001;
					m = 4'b1110;
					wb = 2'b11;
					jump = 0;
					exception = 0;
				end
				SB:
				begin
					ex = 6'b000001;//
					m = 4'b0101;
					wb = 2'b00;
					jump = 0;
					exception = 0;
				end
				SH:
				begin
					ex = 6'b000001;//
					m = 4'b1001;
					wb = 2'b00;
					jump = 0;
					exception = 0;
				end
				SW:
				begin
					ex = 6'b000001;//
					m = 4'b0001;
					wb = 2'b00;
					jump = 0;
					exception = 0;
				end
				default:
				begin
					ex = 6'b000000;
					m = 4'b0000;
					wb = 2'b00;
					jump = 0;
					exception = 0;
				end
			endcase
		end
	end

endmodule // End of module decode_CONTROL_UNIT


module ID ( clk, rst, pc, inst_in, write_register, write_data_reg, reg_write, exception, jump, rs, rt, rd, imm, data_1, data_2, flush_id, wb, m, ex, br, pc_branch, hold_pc, hold_if, flush_ex, pc_ex );

	//Inputs declaration
	input clk, rst;
	input [31:0] inst_in, write_data_reg, pc;
	input reg_write, flush_id;
	input [4:0] write_register;

	//Outputs declaration
	output reg [31:0] pc_ex;
	output reg hold_pc, hold_if;
	output exception, jump, flush_ex;
	output reg [4:0] rs, rt, rd;
	output reg [31:0] imm, data_1, data_2;
	output reg br;
	output reg [31:0] pc_branch;

	output reg [5:0] ex;
	output reg [3:0] m;
	output reg [1:0] wb;

	//Variables declaration
	reg mux_ctrl_unit;
	wire [4:0] old_rs, old_rt, old_rd;
	wire [31:0] old_imm;

	reg [5:0] old_ex;
	reg [3:0] old_m;
	reg [1:0] old_wb;
	reg [31:0] old_data_1, old_data_2;


	//------Modules Instantiation------//
	decode_REG_MAPP reg_MAPP ( clk, rst, old_rs, old_rt, write_register, write_data_reg, reg_write, old_data_1, old_data_2 );

	decode_CONTROL_UNIT control_UNIT ( inst_in[31:26], mux_ctrl_unit, flush_id, exception, jump, flush_ex, old_wb, old_m, old_ex );

	decode_HAZARD_UNIT hazard_unit ( old_rt, old_rs, rt, m[1], mux_ctrl_unit, hold_pc, hold_if);

	parameter ADDIU = 6'b001001;
	parameter SLTIU = 6'b001011;
	parameter LUI = 6'b001111;
	parameter LHU = 6'b100101;
	parameter LBU = 6'b100100;

	//------Code starts Here------//
	assign old_rs = inst_in[25:21];
	assign old_rt = inst_in[20:16];
	assign old_rd = ( old_ex == 6'b001110 ) ? 31 : inst_in[15:11];
	assign old_imm = ( inst_in[31:26] == ADDIU || inst_in[31:26] == SLTIU || inst_in[31:26] == LUI || inst_in[31:26] == LHU || inst_in[31:26] == LBU ) ? {16'h0000, inst_in[15:0]} : $signed(({inst_in[15:0], 16'h0000} >>> 16));


	always_comb
		begin
			pc_branch = {pc[31:16], pc[15:0] + (inst_in[15:0] << 2)};
			case ( old_ex[4:0] )
				5'b00010: br = (old_data_1 == old_data_2) & jump;
				5'b00100: br = (old_data_1 != old_data_2) & jump;
				5'b00110, 5'b01110: br = jump;
				default: br = 0;
			endcase
			if (old_ex == 6'b000110 || old_ex == 6'b001110 ) begin
				pc_branch = (pc & 32'hf0000000) | (inst_in[25:0] << 2);
			end
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
			pc_ex <= pc;
		end

endmodule // End of ID module
