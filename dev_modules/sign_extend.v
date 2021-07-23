module sign_extend (
    input  wire [15:0] data_in,
    output wire [31:0] data_out,
);
    assign data_out = (data_in[15] ? {{{16{1'b1}},data_in} : {{{16{1'b0}},data_in});
endmodule
