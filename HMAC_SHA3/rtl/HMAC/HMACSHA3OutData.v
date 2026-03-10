// The HMACSHA3OutData module implements the hash output interface.
// If the outEnable input is set high, the HMACSHA3OutData module drives the data from the inOutData input to the outOutData output.

module HMACSHA3OutData #(
  parameter HASH_SIZE = 512
)(
    input  wire          inEnable,
    input  wire [HASH_SIZE - 1:0]  inOutData,
    output wire [HASH_SIZE - 1:0]  outOutData
);

assign outOutData = (inEnable == 1'b1) ? inOutData : 1'h0;

endmodule