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


module fetch_PC_REG ( clk, rst, hold_pc, old_pc, new_pc );

	//Inputs Declaration
	input clk, rst, hold_pc;
	input [31:0] new_pc;

	//Ouputs Declaration
	output reg [31:0] old_pc;

	//------Code starts Here------//
	always_ff @( posedge clk, posedge rst )
		begin
			if (rst)
				old_pc<=0;
			else if ( hold_pc==0 )
				old_pc <= new_pc;
		end

endmodule // End of Module fetch_PC_REG


module fetch_MUX ( inc_pc, pc_branch, br, except, new_pc );

	//Inputs Declaration
	input [31:0] inc_pc;	//old_pc "+ 4"
	input [31:0] pc_branch;
	input br, except;

	//Outputs Declaration
	output reg [31:0] new_pc;


	//------Code starts Here------//
	always @( br, except, inc_pc, pc_branch )
		begin
				case ( {br,except} )
					0: new_pc = inc_pc + 4;
					1: new_pc = 32'h8000_0180;
					2: new_pc = pc_branch - 4;
					default: new_pc = inc_pc + 4;
				endcase
		end

endmodule // End of Module fetch_MUX


module fetch_ROM ( clk, pc/*, chip_en, read_en*/, inst );

	//Inputs Declaration
	input clk;
	input [31:0] pc;
	/*
	input chip_en;
	input read_en;
	*/

	//Ouputs Declaration
	output [31:0] inst;

	//Variables declaration
	reg [31:0] rom_code [0:50];


	//------Code starts Here------//
	assign inst = rom_code[pc/4];
	/*
	if (chip_en && read_en)
		assign inst = rom_code[pc];
  	else
		assign inst = 32'hFFFF_FFFF;
	*/
	
	initial
		begin
			$readmemh( "memory.list", rom_code );
		end

endmodule // End of Module fetch_ROM


module IF ( clk, rst, hold_pc, hold_if, pc_branch, br, except, pc_out, inst_out );

	//Inputs Declaration
	input clk, rst, hold_pc, hold_if;
	input [31:0] pc_branch;
	input br, except;

	//Outputs Declaration
	output reg [31:0] pc_out;
	output reg [31:0] inst_out;

	//Variables declaration
	wire [31:0] pc;
	reg [31:0] pc_4;
	reg [31:0] old_inst_out;


	//------Modules Instantiation------//
	fetch_PC_REG pc_REG(

      	.clk    	(	clk   	  ), // input
      	.rst    	(	rst   	  ), // input
      	.hold_pc    (	hold_pc   ), // input
      	.old_pc 	(	pc    	  ), // input	[31:0]
      	.new_pc 	(	pc_4  	  )  // output	[31:0]

	);

	fetch_MUX mux(

		.inc_pc 	(	pc			), // input	[31:0]
		.pc_branch	(	pc_branch	), // input	[31:0]
		.br  		(	br   		), // input
		.except 	(	except  	), // input
		.new_pc 	(	pc_4    	)  // output	[31:0]

	);

	fetch_ROM rom(

		.clk	(	clk			 ),
		.pc		(	pc			 ), // input	[31:0]
		/*.chip_en(	chip_en	), // input
		.read_en(	read_en		), // input*/
		.inst	(	old_inst_out )  // output	[31:0]

	);


	//------Code starts Here------//
	 always_ff @( posedge clk, posedge br )
		begin
        if ( br )
            inst_out<=0;
		else if ( hold_if==0 )
				begin
					pc_out <= pc_4;
					inst_out <= old_inst_out;
				end
		end

endmodule // End of Module IF
