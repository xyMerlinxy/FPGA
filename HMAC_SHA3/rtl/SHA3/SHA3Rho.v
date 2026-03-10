// The SHA3Rho module implements the Rho transformation on the state array A.
// This module performs cyclic shifts (rotations) on each lane of the state array.

module SHA3Rho(
    input wire  [1599:0]  inState, // Input data bus for state array A before the Rho operation
    output wire [1599:0]  outState // Output data bus for state array A after the Rho operation
);

assign outState[0895:0832] = {inState[0870:0832], inState[0895:0871]};
assign outState[0959:0896] = {inState[0920:0896], inState[0959:0921]};
assign outState[0703:0640] = {inState[0700:0640], inState[0703:0701]};
assign outState[0767:0704] = {inState[0757:0704], inState[0767:0758]};
assign outState[0831:0768] = {inState[0788:0768], inState[0831:0789]};
assign outState[0575:0512] = {inState[0520:0512], inState[0575:0521]};
assign outState[0639:0576] = {inState[0619:0576], inState[0639:0620]};
assign outState[0383:0320] = {inState[0347:0320], inState[0383:0348]};
assign outState[0447:0384] = {inState[0403:0384], inState[0447:0404]};
assign outState[0511:0448] = {inState[0505:0448], inState[0511:0506]};
assign outState[0255:0192] = {inState[0227:0192], inState[0255:0228]};
assign outState[0319:0256] = {inState[0292:0256], inState[0319:0293]};
assign outState[0063:0000] = inState[0063:0000];
assign outState[0127:0064] = {inState[0126:0064], inState[0127:0127]};
assign outState[0191:0128] = {inState[0129:0128], inState[0191:0130]};
assign outState[1535:1472] = {inState[1479:1472], inState[1535:1480]};
assign outState[1599:1536] = {inState[1585:1536], inState[1599:1586]};
assign outState[1343:1280] = {inState[1325:1280], inState[1343:1326]};
assign outState[1407:1344] = {inState[1405:1344], inState[1407:1406]};
assign outState[1471:1408] = {inState[1410:1408], inState[1471:1411]};
assign outState[1215:1152] = {inState[1194:1152], inState[1215:1195]};
assign outState[1279:1216] = {inState[1271:1216], inState[1279:1272]};
assign outState[1023:0960] = {inState[0982:0960], inState[1023:0983]};
assign outState[1087:1024] = {inState[1042:1024], inState[1087:1043]};
assign outState[1151:1088] = {inState[1136:1088], inState[1151:1137]};

endmodule