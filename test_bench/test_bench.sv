//-----------------------------------------------------
	// This is the test bench of the fetch and decode stage design
	// Design Name : test_bench
	// File Name   : test_bench.sv
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


module test_bench;

		reg clk, rst;

	//------For fetch stage------//

		// for pc registers
		reg hold_pc, hold_if;
		reg [31:0] pc_out;
		reg [31:0] inst_out;

		// for pc mux
		reg except;

	//------For decode stage------//

		wire br;
		reg [31:0] pc_ex;
		// for register mapping
		wire [31:0] write_data_reg;
		wire reg_write;
		reg [4:0] write_register;
		wire [4:0] rs, rt, rd;
		wire [31:0] imm, pc_branch;
		reg [31:0] data_1, data_2;
		// ROM
  	reg [31:0] rom [0:50];

	//------For control unit------//

		logic jump;
		logic exception;
		reg [5:0] ex;
		reg [2:0] m;
		reg [1:0] wb;
		reg flush_ex;

	//------For execute stage------//

		reg [2:0] m_MEM;
		reg [1:0] wb_MEM;
		reg [31:0] res;
		reg [31:0] write_data_ex;
		reg [4:0] write_register_ex;
		wire zero, over;

	//------For memory stage------//

		reg [4:0] write_register_mem;
		reg [1:0] wb_WB;
		reg [31:0] address_WB, read_data;
		// RAM
  	reg [31:0] ram [0:31];
 		reg [31:0] ram_data;
  	reg [31:0] ram_adr;

	//------For WriteBack stage------//



	// Clock definition
	parameter CLK_PERIOD = 10;
	always #(CLK_PERIOD/2.0) clk = ~clk;


	// Instantiation of design under test
  IF instruction_fetch ( clk, rst, rom, hold_pc, hold_if, pc_branch, br, except, pc_out, inst_out );

	ID instruction_decode ( .clk(clk), .rst(rst), .pc(pc_out), .inst_in (inst_out), .write_register(write_register),
							.write_data_reg(write_data_reg), .reg_write(reg_write), .exception(exception),
							.jump(jump), .rs(rs), .rt(rt), .rd(rd), .imm(imm), .data_1(data_1), .data_2(data_2),
							.flush_id(over), .wb(wb), .m(m), .ex(ex), .pc_branch(pc_branch), .br(br), .hold_pc(hold_pc),
							.hold_if(hold_if), .flush_ex(flush_ex), .pc_ex(pc_ex)
						  );

	EX execute ( clk, pc_ex, data_1, data_2, rs, rt, rd, ex, m, wb, wb_WB[1], write_register_mem, flush_ex, write_data_reg, imm, zero, over, res, write_register_ex, write_data_ex, m_MEM, wb_MEM );

	MEM memory ( clk, ram, wb_MEM, m_MEM[1:0], res, write_data_ex, write_register_ex, wb_WB, read_data, address_WB, write_register_mem, ram_data, ram_adr );

	WB writeback ( wb_WB, read_data, address_WB, write_register_mem, write_data_reg, write_register, reg_write );


  always @( posedge clk )
		begin
	    if(m[0])
	    	ram[ram_adr] <= ram_data;
	  end

	// Test bench starts Here
	initial
		begin

    	init("ROM.list", "ram.txt");
			#300

			$display( "End of simulation time is %d", $time );
			$stop;
		end

		task init;
    	input string ROM;
    	input string RAM;
    	$readmemh( ROM, rom );
    	$readmemh( RAM, ram );
    	except = 0;
			rst = 1;
			#5
			rst = 0;
			clk = 1;
		endtask

endmodule // End of Module test_bench
