module shiftleft_2 (
    input  wire [31:0] in,
    output wire [31:0] data_out,
);
    assign data_out = in << 2;
endmodule
