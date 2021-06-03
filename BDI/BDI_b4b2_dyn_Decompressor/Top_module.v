`timescale 1ns / 1ps

module top_module (
     input clk_input
     );
     
     
   wire clk, clk_100MHz;
   wire [255:0] DecompCache;
   wire [5:0] Addra; 
   wire [5:0]Addrb;
   wire [259:0] compdata;
   reg ena, wea, enb;
   
   DecompressorUnit decompressor_unit(clk, Addrb,Addra, DecompCache, compdata);
     
     clk_wiz_0 clk_wizard
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
    .clk_out2(clk_100MHz),     // output clk_out2
   // Clock in ports
    .clk_in1(clk_input));
    
    
     
     blk_mem_gen_0 B_Ram (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(Addra),  // input wire [3 : 0] addra
  .dina(DecompCache),    // input wire [259 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(enb),      // input wire enb
  .addrb(Addrb),  // input wire [3 : 0] addrb
  .doutb(compdata)  // output wire [259 : 0] doutb
);
     
    vio_0 VIO (
  .clk(clk),                // input wire clk
  .probe_out0(Addrb)  // output wire [3 : 0] probe_out0
);
     
  
  ila_0 ILA (
	.clk(clk_100MHz), // input wire clk


	.probe0(compdata), // input wire [259:0]  probe0  
	.probe1(DecompCache) // input wire [259:0]  probe1
);   


always @ (*)
begin
    wea=1;
    ena=1;
    enb=1;
end

endmodule