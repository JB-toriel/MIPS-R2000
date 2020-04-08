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

module decode_REG_MAPP ( rs, rt, write_register, write_data_reg, reg_write, data_1, data_2);

	// Inputs declaration
	input [4:0] rs, rt;
	input reg_write;
	input [4:0] write_register;
	input [31:0] write_data_reg;

	// Outputs declaration
	output [31:0] data_1, data_2;

	//Variables DECLARATION
	reg [31:0] registers [0:31];
	integer i;

	initial
    begin
      for(i = 0; i < 32; i = i + 1)
        begin
          registers[i]=i;
        end
  	end

	//Code start here
		assign data_1 = registers[rs];
		assign data_2 = registers[rt];
		always @ ( * ) begin
			if (reg_write) registers[write_register] <= write_data_reg;
		end

	endmodule // End of decode_REG_MAPP module


module decode_CONTROL_UNIT (inst_in, exception, jump, wb, m, ex);

	// Inputs declaration
	input [31:0] inst_in;

	// Outputs declaration
	output exception, jump;
	output reg [3:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;

	always @ ( inst_in ) begin
		case (inst_in[31:26])
			0:
			begin
				ex <= 4'b1100;
				m <= 3'b000;
				wb <= 2'b10;
			end
			6'b100011:
			begin
				ex <= 4'b0001;
				m <= 3'b010;
				wb <= 2'b11;
			end
			6'b101011:
			begin
				ex <= 4'bX001;
				m <= 3'b001;
				wb <= 2'b0X;
			end
			6'b000100:
			begin
				ex <= 4'bX010;
				m <= 3'b100;
				wb <= 2'b0X;
			end
			default:
		  begin
				ex <= 4'b0000;
				m <= 4'b000;
				wb <= 2'b00;
			end
		endcase
	end
endmodule // decode_CONTROL_UNIT


module ID ( clk, inst_in, write_register, write_data_reg, reg_write, exception, jump, rs, rt, rd, imm, data_1, data_2, equal, wb, m, ex/*, ...*/);

	//Inputs declaration
	input clk;
	input [31:0] inst_in, write_data_reg;
	input reg_write;
	input [4:0] write_register;

	//Outputs declaration
	output exception, jump;
	output reg [4:0] rs, rt, rd;
	output reg [31:0] imm, data_1, data_2;
	output equal;

	output reg [3:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;

	//Variable declaration
	reg [4:0] old_rs, old_rt, old_rd;
	reg [31:0] old_imm;

	reg [3:0] old_ex;
	reg [2:0] old_m;
	reg [1:0] old_wb;

	//Actual code
	always @ ( inst_in ) begin
		old_rs <= inst_in[25:21];
		old_rt <= inst_in[20:16];
		old_rd <= inst_in[15:11];
		old_imm <= {16'h0000, inst_in[15:0]};
	end


	decode_REG_MAPP reg_MAPP ( rs, rt, write_register, write_data_reg, reg_write, data_1, data_2 );
	decode_CONTROL_UNIT control_UNIT ( inst_in, exception, jump, old_wb, old_m, old_ex );

	assign equal = (data_1 == data_2);
	always_ff @ ( posedge clk ) begin
		ex <= old_ex;
		m <= old_m;
		wb <= old_wb;
		imm <= old_imm;
		rs <= old_rs;
		rt <= old_rt;
		rd <= old_rd;
	end

endmodule // End of ID module
