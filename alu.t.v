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

  task add_test;
    begin
      if(res != a+b) $display("Adder fault with a=%d and b=%d. The proper result is %d, but the received is %d.", a, b, a+b, res);
    end
  endtask

  task subtractor_test;
    begin
      if(res != a-b)  $display("subtractor fault with a=%d and b=%d. The proper result is %d, but the received is %d.", a, b, a-b, res);
    end
  endtask

  task stl_test;
    begin
      if(res != (a<b)) $display("SLT fault with a=%d and b=%d. The proper result is %d, but the received is %d.", a, b, a<b, res);
    end
  endtask

  task xor_test;
    begin
      if(res != (a^b)) $display("XOR Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, a^b, res);
    end
  endtask

  task nand_test;
    begin
      if(res != ~(a&b)) $display("NAND Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, ~(a&b), res);
    end
  endtask

  task and_test;
    begin
      if(res != (a&b)) $display("AND Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, (a&b), res);
    end
  endtask

  task nor_test;
    begin
      if(res != ~(a|b)) $display("NOR Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, ~(a|b), res);
    end
  endtask

  task or_test;
    begin
      if(res != (a|b)) $display("OR Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, (a|b), res);
    end
  endtask

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, dut);
    a = 32'sd0; b = 32'sd0; cmd = `ADD; #100
    // $display("          A              B    Cmd |          Res Cout  Ovf  Zero | Expected");

    /****************************   Adder Test   ****************************/
    a = 32'sd2; b = 32'sd1; cmd = `ADD; #1000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   3...", a, b, cmd, res, cout, ovf, zero);
    

    a = 32'sd2312; b = 32'sd123; cmd = `ADD; #1000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2435...", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd543290; b = 32'sd34124123; cmd = `ADD; #1000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   34667413...", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd4; b = -32'sd2; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);

    a = -32'sd5; b = -32'sd7; cmd = `ADD; #1000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -12...", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd1; b = 32'sd1; cmd = `ADD; #1000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);

    /**************************** Subtractor Test ****************************/
    a = 32'sd4; b = 32'sd2; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);


    a = 32'sd100; b = 32'sd100; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);

    /**************************** Set Less Than Test ****************************/
    a = 32'sd4; b = 32'sd2; cmd = `SLT; #1000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd2; b = 32'sd4; cmd = `SLT; #10000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    
    /**************************** XOR Logic Test ****************************/
    a = 32'sd4; b = 32'sd2; cmd = `XOR; #1000 xor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);

    /**************************** NAND Logic Test ****************************/
    a = 32'sb1101111; b = 32'sb1111100; cmd = `NAND; #1000 nand_test();
    

    /**************************** AND Logic Test ****************************/
    a = 32'sb1101111; b = 32'sb1111100; cmd = `AND; #1000 and_test();
    

    /**************************** NOR Logic Test ****************************/
    a = 32'sb1101111; b = 32'sb1111100; cmd = `NOR; #1000 nor_test();

    /**************************** OR Logic Test ****************************/
    a = 32'sb1101111; b = 32'sb1111100; cmd = `OR; #1000 or_test();


  end
endmodule
