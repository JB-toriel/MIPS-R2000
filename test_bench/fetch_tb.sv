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

module fetch_tb; 
  
     reg clk; 
     reg br, except;

// for pc register
  reg [31:0] pc_out;

  // for pc mux
  reg [31:0] sign, fixed;

  parameter CLK_PERIOD = 10;

  always #(CLK_PERIOD/2.0) clk = ~clk;

 // Instantiate design under test
  IF Instruction_fetch ( clk, sign, fixed, br, except, pc_out );

  /*task display;
    #1 $display( "pc = %0h - pc_4 = %0h", pc, pc_4);
  endtask
  */

  initial
        begin
          		$dumpfile("dump.vcd"); 
          		$dumpvars;
          	
                sign = 0; fixed = 0;
                br = 0; except = 0;
                clk = 1;
                #100
            $display( "End of simulation time is %d", $time );
                $finish(1);
        end


endmodule
