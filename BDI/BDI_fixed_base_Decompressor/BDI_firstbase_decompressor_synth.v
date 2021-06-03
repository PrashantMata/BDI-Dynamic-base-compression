`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:26:09 11/15/2018 
// Design Name: 
// Module Name:    DecompressorUnit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
/*module DecompressorUnit(clk,DecompCache);
input clk;
output reg[255:0]DecompCache;*/

module DecompressorUnit(clk, Addrb,Addra, DecompCache, compdata);
input clk;
input [3:0] Addrb;
output reg [3:0] Addra;
output reg[255:0]DecompCache; 
input [259:0] compdata;


reg[259:0]CompCacheEn;
reg[255:0]CompCache;
reg [63:0]Base8;
reg [31:0]Base4;
reg [15:0]Base2;
reg [3:0]CoN;
reg [3:0]flag8;
reg [7:0]flag4 ;
reg [15:0]flag2;




always @ (posedge clk)
begin

Addra= Addrb +6;

CompCacheEn = compdata;
CoN = CompCacheEn[3:0];
//CompCache = 256'd0;
$display("%d:CoN= %h , CompCache = %h",i,CoN,CompCache);


// Zeros
if(CoN==0)
begin
DecompCache = 256'd0;
$display("%h",DecompCache);
$fdisplay(decompfile,"%h",DecompCache);
end

//BASE 8 DEL 1 BYTE
if(CoN==2)
begin
flag8 = CompCacheEn[7:4]; //4bits : 4,5,6,7
CompCache = CompCacheEn[259:8];
Base8 = CompCache[63:0]; //Base8


if (flag8[0] ==0)
DecompCache[63:0] = Base8 - CompCache[71:64];
else 
DecompCache[63:0] = CompCache[71:64]+ Base8 ;

if (flag8[1] ==0)
DecompCache[127:64] = Base8 - CompCache[79:72];
else 
DecompCache[127:64] = CompCache[79:72]+ Base8 ;

if (flag8[2] ==0)
DecompCache[191:128] = Base8 - CompCache[87:80];
else 
DecompCache[191:128] = CompCache[87:80]+ Base8 ;

if (flag8[3] ==0)
DecompCache[255:192] = Base8 - CompCache[95:88];
else 
DecompCache[255:192] = CompCache[95:88]+ Base8 ;

$display("%h",DecompCache);
$fdisplay(decompfile,"%h",DecompCache);
end

//BASE 8 DEL 2 BYTES
else if(CoN==3)
begin

flag8 = CompCacheEn[7:4]; //4bits 
CompCache = CompCacheEn[259:8];
Base8 = CompCache[63:0]; //Base8

if(flag8[0]==1'b0)
DecompCache[63:0] = Base8 - CompCache[79:64];
else
DecompCache[63:0] = CompCache[79:64]+ Base8 ;

if(flag8[1]==1'b0)
DecompCache[127:64] = Base8 - CompCache[95:80];
else
DecompCache[127:64] = CompCache[95:80]+ Base8 ;

if(flag8[2]==1'b0)
DecompCache[191:128] = Base8 - CompCache[111:96];
else
DecompCache[191:128] = CompCache[111:96]+ Base8 ;

if(flag8[3]==1'b0)
DecompCache[255:192] = Base8 - CompCache[127:112];
else
DecompCache[255:192] = CompCache[127:112]+ Base8;

$display("%h",DecompCache);
$fdisplay(decompfile,"%h",DecompCache);
end

//BASE 8 DEL 4 BYTES
else if(CoN==4)
begin
flag8 = CompCacheEn[7:4]; //3bits : 4,5,6
CompCache = CompCacheEn[259:8];
Base8 = CompCache[63:0]; //Base8


if(flag8[0]==1'b0)
DecompCache[63:0] = Base8 - CompCache[95:64];
else
DecompCache[63:0] = CompCache[95:64]+ Base8 ;

if(flag8[1]==1'b0)
DecompCache[127:64] = Base8 - CompCache[127:96];
else
DecompCache[127:64] = CompCache[127:96]+ Base8 ;

if(flag8[2]==1'b0)
DecompCache[191:128] = Base8 - CompCache[159:128];
else
DecompCache[191:128] = CompCache[159:128]+ Base8 ;

if(flag8[3]==1'b0)
DecompCache[255:192] = Base8 - CompCache[191:160];
else
DecompCache[255:192] = CompCache[191:160]+ Base8 ;

$display("%h",DecompCache);
$fdisplay(decompfile,"%h",DecompCache);
end





//BASE 4 DEL 1 BYTE

else if(CoN==5)
begin

flag4 = CompCacheEn[11:4]; //8bits
CompCache = CompCacheEn[259:12];
Base4 = CompCache[31:0]; //Base4


if(flag4[0]==1'b0)
DecompCache[31:0] = Base4 - CompCache[39:32];
else
DecompCache[31:0] = CompCache[39:32]+ Base4 ;


if(flag4[1]==1'b0)
DecompCache[63:32] = Base4 - CompCache[47:40];
else
DecompCache[63:32] = CompCache[47:40]+ Base4 ;


if(flag4[2]==1'b0)
DecompCache[95:64] = Base4 - CompCache[55:48];
else
DecompCache[95:64] = CompCache[55:48]+ Base4 ;


if(flag4[3]==1'b0)
DecompCache[127:96] = Base4 - CompCache[63:56];
else
DecompCache[127:96] = CompCache[63:56]+ Base4 ;


if(flag4[4]==1'b0)
DecompCache[159:128] = Base4 - CompCache[71:64];
else
DecompCache[159:128] = CompCache[71:64]+ Base4 ;


if(flag4[5]==1'b0)
DecompCache[191:160] = Base4 - CompCache[79:72];
else
DecompCache[191:160] = CompCache[79:72]+ Base4 ;


if(flag4[6]==1'b0)
DecompCache[223:192] = Base4 - CompCache[87:80];
else
DecompCache[223:192] = CompCache[87:80]+ Base4 ;

if(flag4[7]==1'b0)
DecompCache[255:224] = Base4 - CompCache[95:88];
else
DecompCache[255:224] = CompCache[95:88]+ Base4 ;

$fdisplay(decompfile,"%h",DecompCache);
end





//BASE 4 DEL 2 BYTES

else if(CoN==6)
begin

flag4 = CompCacheEn[11:4]; //8bits
CompCache = CompCacheEn[259:12];
Base4 = CompCache[31:0]; //Base4


if(flag4[0]==1'b0)
DecompCache[31:0] = Base4 - CompCache[47:32];
else
DecompCache[31:0] = CompCache[47:32]+ Base4 ;


if(flag4[1]==1'b0)
DecompCache[63:32] = Base4 - CompCache[63:48];
else
DecompCache[63:32] = CompCache[63:48]+ Base4 ;


if(flag4[2]==1'b0)
DecompCache[95:64] = Base4 - CompCache[79:64];
else
DecompCache[95:64] = CompCache[79:64]+ Base4 ;


if(flag4[3]==1'b0)
DecompCache[127:96] = Base4 - CompCache[95:80];
else
DecompCache[127:96] = CompCache[95:80]+ Base4 ;


if(flag4[4]==1'b0)
DecompCache[159:128] = Base4 - CompCache[111:96];
else
DecompCache[159:128] = CompCache[111:96]+ Base4 ;


if(flag4[5]==1'b0)
DecompCache[191:160] = Base4 - CompCache[127:112];
else
DecompCache[191:160] = CompCache[127:112]+ Base4 ;


if(flag4[6]==1'b0)
DecompCache[223:192] = Base4 - CompCache[143:128];
else
DecompCache[223:192] = CompCache[143:128]+ Base4 ;

if(flag4[7]==1'b0)
DecompCache[255:224] = Base4 - CompCache[159:144];
else
DecompCache[255:224] = CompCache[159:144]+ Base4 ;

$fdisplay(decompfile,"%h",DecompCache);
end


//BASE 2 DEL 1 BYTE
else if(CoN==7)
begin
flag2 = CompCacheEn[19:4]; 
//16 bits : 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
CompCache = CompCacheEn[259:20];
Base2  = CompCache[15:0]; //Base2


if(flag2[15]==1'b0)                                    //flag for first uncompressed block is flag2 [15] in compressor....not in sequence but it is like that only.
DecompCache[15:0] = Base2 - CompCache[23:16];
else 
DecompCache[15:0] = CompCache[23:16]+ Base2 ;


if(flag2[0]==1'b0) 
DecompCache[31:16] = Base2 - CompCache[31:24];
else 
DecompCache[31:16] = CompCache[31:24]+ Base2 ;

if(flag2[1]==1'b0)
DecompCache[47:32] = Base2 - CompCache[39:32];
else 
DecompCache[47:32] = CompCache[39:32]+ Base2 ;

if(flag2[2]==1'b0)
DecompCache[63:48] = Base2 - CompCache[47:40];
else 
DecompCache[63:48] = CompCache[47:40]+ Base2 ;

if(flag2[3]==1'b0)
DecompCache[79:64] = Base2 - CompCache[55:48];
else 
DecompCache[79:64] = CompCache[55:48]+ Base2 ;

if(flag2[4]==1'b0)
DecompCache[95:80] = Base2 - CompCache[63:56];
else 
DecompCache[95:80] = CompCache[63:56]+ Base2 ;

if(flag2[5]==1'b0)
DecompCache[111:96] = Base2 - CompCache[71:64];
else 
DecompCache[111:96] = CompCache[71:64]+ Base2 ;

if(flag2[6]==1'b0)
DecompCache[127:112] = Base2 - CompCache[79:72];
else 
DecompCache[127:112] = CompCache[79:72]+ Base2 ;

if(flag2[7]==1'b0)
DecompCache[143:128] = Base2 - CompCache[87:80];
else 
DecompCache[143:128] = CompCache[87:80]+ Base2 ;

if(flag2[8]==1'b0)
DecompCache[159:144] = Base2 - CompCache[95:88];
else 
DecompCache[159:144] = CompCache[95:88]+ Base2 ;

if(flag2[9]==1'b0)
DecompCache[175:160] = Base2 - CompCache[103:96];
else 
DecompCache[175:160] = CompCache[103:96]+ Base2 ;

if(flag2[10]==1'b0)
DecompCache[191:176] = Base2 - CompCache[111:104];
else 
DecompCache[191:176] = CompCache[111:104]+ Base2 ;

if(flag2[11]==1'b0)
DecompCache[207:192] = Base2 - CompCache[119:112];
else 
DecompCache[207:192] = CompCache[119:112]+ Base2 ;

if(flag2[12]==1'b0)
DecompCache[223:208] = Base2 - CompCache[127:120];
else 
DecompCache[223:208] = CompCache[127:120]+ Base2 ;

if(flag2[13]==1'b0)
DecompCache[239:224] = Base2 - CompCache[135:128];
else 
DecompCache[239:224] = CompCache[135:128]+ Base2 ;

if(flag2[14]==1'b0)
DecompCache[255:240] = Base2 - CompCache[143:136];
else 
DecompCache[255:240] = CompCache[143:136]+ Base2 ;

$display("%h",DecompCache);
$fdisplay(decompfile,"%h",DecompCache);
end

//Repeated Values 8bytes
else if(CoN==1)
begin
CompCache = CompCacheEn[259:4];
Base8 = CompCache[63:0]; //Base8
DecompCache[63:0] = Base8;
DecompCache[127:64] = Base8;
DecompCache[191:128] = Base8;
DecompCache[255:192] = Base8;
$display("%h",DecompCache);
$fdisplay(decompfile,"%h",DecompCache);
end

//uncompressed
else if(CoN==15)
begin 
DecompCache = CompCacheEn[259:4];
$display("%h",DecompCache);
$fdisplay(decompfile,"%h",DecompCache);
end





end //always
endmodule

/*module DecompUnit_TB;

	// Inputs
	reg clk;

	// Outputs
	wire [255:0] DecompCache;

	// Instantiate the Unit Under Test (UUT)
	DecompressorUnit uut (
		.clk(clk), 
		.DecompCache(DecompCache)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
	end
	
 always
#5 clk = ~clk;
initial #10 $finish;
     
endmodule*/
