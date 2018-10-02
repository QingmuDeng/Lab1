`define NOT not #10
`define NOT3 not #30
`define NAND and #20
`define NOR nor #20
`define NOR32 nor #320
`define AND and #30
`define AND4 and #50 // 4 inputs plus inverter
`define OR or #30
`define OR8 or #90 // 8 inputs plus inverter
`define NXOR and #20
`define XOR nor #30

`define ADD  3'd0
`define SUB  3'd1
`define XOR1  3'd2
`define SLT  3'd3
`define AND1  3'd4
`define NAND1 3'd5
`define NOR1  3'd6
`define OR1   3'd7

`include "adder_1bit.v"
/* `include "adder.v" */

module ALU_slice
(
  output result,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  input a,     // First operand in 2's complement format
  input b,     // Second operand in 2's complement format
  input carryin,     // carryin for subtraction in the future,
  input slt,   // for set less than
  input invertB,
  input invertOut,
  input[2:0] muxindex
);
  wire bOut;
  wire addSubtract, subtract, xorgate, andgate, nandgate, norgate, orgate, norOut, nandOut;

  `XOR invB(bOut, b, invertB);
  structuralFullAdder adder(.sum(addSubtract), .carryout(carryout), .a(a), .b(bOut), .carryin(carryin));
  // structuralFullAdder subtractor(.sum(subtract), .carryout(carryout), .a(a), .b(nb), .carryin(carryin));

  `NOR AnorB(norgate, a, b);
  `XOR AxorB(xorgate, a, b);
  `NAND AnandB(nandgate, a, b);
  `XOR invOutNor(norOut, invertOut, norgate);
  `XOR invOutNand(nandOut, invertOut, nandgate);

  // `AND AandB(andgate, a, b);
  // `OR AorB(orgate, a, b);

  multiplexer mux(result, addSubtract, xorgate, slt, nandOut, norOut, muxindex);
  // multiplexer mux(result, add, subtract, xorgate, slt, andgate, nandgate, norgate, orgate, muxindex);
endmodule

