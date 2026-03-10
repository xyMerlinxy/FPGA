// S-Box module returning the round constant value
// This module is implemented as combinatorial logic

module NoekeonConstantBox(
  input wire  [4:0]    inRoundCnt,
  output wire  [7:0]    outRoundConst

);

assign outRoundConst =
  (inRoundCnt == 5'd00) ? 8'h80:
  (inRoundCnt == 5'd01) ? 8'h1B:
  (inRoundCnt == 5'd02) ? 8'h36:
  (inRoundCnt == 5'd03) ? 8'h6C:
  (inRoundCnt == 5'd04) ? 8'hD8:
  (inRoundCnt == 5'd05) ? 8'hAB:
  (inRoundCnt == 5'd06) ? 8'h4D:
  (inRoundCnt == 5'd07) ? 8'h9A:
  (inRoundCnt == 5'd08) ? 8'h2F:
  (inRoundCnt == 5'd09) ? 8'h5E:
  (inRoundCnt == 5'd10) ? 8'hBC:
  (inRoundCnt == 5'd11) ? 8'h63:
  (inRoundCnt == 5'd12) ? 8'hC6:
  (inRoundCnt == 5'd13) ? 8'h97:
  (inRoundCnt == 5'd14) ? 8'h35:
  (inRoundCnt == 5'd15) ? 8'h6A:
  8'hD4;

endmodule
