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


module fetch_PC_REG ( clk, old_pc, new_pc );

	input clk;
	input [31:0] new_pc;
	output reg [31:0] old_pc;
	
	always @(posedge clk)
		old_pc <= new_pc;
  
endmodule


module fetch_MUX( inc_pc, sign, fixed, br, except, new_pc );

	input wire [31:0] inc_pc;	//old_pc "+ 4"
	input [31:0] sign, fixed;
	input br, except;
	output reg [31:0] new_pc;
	
	always @(br or except or inc_pc) 
      begin
		if ( br == 0 && except == 0 )
			assign new_pc = inc_pc + 4;

		if ( br == 0 && except == 1 )
			assign new_pc = except;

		if ( br == 1 && except == 0 )
			assign new_pc = sign;

		if ( br == 1 && except == 1 )
			assign new_pc = 8'hFFFF_FFFF;
	  end
  
  	initial new_pc=0;

endmodule

module IF( clk, sign, fixed, br, except, pc_out/*, inst*/);
	
	input clk;
	input [31:0] sign, fixed;
	input br, except;
	wire [31:0] pc;
	reg [31:0] pc_4;
	output reg [31:0] pc_out;
  
	//output inst;


	fetch_PC_REG pc_REG(

		.clk    ( clk     ), // input
  		.old_pc ( pc    ), // input	[31:0]
		.new_pc ( pc_4      )  // output	[31:0]

	);
	
	fetch_MUX mux( 
	
  		.inc_pc ( pc	  ), // input	[31:0]
  		.sign   ( sign	  ), // input	[31:0]
  		.fixed  ( fixed   ), // input	[31:0]
		.br  	( br   	  ), // input
		.except ( except  ), // input
		.new_pc ( pc_4    )  // output	[31:0]

	);
	
	always @(pc_4)
		assign pc_out = pc_4;

endmodule
