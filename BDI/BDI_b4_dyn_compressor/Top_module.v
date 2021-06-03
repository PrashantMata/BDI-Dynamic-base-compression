module top_module (clk_input);
input clk_input;
reg ena, wea , enb;
wire [6:0] Addra, Addrb;
wire clk, clk_100Mhz;
wire [259:0]CompCache;
wire [259:0] uncompdata;



CompressorUnit compressor (clk, uncompdata, CompCache, Addra, Addrb );

ila_0 your_instance_name (
	.clk(clk_100Mhz), // input wire clk


	.probe0(CompCache), // input wire [259:0]  probe0  
	.probe1(uncompdata) // input wire [259:0]  probe1
);

blk_mem_gen_0 Block_ram (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(Addra),  // input wire [6 : 0] addra
  .dina(CompCache),    // input wire [259 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(enb),      // input wire enb
  .addrb(Addrb),  // input wire [6 : 0] addrb
  .doutb(uncompdata)  // output wire [259 : 0] doutb
);

clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
    .clk_out2(clk_100Mhz),     // output clk_out2
   // Clock in ports
    .clk_in1(clk_input)); 
    
  vio_0 VIO (
      .clk(clk_100Mhz),                // input wire clk
      .probe_out0(Addrb)  // output wire [6 : 0] probe_out0
    );  
    
    always @(*)
    begin
        ena=1; 
        wea=1;  
        enb=1;
    end
    

endmodule