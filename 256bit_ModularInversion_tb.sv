`timescale 1ns/1ps

`define delay   10

class seq_item #();

  rand bit [255:0] rand_A;
  constraint value_A {rand_A inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}

endclass

module ModInv_tb;

reg [255:0] Expect;
reg [511:0] Mul;
reg [255:0] Mod;

reg clk, start;
reg [255:0] A,p;
wire [255:0] B;
wire busy;

ModInv ModInv(clk, A, B, p, start, busy);
seq_item #() item;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #1000000 
  $finish;
end

always #50  clk = ~clk;

initial begin
 
  p = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
  clk=1;  // initialize clk
  item = new();

    repeat(30) begin
        start = 0;
        item.randomize();
        A = item.rand_A;
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