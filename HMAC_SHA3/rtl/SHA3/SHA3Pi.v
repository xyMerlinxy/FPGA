// The SHA3Pi module implements the Pi transformation on the state array A.

module SHA3Pi(
    input wire  [1599:0]  inState, // Input data bus for state array A before the Pi operation
    output wire [1599:0]  outState // Output data bus for state array A after the Pi operation
);


assign outState[0895:0832] = inState[1279:1216];
assign outState[0959:0896] = inState[1343:1280];
assign outState[0703:0640] = inState[0127:0064];
assign outState[0767:0704] = inState[0511:0448];
assign outState[0831:0768] = inState[0895:0832];
assign outState[0575:0512] = inState[1087:1024];
assign outState[0639:0576] = inState[1471:1408];
assign outState[0383:0320] = inState[0255:0192];
assign outState[0447:0384] = inState[0639:0576];
assign outState[0511:0448] = inState[0703:0640];
assign outState[0255:0192] = inState[1215:1152];
assign outState[0319:0256] = inState[1599:1536];
assign outState[0063:0000] = inState[0063:0000];
assign outState[0127:0064] = inState[0447:0384];
assign outState[0191:0128] = inState[0831:0768];
assign outState[1535:1472] = inState[1023:0960];
assign outState[1599:1536] = inState[1407:1344];
assign outState[1343:1280] = inState[0191:0128];
assign outState[1407:1344] = inState[0575:0512];
assign outState[1471:1408] = inState[0959:0896];
assign outState[1215:1152] = inState[1151:1088];
assign outState[1279:1216] = inState[1535:1472];
assign outState[1023:0960] = inState[0319:0256];
assign outState[1087:1024] = inState[0383:0320];
assign outState[1151:1088] = inState[0767:0704];

endmodule