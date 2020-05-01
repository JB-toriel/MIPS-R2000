//-----------------------------------------------------
	// This is the test bench of whole MIPS processor
	// Design Name : test_bench
	// File Name   : test_bench.sv
	// Function    :
	// Authors     : de Sainte Marie Nils - Edde Jean-Baptiste
//-----------------------------------------------------

/*
module NAME (PORTS LIST);

PORTS DECLARATION
VARIABLES DECLARATION

MODULES INSTANTIATION
AFFECTATIONS
initial AND always BLOCS
TASKS AND FUNCTIONS

endmodule
*/


module test_bench;

		reg clk, rst;

	//------For fetch stage------//

		//ROM
		reg [31:0] rom [0:31];
		reg [31:0] pc_rom, inst_rom;

	//------For memory stage------//

		// RAM
		reg [31:0] ram [0:31];
		reg ram_read, ram_write;
 		reg [31:0] ram_data, ram_word;
  	wire [31:0] ram_adr;


	// Clock definition
	parameter CLK_PERIOD = 10;
	always #(CLK_PERIOD/2.0) clk = ~clk;


	MIPS mips ( clk, rst, pc_rom, inst_rom, ram_read, ram_write, ram_data, ram_word, ram_adr );


	//RAM
  always @( ram_write, ram_adr, ram_data, ram_read  )
		begin
	    if(ram_write)
	    	ram[ram_adr] <= ram_data;
			if(ram_read)
				ram_word <= ram[ram_adr];

	  end

		//ROM
		always @( pc_rom ) begin
			inst_rom <= rom[pc_rom/4];
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
			rst = 1;
			#5
			rst = 0;
			clk = 1;
		endtask

endmodule // End of Module test_bench
