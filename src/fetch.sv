//-----------------------------------------------------
	// This is design of the fetch stage of the pipeline
	// Design Name : IF
	// File Name   : fetch.sv
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


module fetch_PC_REG ( clk, old_pc, new_pc );

	// Inputs Declaration
	input clk;
	input [31:0] new_pc;

	// Ouputs Declaration
	output reg [31:0] old_pc;

	// Code starts Here
	always @(posedge clk)
		old_pc <= new_pc;

endmodule	// End of Module fetch_PC_REG


module fetch_MUX( inc_pc, sign, fixed, br, except, new_pc );

	// Inputs Declaration
	input [31:0] inc_pc;	//old_pc "+ 4"
	input [31:0] sign, fixed;
	input br, except;

	// Outputs Declaration
	output reg [31:0] new_pc;


	// Code starts Here
	always @( br or except or inc_pc )
      begin
		if ( br == 0 && except == 0 )
			assign new_pc = inc_pc + 4;

		if ( br == 0 && except == 1 )
			assign new_pc = except;

		if ( br == 1 && except == 0 )
			assign new_pc = sign;

		if ( br == 1 && except == 1 )
			assign new_pc = 32'hFFFF_FFFF;
	  end

  	initial new_pc=0;

endmodule // End of Module fetch_MUX


module fetch_ROM ( clk, pc/*, chip_en, read_en*/, inst );

	// Inputs Declaration
	input clk;
	input [31:0] pc;
	/*
	input logic chip_en;
	input logic read_en;
	*/

	// Ouputs Declaration
	output reg [31:0] inst;

	//------Variable declaration------//
	reg [31:0] rom_code [0:8];


	// Code starts Here
	always_ff @( posedge clk )
		inst <= rom_code[pc/4];

	/*
	if (chip_en && read_en)
		assign inst = rom_code[pc];
  	else
		assign inst = 32'hFFFF_FFFF;
	*/

	initial
		begin
			$readmemh("src/memory.list", rom_code);
		end


endmodule	// End of Module fetch_ROM


module IF( clk, sign, fixed, br, except, pc_out, inst_out);

	// Inputs Declaration
	input clk;
	input [31:0] sign, fixed;
	input br, except;

	// Outputs Declaration
	output reg [31:0] pc_out;
	output reg [31:0] inst_out;

	// Ports data types
	wire [31:0] pc;
	reg [31:0] pc_4;
	reg [31:0] old_inst_out;

	// Modules Instantiation

	fetch_PC_REG pc_REG(

		.clk    (	clk   ), // input
		.old_pc (	pc    ), // input	[31:0]
		.new_pc (	pc_4  )  // output	[31:0]

	);

	fetch_MUX mux(

		.inc_pc (	pc		), // input	[31:0]
		.sign   (	sign  	), // input	[31:0]
		.fixed  (	fixed   ), // input	[31:0]
		.br  	(	br   	), // input
		.except (	except  ), // input
		.new_pc (	pc_4    )  // output	[31:0]

	);

	fetch_ROM rom(

		.clk 	(	clk			 ),
		.pc		(	pc_4		 ), // input	[31:0]
		/*.chip_en(	chip_en	), // input
		.read_en(	read_en	), // input*/
		.inst 	(	old_inst_out )  // output	[31:0]

	);

	always_ff @( posedge clk )begin
		pc_out <= pc_4;
		inst_out <= old_inst_out;
	end


endmodule // End of Module IF
