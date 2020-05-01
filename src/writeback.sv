//-----------------------------------------------------
	// This is design of the writeback stage of the pipeline
	// Design Name : WB
	// File Name   : writeback.sv
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


module WB ( wb, read_data, address_WB, write_register_mem, write_data_reg, write_register, reg_write );

	//Inputs declaration
	input [31:0] read_data, address_WB;
	input [1:0] wb;
	input [4:0] write_register_mem;

	//Outputs declaration
	output  [31:0] write_data_reg;
	output  [4:0] write_register;
	output reg_write;


	//------Code starts Here------//
	assign reg_write = wb[1];
	assign write_data_reg = wb[0] ? read_data : address_WB;
	assign write_register = write_register_mem;

endmodule // End of WB module
