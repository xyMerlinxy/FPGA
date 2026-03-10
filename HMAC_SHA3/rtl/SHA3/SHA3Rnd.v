// The SHA3Rnd module implements a single round function on the state array.

module SHA3Rnd(
    input wire  [1599:0]  inState,    // Input data bus for state array A before the Rnd operation
    input wire  [4:0]     inRoundCnt, // Round number input bus
    output wire [1599:0]  outState    // Output data bus for state array A after the Rnd operation
);

wire   [1599:0]  temp1;
wire   [1599:0]  temp2;
wire   [1599:0]  temp3;
wire   [1599:0]  temp4;

SHA3Theta instSha3Theta(
    .inState(inState),
    .outState(temp1)
);
SHA3Rho instSha3Rho(
    .inState(temp1),
    .outState(temp2)
);

SHA3Pi instSha3Pi(
    .inState(temp2),
    .outState(temp3)
);

SHA3Chi instSha3Chi(
    .inState(temp3),
    .outState(temp4)
);

SHA3Iota instSha3Iota(
    .inState(temp4),
    .inRoundCnt(inRoundCnt),
    .outState(outState)
);


endmodule