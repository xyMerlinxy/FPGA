//! The SHA3Rc module implements the logic for determining the Round Constant (RC) for a given round.
//! The SHA3Rc module asserts the outRC output signal based on the current round index.

module SHA3Rc(
    input wire  [4:0]   inRoundCnt, // Round number input bus
    output wire [63:0]  outRC       // Round Constant (RC) value output bus
);

assign outRC=
    (inRoundCnt == 5'd00) ? 64'h0000000000000001:
    (inRoundCnt == 5'd01) ? 64'h0000000000008082:
    (inRoundCnt == 5'd02) ? 64'h800000000000808a:
    (inRoundCnt == 5'd03) ? 64'h8000000080008000:
    (inRoundCnt == 5'd04) ? 64'h000000000000808b:
    (inRoundCnt == 5'd05) ? 64'h0000000080000001:
    (inRoundCnt == 5'd06) ? 64'h8000000080008081:
    (inRoundCnt == 5'd07) ? 64'h8000000000008009:
    (inRoundCnt == 5'd08) ? 64'h000000000000008a:
    (inRoundCnt == 5'd09) ? 64'h0000000000000088:
    (inRoundCnt == 5'd10) ? 64'h0000000080008009:
    (inRoundCnt == 5'd11) ? 64'h000000008000000a:
    (inRoundCnt == 5'd12) ? 64'h000000008000808b:
    (inRoundCnt == 5'd13) ? 64'h800000000000008b:
    (inRoundCnt == 5'd14) ? 64'h8000000000008089:
    (inRoundCnt == 5'd15) ? 64'h8000000000008003:
    (inRoundCnt == 5'd16) ? 64'h8000000000008002:
    (inRoundCnt == 5'd17) ? 64'h8000000000000080:
    (inRoundCnt == 5'd18) ? 64'h000000000000800a:
    (inRoundCnt == 5'd19) ? 64'h800000008000000a:
    (inRoundCnt == 5'd20) ? 64'h8000000080008081:
    (inRoundCnt == 5'd21) ? 64'h8000000000008080:
    (inRoundCnt == 5'd22) ? 64'h0000000080000001:
                            64'h8000000080008008;

endmodule