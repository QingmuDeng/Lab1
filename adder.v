// Adder circuit
`include "adder_1bit.v"

module FullAdder4bit
(
  output[3:0] sum,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  output overflow,  // True if the calculation resulted in an overflow
  input[3:0] a,     // First operand in 2's complement format
  input[3:0] b      // Second operand in 2's complement format
);
    // Your Code Here
    wire[2:0] Cout;
    structuralFullAdder add0(sum[0], Cout[0], a[0], b[0], 1'b0);
    structuralFullAdder add1(sum[1], Cout[1], a[1], b[1], Cout[0]);
    structuralFullAdder add2(sum[2], Cout[2], a[2], b[2], Cout[1]);
    structuralFullAdder add3(sum[3], carryout, a[3], b[3], Cout[2]);

    `XOR overflow_check(overflow, carryout, Cout[2]);
endmodule
