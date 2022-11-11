`timescale 1ns/1ps

`define delay   10

module ModInv_tb;

reg [3:0] mem [0:11];
reg [7:0] Mul;
reg [3:0] Mod;

reg clk, start;
reg [3:0] A,p;
wire [3:0] B;
wire busy;

integer i;

ModInv ModInv(clk, A, B, p, start, busy);

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #100000 
  $finish;
end

always #50  clk = ~clk;

initial begin
  mem[0] = {4'h1};
  mem[1] = {4'h2};
  mem[2] = {4'h3};
  mem[3] = {4'h4};
  mem[4] = {4'h5};
  mem[5] = {4'h6};
  mem[6] = {4'h7};
  mem[7] = {4'h8};
  mem[8] = {4'h9};
  mem[9] = {4'ha};
  mem[10] = {4'hb};
  mem[11] = {4'hc};
  p = 4'hd;
  clk=1;  // initialize clk

    for(i=0;i<12;i=i+1)begin
        start = 0;
        {A} = mem[i];
        @(posedge clk)  #`delay;
        start = 1;
        @(posedge clk)  #`delay;
        while (busy==1) @(posedge clk);
        Mul = (A*B); 
        Mod = Mul%p;
        if(Mod==1) begin
            $display("%h:Path Expect=%h B=%h",A,Mod,B);
        end else begin
            $display("%h:Error Expect=%h B=%h",A,Mod,B);
        end
    end
$finish;
end

endmodule