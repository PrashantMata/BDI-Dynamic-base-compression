`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:35:26 09/22/2018 
// Design Name: 
// Module Name:    CompressorUnit 
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

module CompressorUnit(clk,CompCache);
input clk;
output reg[259:0]CompCache;
parameter SIZE = 13350; //no. of lines in the uncompdata.txt file
 
reg [255:0]UncompCache;
reg [11:0]CCL0;
reg [103:0]CCL1;
reg [107:0]CCL4;
reg [135:0]CCL2;
reg [198:0]CCL3;
reg [171:0]CCL5; //variable compression
reg [35:0]CCL9;
reg [163:0]CCL6;
reg [67:0]CCL7;
reg CoN0,CoN1,CoN2,CoN3,CoN4,CoN5,CoN6,CoN7,CoN9;
reg [255:0] uncompdata [0:(SIZE-1)];
integer i=0;
reg [255:0]zeros = 256'd0;

reg [63:0]Base8;
reg [63:0]del8_0,del8_1,del8_2,del8_3;
reg [3:0]flag8;


reg [7:0]flag4;
reg [31:0]Base4;
reg [255:0] del4_0,del4_1,del4_2,del4_3,del4_4,del4_5,del4_6,del4_7;


reg [15:0]Base2;
reg [15:0] del2_0,del2_1,del2_2,del2_3,del2_4,del2_5,del2_6,del2_7,del2_8,del2_9,del2_10,del2_11,del2_12,del2_13,del2_14,del2_15;
reg [15:0]flag2;




integer outfile;

initial
begin
$readmemh("/home/lifam/Desktop/Master BDI/Uncompressed data/arctic_bits.txt", uncompdata);
end

//COMPRESSOR BLOCK
always @ (posedge clk)
begin
outfile = $fopen("/home/lifam/Desktop/Master BDI/BDI_comp_firstbase_total/improved/arctic_comp_firstbase_total.txt");
$fdisplay(outfile,"\n");

for (i=0; i < SIZE; i=i+1)
begin

UncompCache = uncompdata [i];
$display("%d:UnComp= %h",i,uncompdata[i]);




//______________________________________________________________________________________________________________________
//____________________________________________________________________________________________________________________

////*************//////BASE 8/////**************//////
//Calculating all the deltas
Base8 = UncompCache[255:192];
$display("Base8=%h",Base8);
if (Base8 > UncompCache[63:0])
begin
del8_0 = Base8 - UncompCache[63:0];
flag8[0] =0;
end
else 
begin
del8_0 = UncompCache[63:0] - Base8 ;
flag8[0] =1;
end

if (Base8 > UncompCache[127:64])
begin
del8_1 = Base8 - UncompCache[127:64];
flag8[1] =0;
end
else 
begin
del8_1 = UncompCache[127:64] - Base8 ;
flag8[1] =1;
end

if (Base8 > UncompCache[191:128])
begin
del8_2 = Base8 - UncompCache[191:128];
flag8[2] =0;
end
else 
begin
del8_2 = UncompCache[191:128] - Base8 ;
flag8[2] = 1;
end

if (Base8 > UncompCache[255:192])
begin
del8_3 = Base8 - UncompCache[255:192];
flag8[3] =0;
end
else 
begin
del8_3 = UncompCache[255:192] - Base8 ;
flag8[3]=1;
end
$display (" 8_1: del0 = %h, del1= %h, del2 =%h, del3 = %h flag8=%b \n",del8_0,del8_1,del8_2,del8_3,flag8);

//////////////Zeros///////////////////////
if((UncompCache[63:0]==64'h0000000000000000) && (UncompCache[127:64]==64'h0000000000000000) && 
(UncompCache[191:128]==64'h0000000000000000) && (UncompCache[255:192]==64'h0000000000000000)) 
begin
CoN0=1;
CCL0 = {8'd0,4'd0}; // extra = 4 bits; tot=12bits
end
else
CoN0 = 0;
$display ("CoN0 = %b, CCL0 = %h ", CoN0,CCL0);

//////////////Repeated Data/////////////////////
if( (del8_0[63:0]==64'h0000000000000000) &&(del8_1[63:0]==64'h0000000000000000) && (del8_2[63:0]==64'h0000000000000000) && (del8_3[63:0]==64'h0000000000000000)) 
begin
CoN7=1;
CCL7 = {UncompCache[63:0],4'd1}; // tot = 68bits
end
else
CoN7 = 0;
$display ("CoN7 = %b, CCL7 = %h ", CoN7,CCL7);

// Delta = 1 byte
if( ((del8_0[63:8]==56'hFFFFFFFFFFFFFF) || (del8_0[63:8]==56'h00000000000000)) &&((del8_1[63:8]==56'hFFFFFFFFFFFFFF) || (del8_1[63:8]==56'h00000000000000)) && ((del8_2[63:8]==56'hFFFFFFFFFFFFFF) || (del8_2[63:8]==56'h00000000000000))
		&& ((del8_3[63:8]==56'hFFFFFFFFFFFFFF) || (del8_3[63:8]==56'h00000000000000)))
begin
CoN1=1;
CCL1 = {del8_3[7:0],del8_2[7:0],del8_1[7:0],del8_0[7:0],Base8,flag8,4'd2};
end

else 
begin
CoN1=0;
end
$display ("CoN1 = %b, CCL1 = %h ", CoN1,CCL1);

//////////Base 8 del 2////////////
if( ((del8_0[63:16]==48'hFFFFFFFFFFFF) || (del8_0[63:16]==48'h000000000000)) && ((del8_1[63:16]==48'hFFFFFFFFFFFF) || (del8_1[63:16]==48'h000000000000)) && ((del8_2[63:16]==48'hFFFFFFFFFFFF) || (del8_2[63:16]==48'h000000000000))
		&& ((del8_3[63:16]==48'hFFFFFFFFFFFF) || (del8_3[63:16]==48'h000000000000)))
begin
CoN2=1;
CCL2 = {del8_3[15:0],del8_2[15:0],del8_1[15:0],del8_0[15:0],Base8,flag8,4'd3}; //extra = 8bits ; tot = 136bits
end
else 
CoN2=0;
$display ("CoN2 = %b, CCL2 = %h ", CoN2,CCL2);


////////////// Delta = 4 bytes//////////////
if( ((del8_0[63:32]==32'hFFFFFFFF) || (del8_0[63:32]==32'h00000000)) && ((del8_1[63:32]==32'hFFFFFFFF) || (del8_1[63:32]==32'h00000000)) && 
((del8_2[63:32]==32'hFFFFFFFF) || (del8_2[63:32]==32'h00000000))		&& ((del8_3[63:32]==32'hFFFFFFFF) || (del8_3[63:32]==32'h00000000)))
begin
CoN3=1;
CCL3 = {del8_3[31:0],del8_2[31:0],del8_1[31:0],del8_0[31:0],Base8,flag8,4'd4}; //extra = 8bits ; tot = 200bits
end
else 
CoN3=0;
$display ("CoN3 = %b, CCL3 = %h ", CoN3,CCL3);





//////********/////BASE 4///////*******////////
//Calculating all the deltas
Base4 = UncompCache[255:224];
if (Base4 > UncompCache[31:0])
begin
del4_0 = Base4 - UncompCache[31:0];
flag4[0] =0;
end
else 
begin
del4_0 = UncompCache[31:0] - Base4 ;
flag4[0] =1;
end

if (Base4 > UncompCache[63:32])
begin
del4_1 = Base4 - UncompCache[63:32];
flag4[1] =0;
end
else 
begin
del4_1 = UncompCache[63:32] - Base4 ;
flag4[1] =1;
end

if (Base4 > UncompCache[95:64])
begin
del4_2 = Base4 - UncompCache[95:64];
flag4[2] =0;
end
else 
begin
del4_2 = UncompCache[95:64] - Base4 ;
flag4[2] =1;
end

if (Base4 > UncompCache[127:96])
begin
del4_3 = Base4 - UncompCache[127:96];
flag4[3] =0;
end
else 
begin
del4_3 = UncompCache[127:96] - Base4 ;
flag4[3] =1;
end

if (Base4 > UncompCache[159:128])
begin
del4_4 = Base4 - UncompCache[159:128];
flag4[4] =0;
end
else 
begin
del4_4 = UncompCache[159:128] - Base4 ;
flag4[4] =1;
end

if (Base4 > UncompCache[191:160])
begin
del4_5 = Base4 - UncompCache[191:160];
flag4[5] =0;
end
else 
begin
del4_5 = UncompCache[191:160] - Base4 ;
flag4[5] =1;
end

if (Base4 > UncompCache[223:192])
begin
del4_6 = Base4 - UncompCache[223:192];
flag4[6] =0;
end
else 
begin
del4_6 = UncompCache[223:192] - Base4 ;
flag4[6] =1;
end

if (Base4 > UncompCache[255:224])
begin
del4_7 = Base4 - UncompCache[255:224];
flag4[7] =0;
end
else 
begin
del4_7 = UncompCache[255:224] - Base4 ;
flag4[7] =1;
end

$display (" BASE 4: del1= %h, del2 =%h, del3 = %h del4 = %h del5 = %h del6 = %h del7 = %h flag4=%b\n",del4_1,del4_2,del4_3,del4_4,del4_5,del4_6,del4_7,flag4);

// DELTA = 1 BYTE 



/*count4a=0;
if((del4_0[31:8]==24'hFFFFFF) || (del4_0[31:8]==24'h000000)) 
begin
compstatus4a[0] = 1'b1;
count4a=count4a + 1;
CCL4 = del4_0[7:0]; 
len4a = 1; //no. of 8 bits
end
else
begin
compstatus4a[0] = 1'b0;
CCL4 = del4_0; 
len4a = 4; //32bits
end
$display("CCL4 = %h,len4= %d ",CCL4,len4a);
$display("count4= %d",count4a);

if((del4_1[31:8]==24'hFFFFFF) || (del4_1[31:8]==24'h000000)) 
begin
compstatus4a[1] = 1'b1;
count4a=count4a + 1;
CCL4 = CCL4 | (del4_1[7:0] << (len4a*8)); 
len4a = len4a+1; //no. of 8bits
end
else
begin
compstatus4a[1] = 1'b0;
CCL4 = CCL4 | (del4_1 << (len4a*8)); 
len4a = len4a + 4; //32bits
end
$display("CCL4 = %h,len4a= %d ",CCL4,len4a);
$display("count4a= %d",count4a);

if((del4_2[31:8]==24'hFFFFFF) || (del4_2[31:8]==24'h000000)) 
begin
compstatus4a[2] = 1'b1;
count4a=count4a + 1;
CCL4 = CCL4 | (del4_2[7:0] << (len4a*8)); 
len4a = len4a+1; //no. of 8bits
end
else
begin
compstatus4a[2] = 1'b0;
CCL4 = CCL4 | (del4_2 << (len4a*8)); 
len4a = len4a+4; //32bits
end
$display("CCL4 = %h,len4a= %d ",CCL4,len4a);
$display("count4a= %d",count4a);

if((del4_3[31:8]==24'hFFFFFF) || (del4_3[31:8]==24'h000000)) 
begin
compstatus4a[3] = 1'b1;
count4a=count4a + 1;
CCL4 = CCL4 | (del4_3[7:0] << (len4a*8)); 
len4a = len4a+1; //no. of 8bits
end
else
begin
compstatus4a[3] = 1'b0;
CCL4 = CCL4 | (del4_3 << (len4a*8)); 
len4a = len4a+4; //32bits
end
$display("CCL4 = %h,len4a= %d ",CCL4,len4a);
$display("count4a= %d",count4a);

if((del4_4[31:8]==24'hFFFFFF) || (del4_4[31:8]==24'h000000)) 
begin
compstatus4a[4] = 1'b1;
count4a=count4a + 1;
CCL4 = CCL4 | (del4_4[7:0] << (len4a*8)); 
len4a = len4a+1; //no. of 8bits
end
else
begin
compstatus4a[4] = 1'b0;
CCL4 = CCL4 | (del4_4 << (len4a*8)); 
len4a = len4a+4; //32bits
end
$display("CCL4 = %h,len4a= %d ",CCL4,len4a);
$display("count4a= %d",count4a);

if((del4_5[31:8]==24'hFFFFFF) || (del4_5[31:8]==24'h000000)) 
begin
compstatus4a[5] = 1'b1;
count4a=count4a + 1;
CCL4 = CCL4 | (del4_5[7:0] << (len4a*8)); 
len4a = len4a+1; //no. of 8bits
end
else
begin
compstatus4a[5] = 1'b0;
CCL4 = CCL4 | (del4_5 << (len4a*8)); 
len4a = len4a+4; //32bits
end
$display("CCL4 = %h,len4a= %d ",CCL4,len4a);
$display("count4a= %d",count4a);

if((del4_6[31:8]==24'hFFFFFF) || (del4_6[31:8]==24'h000000)) 
begin
compstatus4a[6] = 1'b1;
count4a=count4a + 1;
CCL4 = CCL4 | (del4_6[7:0] << (len4a*8)); 
len4a = len4a+1; //no. of 8bits
end
else
begin
compstatus4a[6] = 1'b0;
CCL4 = CCL4 | (del4_6 << (len4a*8)); 
len4a = len4a+4; //32bits
end
$display("CCL4 = %h,len4a= %d ",CCL4,len4a);
$display("count4a= %d",count4a);

if((del4_7[31:8]==24'hFFFFFF) || (del4_7[31:8]==24'h000000)) 
begin
compstatus4a[7] = 1'b1;
count4a=count4a + 1;
CCL4 = CCL4 | (del4_7[7:0] << (len4a*8)); 
len4a = len4a+1; //no. of 8bits
end
else
begin
compstatus4a[7] = 1'b0;
CCL4 = CCL4 | (del4_7 << (len4a*8)); 
len4a = len4a+4; //32bits
end*/








if( ((del4_0[31:8]==24'hFFFFFF) || (del4_0[31:8]==24'h000000)) && ((del4_1[31:8]==24'hFFFFFF) || (del4_1[31:8]==24'h000000)) 
		&& ((del4_2[31:8]==24'hFFFFFF) || (del4_2[31:8]==24'h000000)) && ((del4_3[31:8]==24'hFFFFFF) || (del4_3[31:8]==24'h000000))  
		&& ((del4_4[31:8]==24'hFFFFFF) || (del4_4[31:8]==24'h000000)) 	&& ((del4_5[31:8]==24'hFFFFFF) || (del4_5[31:8]==24'h000000))  
		&& ((del4_6[31:8]==24'hFFFFFF) || (del4_6[31:8]==24'h000000)) 	&& ((del4_7[31:8]==24'hFFFFFF) || (del4_7[31:8]==24'h000000)))
begin
CoN4=1;
CCL4 = {del4_7[7:0],del4_6[7:0],del4_5[7:0],del4_4[7:0],del4_3[7:0],del4_2[7:0],del4_1[7:0],del4_0[7:0],Base4,flag4,4'd5}; //11bits; 107bits
//extra = 11 bits
end
else 
CoN4 =0;
$display ("CoN4 = %b, CCL4 = %h ", CoN4,CCL4);


// DELTA = 2 BYTES

if( ((del4_0[31:16]==16'hFFFF) || (del4_0[31:16]==16'h0000)) && ((del4_1[31:16]==16'hFFFF) || (del4_1[31:16]==16'h0000))
	&& ((del4_2[31:16]==16'hFFFF) || (del4_2[31:16]==16'h0000)) && ((del4_3[31:16]==16'hFFFF) || (del4_3[31:16]==16'h0000))
	&& ((del4_4[31:16]==16'hFFFF) || (del4_4[31:16]==16'h0000)) && ((del4_5[31:16]==16'hFFFF) || (del4_5[31:16]==16'h0000))
	&& ((del4_6[31:16]==16'hFFFF) || (del4_6[31:16]==16'h0000)) && ((del4_7[31:16]==16'hFFFF) || (del4_7[31:16]==16'h0000))	 )
	
	begin
	CoN5=1;
	CCL5 = {del4_7[15:0],del4_6[15:0],del4_5[15:0],del4_4[15:0],del4_3[15:0],del4_2[15:0],del4_1[15:0],del4_0[15:0],Base4,flag4,4'd6};
	end
	
else 
    CoN5 =0;

//Base4,compstatus4,flag4,4'd6}; //32+16+4 = 52 ; metadata = 20 bits;




//////////////Repeated Data/////////////////////
if( (del4_0[31:0]==32'h00000000) && (del4_1[31:0]==32'h00000000) && (del4_2[31:0]==32'h00000000) && (del4_3[31:0]==32'h00000000) &&
		(del4_4[31:0]==32'h00000000) && (del4_5[31:0]==32'h00000000) && (del4_6[31:0]==32'h00000000) && (del4_7[31:0]==32'h00000000)) 
begin
CoN9=1;
CCL9 = {UncompCache[31:0],4'd9}; 
end
else
CoN9 = 0;
$display ("CoN9 = %b, CCL9 = %h ", CoN9,CCL9);





//////////////BASE 2/////////////////////


Base2 = UncompCache[255:240];

//Calculating all the deltas

if (Base2 > UncompCache[31:16])
begin
del2_1 = Base2 - UncompCache[31:16];
flag2[0] =0;
end
else 
begin
del2_1 = UncompCache[31:16] - Base2 ;
flag2[0] =1;
end

if (Base2 > UncompCache[47:32])
begin
del2_2 = Base2 - UncompCache[47:32];
flag2[1] =0;
end
else 
begin
del2_2 = UncompCache[47:32] - Base2 ;
flag2[1] =1;
end

if (Base2 > UncompCache[63:48])
begin
del2_3 = Base2 - UncompCache[63:48];
flag2[2] =0;
end
else 
begin
del2_3 = UncompCache[63:48] - Base2 ;
flag2[2] =1;
end

if (Base2 > UncompCache[79:64])
begin
del2_4 = Base2 - UncompCache[79:64];
flag2[3] =0;
end
else 
begin
del2_4 = UncompCache[79:64] - Base2 ;
flag2[3] =1;
end

if (Base2 > UncompCache[95:80])
begin
del2_5 = Base2 - UncompCache[95:80];
flag2[4] =0;
end
else 
begin
del2_5 = UncompCache[95:80] - Base2 ;
flag2[4] =1;
end

if (Base2 > UncompCache[111:96])
begin
del2_6 = Base2 - UncompCache[111:96];
flag2[5] =0;
end
else 
begin
del2_6 = UncompCache[111:96] - Base2 ;
flag2[5] =1;
end

if (Base2 > UncompCache[127:112])
begin
del2_7 = Base2 - UncompCache[127:112];
flag2[6] =0;
end
else 
begin
del2_7 = UncompCache[127:112] - Base2 ;
flag2[6] =1;
end

if (Base2 > UncompCache[143:128])
begin
del2_8 = Base2 - UncompCache[143:128];
flag2[7] =0;
end
else 
begin
del2_8 = UncompCache[143:128] - Base2 ;
flag2[7] =1;
end

if (Base2 > UncompCache[159:144])
begin
del2_9 = Base2 - UncompCache[159:144];
flag2[8] =0;
end
else 
begin
del2_9 = UncompCache[159:144] - Base2 ;
flag2[8] =1;
end

if (Base2 > UncompCache[175:160])
begin
del2_10 = Base2 - UncompCache[175:160];
flag2[9] =0;
end
else 
begin
del2_10 = UncompCache[175:160] - Base2 ;
flag2[9] =1;
end

if (Base2 > UncompCache[191:176])
begin
del2_11 = Base2 - UncompCache[191:176];
flag2[10] =0;
end
else 
begin
del2_11 = UncompCache[191:176] - Base2 ;
flag2[10] =1;
end

if (Base2 > UncompCache[207:192])
begin
del2_12 = Base2 - UncompCache[207:192];
flag2[11] =0;
end
else 
begin
del2_12 = UncompCache[207:192] - Base2 ;
flag2[11] =1;
end

if (Base2 > UncompCache[223:208])
begin
del2_13 = Base2 - UncompCache[223:208];
flag2[12] =0;
end
else 
begin
del2_13 = UncompCache[223:208] - Base2 ;
flag2[12] =1;
end

if (Base2 > UncompCache[239:224])
begin
del2_14 = Base2 - UncompCache[239:224];
flag2[13] =0;
end
else 
begin
del2_14 = UncompCache[239:224] - Base2 ;
flag2[13] =1;
end

if (Base2 > UncompCache[255:240])
begin
del2_15 = Base2 - UncompCache[255:240];
flag2[14] =0;
end
else 
begin
del2_15 = UncompCache[255:240] - Base2 ;
flag2[14] =1;
end


if (Base2 > UncompCache[15:0])
begin
del2_0 = Base2 - UncompCache[15:0];
flag2[15] =0;
end
else 
begin
del2_0 = UncompCache[15:0] - Base2 ;
flag2[15] =1;
end





$display ("BASE 2:del1= %h,del2 =%h,del3 = %h,del4 = %h,del5 = %h,del6 = %h,del7 = %h,del8= %h,del9 =%h,del10 = %h,del11 = %h del12 = %h,del13 = %h del14 = %h del7 = %h flag2=%b\n",
del2_1,del2_2,del2_3,del2_4,del2_5,del2_6,del2_7,del2_8,del2_9,del2_10,del2_11,del2_12,del2_13,del2_14,del2_15,flag2);

// DELTA = 1 BYTE 
if( ((del2_1[15:8]==8'hFF) || (del2_1[15:8]==8'h00)) && ((del2_2[15:8]==8'hFF) || (del2_2[15:8]==8'h00))
		&& ((del2_3[15:8]==8'hFF) || (del2_3[15:8]==8'h00))  && ((del2_4[15:8]==8'hFF) || (del2_4[15:8]==8'h00))  
		&& ((del2_5[15:8]==8'hFF) || (del2_5[15:8]==8'h00))  && ((del2_6[15:8]==8'hFF) || (del2_6[15:8]==8'h00))
		&& ((del2_7[15:8]==8'hFF) || (del2_7[15:8]==8'h00))  && ((del2_8[15:8]==8'hFF) || (del2_8[15:8]==8'h00))
		&& ((del2_9[15:8]==8'hFF) || (del2_9[15:8]==8'h00))  && ((del2_10[15:8]==8'hFF) || (del2_10[15:8]==8'h00))
		&& ((del2_11[15:8]==8'hFF)|| (del2_11[15:8]==8'h00))&& ((del2_12[15:8]==8'hFF) || (del2_12[15:8]==8'h00))
		&& ((del2_13[15:8]==8'hFF)|| (del2_13[15:8]==8'h00))&& ((del2_14[15:8]==8'hFF) || (del2_14[15:8]==8'h00))
		&& ((del2_15[15:8]==8'hFF)|| (del2_15[15:8]==8'h00)))
begin
CoN6=1;
CCL6 = {del2_15[7:0],del2_14[7:0],del2_13[7:0],del2_12[7:0],del2_11[7:0],del2_10[7:0],del2_9[7:0],del2_8[7:0],
del2_7[7:0],del2_6[7:0],del2_5[7:0],del2_4[7:0],del2_3[7:0],del2_2[7:0],del2_1[7:0],del2_0[7:0],Base2,flag2,4'd7}; 
//extra 20 bits ; 164bits
end
else 
CoN6 =0;
$display ("CoN6 = %b, CCL6 = %h ", CoN6,CCL6);



//////////////SELECTION AND WRITING INTO THE COMPDATA FILE/////////////
if(CoN0==1) //Zeros highest priority as it is 1 byte compdata
begin
CompCache = CCL0;
$fdisplay(outfile,"%h",CCL0);
end


else if(CoN9==1) //Repeated Data base 4
begin
CompCache = CCL9;
$fdisplay(outfile,"%h",CCL9);
end

else if ((CoN7==1) && (CoN9==0)) //Repeated Data base 8
begin
CompCache = CCL7;
$fdisplay(outfile,"%h",CCL7);
end

else if ((CoN0==0) &&  (CoN1==0) &&  (CoN2==0) &&  (CoN3==0) && (CoN4==0) && (CoN5==0) &&  (CoN6==0) && (CoN7==0) && (CoN9==0))//NoComp
begin 
CompCache = {UncompCache,4'd15}; //No Compression feasible
$fdisplay(outfile,"%h",CompCache);
end

else 
begin

if(CoN1==1 && ((CoN4==1)||(CoN4==0)) ) // Base8, del1 2nd prio, irresp of Base4,del1, although both are 12 bytes compdata
begin
CompCache = CCL1;
$fdisplay(outfile,"%h",CCL1);
end


else if(CoN1==0 && CoN4==1) //Base4,del1
begin
CompCache = CCL4;
$fdisplay(outfile,"%h",CCL4);
end

else
begin

if(CoN2==1)
begin
CompCache = CCL2;
$fdisplay(outfile,"%h",CCL2);
end

else 
begin

if(CoN6==1)
begin
CompCache = CCL6; //164 BITS
$fdisplay(outfile,"%h",CCL6);
end

else 
begin

if(CoN5==1)
begin
CompCache = CCL5;
$fdisplay(outfile,"%h",CCL5);

end

else 
begin

if(CoN3==1)
begin
CompCache = CCL3;
$fdisplay(outfile,"%h",CCL3);
end

/*else 
begin

if(CoN9==1)
begin
CompCache = CCL9;
$fdisplay(outfile,"%h",CCL9);
end

end*/
end
end
end
end
end
end // i for loop
end // always/*
initial $fclose(outfile);
endmodule





//`timescale 1ns / 1ps


module CompUnit_TB;

	// Inputs
	reg clk;

	// Outputs
	wire [255:0] CompCache;
	

	// Instantiate the Unit Under Test (UUT)
	CompressorUnit uut (
		.clk(clk), 
		//.UncompCache(UncompCache), 
		.CompCache(CompCache)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
	end
    
always
#5 clk = ~clk; 
initial #10 $finish ;
endmodule

