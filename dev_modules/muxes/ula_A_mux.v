module ula_A_mux (
    input  wire [1:0] selector,
    input  wire [31:0] data_0,//offset branch - 00
    input  wire [31:0] data_1,//register A - 01
    input  wire [31:0] data_2,//memory data - 10
                             //4 - 11
    output wire [31:0] data_out,
);
    assign data_out = (selector[1] ? (selector[0] ? 32'b00000000000000000000000000000100 : data_2) : (selector[0] ? data_1 : data_0));
endmodule