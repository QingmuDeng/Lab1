`define NOT not #50
`define AND and #50
`define OR or #50
`define NAND nand #50
`define NOR nor #50
`define XOR xor #50

module structuralFullAdder
(
    output sum, 
    output carryout,
    input a, 
    input b, 
    input carryin
);
    // Your adder code here
    wire G, P, PandCin;

    `AND generator(G, a, b);
    `XOR propagate(P, a,b);

    `AND carry(PandCin, P, carryin);
    `OR Cout(carryout, PandCin, G);
    `XOR summation(sum, P, carryin);
endmodule