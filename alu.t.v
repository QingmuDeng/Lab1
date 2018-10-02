`timescale 1 ns / 1 ps
`include "alu.v"

`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7


module testALU();
  wire signed [31:0]    res;
  wire          cout;
  wire          zero;
  wire          ovf;
  reg signed [31:0]     a;
  reg signed [31:0]     b;
  reg[2:0]      cmd;

  ALU dut(.result(res), .carryout(cout), .zero(zero), .overflow(ovf), .operandA(a), .operandB(b), .command(cmd));


  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, dut);
    a = 32'sd0; b = 32'sd0; cmd = `ADD; #100
    $display("          A              B    Cmd |          Res Cout  Ovf  Zero | Expected");

    /****************************   Adder Test   ****************************/
    a = 32'sd2; b = 32'sd1; cmd = `ADD; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   3...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%d and b=%d", a, b);
    end

    a = 32'sd2312; b = 32'sd123; cmd = `ADD; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2435...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    a = 32'sd543290; b = 32'sd34124123; cmd = `ADD; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   34667413...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    a = 32'sd4; b = -32'sd2; cmd = `ADD; #10000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    a = -32'sd5; b = -32'sd7; cmd = `ADD; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   -12...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    a = 32'sd1; b = 32'sd1; cmd = `ADD; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    if(res != a+b) begin
      $display("adder fault with a=%b and b=%b", a, b);
    end

    /**************************** Subtractor Test ****************************/
    a = 32'sd4; b = 32'sd2; cmd = `SUB; #10000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    if(res != a-b) begin
      $display("subtractor fault with a=%b and b=%b, the result should be %d", a, b, a-b);
    end

    /**************************** Set Less Than Test ****************************/
    a = 32'sd4; b = 32'sd2; cmd = `SLT; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    if(res != (a < b)) begin
      $display("SLT fault with a=%b and b=%b", a, b);
    end

    a = 32'sd2; b = 32'sd4; cmd = `SLT; #10000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    if(res != (a < b)) begin
      $display("SLT fault with a=%b and b=%b", a, b);
    end

    a = 32'sd100; b = 32'sd100; cmd = `SUB; #10000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    if(res != a-b) begin
      $display("subtractor fault with a=%b and b=%b, the result should be %d", a, b, a-b);
    end

    /**************************** XOR Logic Test ****************************/
    a = 32'sd4; b = 32'sd2; cmd = `XOR; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    // if(res != a+b) begin
    //   $display("XOR fault with a=%b and b=%b", a, b);
    // end

    /**************************** NAND Logic Test ****************************/
    a = 32'sb1101111; b = 32'sb1111100; cmd = `NAND; #1000
    $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    // if(res != a+b) begin
    //   $display("NAND fault with a=%b and b=%b", a, b);
    // end

    /**************************** AND Logic Test ****************************/

    /**************************** NOR Logic Test ****************************/

    /**************************** OR Logic Test ****************************/

  end
endmodule
