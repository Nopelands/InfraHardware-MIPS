module wr_mux(
    input  wire [1:0] selector,
    input  wire [4:0] data_0,//rt
    input  wire [15:0] data_1,//rd
    output wire [4:0] data_out,
);
    assign data_out = (selector[1] ? (selector[0] ? data_1[15:11] : data_0) : (selector[0] ? 5'b11101 : 5'b11111));
endmodule