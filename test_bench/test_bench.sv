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
		wire [1:0] ram_size;
		reg [7:0] ram [0:31][4]; //longueur, lignes, colonnes
		reg ram_read, ram_write;
 		reg [31:0] ram_data, ram_word;
  	wire [31:0] ram_adr;


	// Clock definition
	parameter CLK_PERIOD = 10;
	always #(CLK_PERIOD/2.0) clk = ~clk;


	MIPS mips ( clk, rst, pc_rom, inst_rom, ram_size, ram_read, ram_write, ram_data, ram_word, ram_adr );

	//RAM
  always @( ram_write, ram_adr, ram_data, ram_read, ram_size  )
		begin
	    if(ram_write)
				begin
					case (ram_size)
						0: begin
								ram[ram_adr/4][3] <= ram_data[7:0];
								ram[ram_adr/4][2] <= ram_data[15:8];
								ram[ram_adr/4][1] <= ram_data[23:16];
								ram[ram_adr/4][0] <= ram_data[31:24]; // 12345678 00 00 00 00
							end
						1:	ram[ram_adr/4][ram_adr % 4] <= ram_data[7:0];
						2:	begin
								ram[ram_adr/4][ram_adr %2] <= ram_data[7:0]; //00 00 00 00 00 00
								ram[ram_adr/4][(ram_adr %2) - 1] <= ram_data[15:8];
						end
						default:	ram[ram_adr/4][ram_adr % 4] <= ram_data[7:0];
					endcase
				end
			if(ram_read)
				begin
					$display("%h %h %h", (ram[ram_adr/4][ram_adr%4]), {ram[ram_adr/4][ram_adr%4], 24'h00_0000}, ({ram[ram_adr/4][ram_adr%4], 24'h00_0000} >>> 24));
					case (ram_size)
						0:	ram_word <= {ram[ram_adr/4][0], ram[ram_adr/4][1], ram[ram_adr/4][2], ram[ram_adr/4][3]}; // 12345678 00 00 00 00
						1:	ram_word <= $signed({ram[ram_adr/4][ram_adr%4], 24'h00_0000}) >>> 24; //LB
						2:	ram_word <= {16'h0000, ram[ram_adr/4][(ram_adr %2)-1], ram[ram_adr/4][ram_adr %2]}; //LHU
						3:  ram_word <= {24'h00A0_00, ram[ram_adr/4][ram_adr%4]};	//LBU
						default:	ram_word <= {ram[ram_adr/4][0], ram[ram_adr/4][1], ram[ram_adr/4][2], ram[ram_adr/4][3]};
					endcase
				end
	  end

		//ROM
		always @( pc_rom ) begin
			inst_rom <= rom[pc_rom/4];
		end

	// Test bench starts Here
	initial
		begin

    	init("Fibov0.txt", "ram.txt");
			for(int i=0; i<32; i++) begin
				for(int j=0; j<4; j++)begin
						if (j == 3) begin
							ram[i][j] <= i;
						end
						else ram[i][j] <= 0;
				end
			end
			ram[2][2] <= 8'haa;
			#1000
			$stop;
			$display( "End of simulation time is %d", $time );
		end

		task init;
    	input string ROM;
    	input string RAM;
    	$readmemh( ROM, rom );
    	//$readmemh( RAM, ram );
			rst = 1;
			#5
			rst = 0;
			clk = 1;
		endtask

endmodule // End of Module test_bench