module ALUcontrolLUT
(
  output reg[2:0] 	muxindex,
  output reg	invertB,
  output reg invertOut,
  input[2:0]	ALUcommand
);

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:  begin muxindex = 0; invertB=0; invertOut=0; end
      `SUB:  begin muxindex = 0; invertB=1; invertOut=0; end
      `XOR1:  begin muxindex = 1; invertB=0; invertOut=0; end
      `SLT:  begin muxindex = 2; invertB=1; invertOut=0; end
      `AND1:  begin muxindex = 3; invertB=0; invertOut=1; end
      `NAND1: begin muxindex = 3; invertB=0; invertOut=0; end
      `NOR1:  begin muxindex = 4; invertB=0; invertOut=0; end
      `OR1:   begin muxindex = 4; invertB=0; invertOut=1; end
    endcase
  end
endmodule

module ALU
(
output[31:0]  result,
output        carryout,
output        zero,
output        overflow,
input[31:0]   operandA,
input[31:0]   operandB,
input[2:0]    command
);
	// Your code here
  wire[30:0] Cout;
  wire [2:0] muxindex, ALUcommand;
  wire invertB, invertOut;
  ALUcontrolLUT control(.muxindex(muxindex), .invertB(invertB), .invertOut(invertOut), .ALUcommand(command));

  ALU_slice aluOneBit0(.result(result[0]), .carryout(Cout[0]), .a(operandA[0]), .b(operandB[0]), .carryin(invertB), .slt(result[32]), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit1(.result(result[1]), .carryout(Cout[1]), .a(operandA[1]), .b(operandB[1]), .carryin(Cout[0]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit2(.result(result[2]), .carryout(Cout[2]), .a(operandA[2]), .b(operandB[2]), .carryin(Cout[1]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit3(.result(result[3]), .carryout(Cout[3]), .a(operandA[3]), .b(operandB[3]), .carryin(Cout[2]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit4(.result(result[4]), .carryout(Cout[4]), .a(operandA[4]), .b(operandB[4]), .carryin(Cout[3]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit5(.result(result[5]), .carryout(Cout[5]), .a(operandA[5]), .b(operandB[5]), .carryin(Cout[4]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit6(.result(result[6]), .carryout(Cout[6]), .a(operandA[6]), .b(operandB[6]), .carryin(Cout[5]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit7(.result(result[7]), .carryout(Cout[7]), .a(operandA[7]), .b(operandB[7]), .carryin(Cout[6]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit8(.result(result[8]), .carryout(Cout[8]), .a(operandA[8]), .b(operandB[8]), .carryin(Cout[7]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit9(.result(result[9]), .carryout(Cout[9]), .a(operandA[9]), .b(operandB[9]), .carryin(Cout[8]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit10(.result(result[10]), .carryout(Cout[10]), .a(operandA[10]), .b(operandB[10]), .carryin(Cout[9]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit11(.result(result[11]), .carryout(Cout[11]), .a(operandA[11]), .b(operandB[11]), .carryin(Cout[10]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit12(.result(result[12]), .carryout(Cout[12]), .a(operandA[12]), .b(operandB[12]), .carryin(Cout[11]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit13(.result(result[13]), .carryout(Cout[13]), .a(operandA[13]), .b(operandB[13]), .carryin(Cout[12]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit14(.result(result[14]), .carryout(Cout[14]), .a(operandA[14]), .b(operandB[14]), .carryin(Cout[13]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit15(.result(result[15]), .carryout(Cout[15]), .a(operandA[15]), .b(operandB[15]), .carryin(Cout[14]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit16(.result(result[16]), .carryout(Cout[16]), .a(operandA[16]), .b(operandB[16]), .carryin(Cout[15]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit17(.result(result[17]), .carryout(Cout[17]), .a(operandA[17]), .b(operandB[17]), .carryin(Cout[16]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit18(.result(result[18]), .carryout(Cout[18]), .a(operandA[18]), .b(operandB[18]), .carryin(Cout[17]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit19(.result(result[19]), .carryout(Cout[19]), .a(operandA[19]), .b(operandB[19]), .carryin(Cout[18]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit20(.result(result[20]), .carryout(Cout[20]), .a(operandA[20]), .b(operandB[20]), .carryin(Cout[19]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit21(.result(result[21]), .carryout(Cout[21]), .a(operandA[21]), .b(operandB[21]), .carryin(Cout[20]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit22(.result(result[22]), .carryout(Cout[22]), .a(operandA[22]), .b(operandB[22]), .carryin(Cout[21]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit23(.result(result[23]), .carryout(Cout[23]), .a(operandA[23]), .b(operandB[23]), .carryin(Cout[22]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit24(.result(result[24]), .carryout(Cout[24]), .a(operandA[24]), .b(operandB[24]), .carryin(Cout[23]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit25(.result(result[25]), .carryout(Cout[25]), .a(operandA[25]), .b(operandB[25]), .carryin(Cout[24]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit26(.result(result[26]), .carryout(Cout[26]), .a(operandA[26]), .b(operandB[26]), .carryin(Cout[25]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit27(.result(result[27]), .carryout(Cout[27]), .a(operandA[27]), .b(operandB[27]), .carryin(Cout[26]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit28(.result(result[28]), .carryout(Cout[28]), .a(operandA[28]), .b(operandB[28]), .carryin(Cout[27]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit29(.result(result[29]), .carryout(Cout[29]), .a(operandA[29]), .b(operandB[29]), .carryin(Cout[28]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit30(.result(result[30]), .carryout(Cout[30]), .a(operandA[30]), .b(operandB[30]), .carryin(Cout[29]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
  ALU_slice aluOneBit31(.result(result[31]), .carryout(carryout), .a(operandA[31]), .b(operandB[31]), .carryin(Cout[30]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));

  `XOR ovf(overflow, carryout, Cout[30]);
  `NOR32 zero_out(zero, result);
endmodule


module multiplexer
(
  output out,
  input a0, a1, a2, a3, a4, //a5, a6, a7,
  input[2:0] select
);
  wire ns0, ns1, ns2;
  wire addWire, subtractWire, xorWire, sltWire;
  wire andWire, nandWire, norWire, orWire;

  // `NOT3 selectInv(nselect, select);
  `NOT s0inv(ns0, select[0]);
  `NOT s1inv(ns1, select[1]);
  `NOT s2inv(ns2, select[2]);

  `AND4 andgateAdd(addWire, ns2, ns1, ns0, a0);
  `AND4 andgateXor(xorWire, ns2, ns1, select[0], a1);
  `AND4 andgateSlt(sltWire, ns2, select[1], ns0, a2);
  `AND4 andgateNand(nandWire, ns2, select[1], select[0], a3);
  `AND4 andgateNor(norWire, select[2], ns1, ns0, a4);

  // `AND4 andgateSubtract(subtractWire, ns2, ns1, select[0], a0);
  // `AND4 andgateXor(xorWire, ns2, select[1], ns0, a1);
  // `AND4 andgateSlt(sltWire, ns2, select[1], select[0], a2);
  //
  // // `AND4 andgateAnd(andWire, select[2], ns1, ns0, a4);
  // `AND4 andgateNand(nandWire, select[2], ns1, select[0], a3);
  // `AND4 andgateNor(norWire, select[2], select[1], ns0, a4);
  // `AND4 andgateOR(orWire, select[2], select[1], select[0], a7);
  `OR8 orgateOut(out, addWire, xorWire, sltWire, nandWire, norWire);

  // `OR8 orgateOut(out, addWire, subtractWire, xorWire, sltWire, andWire, nandWire, norWire, orWire);
endmodule
