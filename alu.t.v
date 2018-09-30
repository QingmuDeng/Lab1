`timescale 1 ns / 1 ps
`include "alu.v"

module testALU();
  wire[31:0]    res;
  wire          cout;
  wire          zero;
  wire          ovf;
  reg[31:0]     a;
  reg[31:0]     b;
  reg[2:0]      cmd;

  ALU dut(.result(res), .carryout(cout), .zero(zero), .overflow(ovf), .operandA(a), .operandB(b), .command(cmd));

  /*
  `define ADD  3'd0
  `define SUB  3'd1
  `define XOR  3'd2
  `define SLT  3'd3
  `define AND  3'd4
  `define NAND 3'd5
  `define NOR  3'd6
  `define OR   3'd7
  */

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, dut);
    a = 32'sd0; b = 32'sd0; cmd = 3'd0; #1000
    $display("  A      B    Command | Result  Carryout  Overflow  Zero | Expected Output");

    /* Adder Test */
    a = 32'sd0; b = 32'sd0; cmd = 3'd0; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   0...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    //  a positive int to another int
    a = 32'sd1; b = 32'sd3; cmd = 3'd0; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   4...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    // a positive int to a negative int to get a positive int
    a = 32'sd4; b = -32'sd2; cmd = 3'd0; #1000
    $display("%b    %b     %b  |  %b   %b    %b    %b   |   2...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    // a positive int to a negative int to get a negative int
    a = 32'sd5; b = -32'sd7; cmd = 3'd0; #1000
    $display("%b    %b     %b  |  %b   %b    %b    %b   |   6...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    // a positive int to a negative int to get a negative int
    a = 32'sd1; b = 32'sd1; cmd = 3'd0; #1000
    $display("%b    %b     %b  |  %b   %b    %b    %b   |   expected...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end



// a = 4'b0001; b = 4'b0001; #1000
// $display(" %b   %b  |  %b    %b    %b     |   2", a, b, carryout, sum, overflow);
// a = 4'b0111; b = 4'b1111; #1000
// $display(" %b   %b  |  %b    %b    %b     |   6", a, b, carryout, sum, overflow);
// a = 4'b1000; b = 4'b0111; #1000
// $display(" %b   %b  |  %b    %b    %b     |   -1", a, b, carryout, sum, overflow);
// a = 4'b1110; b = 4'b1101; #1000
// $display(" %b   %b  |  %b    %b    %b     |   -5", a, b, carryout, sum, overflow);
// a = 4'b0001; b = 4'b0011; #1000
// $display(" %b   %b  |  %b    %b    %b     |   4", a, b, carryout, sum, overflow);
// $display("\nTest Overflow:");
// a = 4'b0011; b = 4'b0110; #1000
// $display(" %b   %b  |  %b    %b    %b     |   9/Overflow", a, b, carryout, sum, overflow);
// a = 4'b1100; b = 4'b1011; #1000
// $display(" %b   %b  |  %b    %b    %b     |   -9/Overflow", a, b, carryout, sum, overflow);

    /* */


  end
endmodule
