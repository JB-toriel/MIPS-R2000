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
	input [2:0] mem_Read;
  
	//Outputs declaration
	output reg  mux_ctrl_unit;
	output reg hold_pc, hold_if;
  
  
	//------Code starts Here------//
  	initial 
    	begin 
        	hold_pc=0;
    		hold_if=0; 
        end
  
	always @*
		begin
			if ( mem_Read && (rt_ex==rs_id || rt_ex==rt_id) )
				begin
					hold_pc<=1;
					hold_if<=1;
					mux_ctrl_unit<=1;
				end
				
			else
				begin
					hold_pc<=0;
					hold_if<=0;
					mux_ctrl_unit<=0;
				end
		end
  
endmodule // End of module decode_HAZARD_UNIT


module decode_REG_MAPP ( rs, rt, write_register, write_data_reg, reg_write, data_1, data_2 );

	//Inputs declaration
	input [4:0] rs, rt;
	input reg_write;
	input [4:0] write_register;
	input [31:0] write_data_reg;

	//Outputs declaration
	output [31:0] data_1, data_2;

	//Variables DECLARATION
	reg [31:0] registers [0:31];
	integer i;


	//------Code starts Here------//
  	assign registers[0]=0;
  
	initial
		begin
			for(i = 0; i < 32; i = i + 1)
				registers[i]=i;
		end

	assign data_1 = registers[rs];
	assign data_2 = registers[rt];
	
	always @ ( * ) 
		if (reg_write) registers[write_register] <= write_data_reg;

endmodule // End of module decode_REG_MAPP module


module decode_CONTROL_UNIT ( inst_in, mux_ctrl_unit, exception, jump, wb, m, ex );

	//Inputs declaration
	input mux_ctrl_unit;
	input [31:0] inst_in;

	//Outputs declaration
	output reg exception, jump;
	output reg [3:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;


	//------Code starts Here------//
	always @ ( inst_in, mux_ctrl_unit ) begin
		case (mux_ctrl_unit)
			1:
			begin
				ex <= 4'b1100;
				m <= 3'b000;
				wb <= 2'b10;
				jump <= 0;
			end
			0: 
				begin
					case (inst_in[31:26])
						0:
						begin
							ex <= 4'b1100;
							m <= 3'b000;
							wb <= 2'b10;
							jump <= 0;
						end
					6'b100011:
						begin
							ex <= 4'b0001;
							m <= 3'b010;
							wb <= 2'b11;
							jump <= 0;
						end
					6'b101011:
						begin
							ex <= 4'bX001;
							m <= 3'b001;
							wb <= 2'b0X;
							jump <= 0;
						end
					6'b000100:
						begin
							ex <= 4'bX010;
							m <= 3'b100;
							wb <= 2'b0X;
							jump <= 1;
						end
					default:
						begin
							ex <= 4'b0000;
							m <= 4'b000;
							wb <= 2'b00;
							jump <= 0;
						end
					endcase
				end
		endcase
	end
	
endmodule // End of module decode_CONTROL_UNIT


module ID ( clk, pc, inst_in, write_register, write_data_reg, reg_write, exception, jump, rs, rt, rd, imm, data_1, data_2, wb, m, ex, br, pc_branch, hold_pc, hold_if/*, ...*/ );

	//Inputs declaration
	input clk;
	input [31:0] inst_in, write_data_reg, pc;
	input reg_write;
	input [4:0] write_register;

	//Outputs declaration
	output reg hold_pc, hold_if;
	output exception, jump;
	output reg [4:0] rs, rt, rd;
	output reg [31:0] imm, data_1, data_2;
	output br;
	output [31:0] pc_branch;

	output reg [3:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;

	//Variables declaration
	reg mux_ctrl_unit;
	reg [4:0] old_rs, old_rt, old_rd;
	reg [31:0] old_imm;

	reg [3:0] old_ex;
	reg [2:0] old_m;
	reg [1:0] old_wb;
	reg [31:0] old_data_1, old_data_2;

	
	//------Modules Instantiation------//
	decode_REG_MAPP reg_MAPP ( old_rs, old_rt, write_register, write_data_reg, reg_write, old_data_1, old_data_2 );
	
	decode_CONTROL_UNIT control_UNIT ( inst_in, mux_ctrl_unit, exception, jump, old_wb, old_m, old_ex );
	
	decode_HAZARD_UNIT hazard_unit ( old_rt, old_rs, rt, m, mux_ctrl_unit, hold_pc, hold_if);

	
	//------Code starts Here------//
	always @ ( inst_in ) begin
		old_rs <= inst_in[25:21];
		old_rt <= inst_in[20:16];
		old_rd <= inst_in[15:11];
		old_imm <= {16'h0000, inst_in[15:0]};
	end

	assign br = (old_data_1 == old_data_2) & jump;
	assign pc_branch = pc + (old_imm << 2);

	always_ff @ ( posedge clk ) begin
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
