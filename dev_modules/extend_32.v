module extend_32(
    input  wire in,
    output wire [31:0] data_out,
);
    assign data_out = {{{31{1'b0}},in};
endmodule
