// The SHA3Theta module implements the Theta transformation on the state array A.

module SHA3Theta(
    input wire  [1599:0] inState, // Input data bus for state array A before the Theta operation
    output wire [1599:0] outState // Output data bus for state array A after the Theta operation
);

wire [63:0] sheet0, sheet1, sheet2, sheet3, sheet4;

assign sheet0 = inState[063:000] ^ inState[383:320] ^ inState[703:640] ^ inState[1023:0960] ^ inState[1343:1280];
assign sheet1 = inState[127:064] ^ inState[447:384] ^ inState[767:704] ^ inState[1087:1024] ^ inState[1407:1344];
assign sheet2 = inState[191:128] ^ inState[511:448] ^ inState[831:768] ^ inState[1151:1088] ^ inState[1471:1408];
assign sheet3 = inState[255:192] ^ inState[575:512] ^ inState[895:832] ^ inState[1215:1152] ^ inState[1535:1472];
assign sheet4 = inState[319:256] ^ inState[639:576] ^ inState[959:896] ^ inState[1279:1216] ^ inState[1599:1536];

// sheet0
assign outState[0063:0000] = inState[0063:0000] ^ sheet4 ^ {sheet1[62:0],sheet1[63]};
assign outState[0383:0320] = inState[0383:0320] ^ sheet4 ^ {sheet1[62:0],sheet1[63]};
assign outState[0703:0640] = inState[0703:0640] ^ sheet4 ^ {sheet1[62:0],sheet1[63]};
assign outState[1023:0960] = inState[1023:0960] ^ sheet4 ^ {sheet1[62:0],sheet1[63]};
assign outState[1343:1280] = inState[1343:1280] ^ sheet4 ^ {sheet1[62:0],sheet1[63]};
// sheet1
assign outState[0127:0064] = inState[0127:0064] ^ sheet0 ^ {sheet2[62:0],sheet2[63]};
assign outState[0447:0384] = inState[0447:0384] ^ sheet0 ^ {sheet2[62:0],sheet2[63]};
assign outState[0767:0704] = inState[0767:0704] ^ sheet0 ^ {sheet2[62:0],sheet2[63]};
assign outState[1087:1024] = inState[1087:1024] ^ sheet0 ^ {sheet2[62:0],sheet2[63]};
assign outState[1407:1344] = inState[1407:1344] ^ sheet0 ^ {sheet2[62:0],sheet2[63]};
// sheet2
assign outState[0191:0128] = inState[0191:0128] ^ sheet1 ^ {sheet3[62:0],sheet3[63]};
assign outState[0511:0448] = inState[0511:0448] ^ sheet1 ^ {sheet3[62:0],sheet3[63]};
assign outState[0831:0768] = inState[0831:0768] ^ sheet1 ^ {sheet3[62:0],sheet3[63]};
assign outState[1151:1088] = inState[1151:1088] ^ sheet1 ^ {sheet3[62:0],sheet3[63]};
assign outState[1471:1408] = inState[1471:1408] ^ sheet1 ^ {sheet3[62:0],sheet3[63]};
// sheet3
assign outState[0255:0192] = inState[0255:0192] ^ sheet2 ^ {sheet4[62:0],sheet4[63]};
assign outState[0575:0512] = inState[0575:0512] ^ sheet2 ^ {sheet4[62:0],sheet4[63]};
assign outState[0895:0832] = inState[0895:0832] ^ sheet2 ^ {sheet4[62:0],sheet4[63]};
assign outState[1215:1152] = inState[1215:1152] ^ sheet2 ^ {sheet4[62:0],sheet4[63]};
assign outState[1535:1472] = inState[1535:1472] ^ sheet2 ^ {sheet4[62:0],sheet4[63]};
// sheet4
assign outState[0319:0256] = inState[0319:0256] ^ sheet3 ^ {sheet0[62:0],sheet0[63]};
assign outState[0639:0576] = inState[0639:0576] ^ sheet3 ^ {sheet0[62:0],sheet0[63]};
assign outState[0959:0896] = inState[0959:0896] ^ sheet3 ^ {sheet0[62:0],sheet0[63]};
assign outState[1279:1216] = inState[1279:1216] ^ sheet3 ^ {sheet0[62:0],sheet0[63]};
assign outState[1599:1536] = inState[1599:1536] ^ sheet3 ^ {sheet0[62:0],sheet0[63]};

endmodule