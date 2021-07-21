module ula_B_mux(
    input  wire [1:0] selector,
    input  wire [31:0] data_0,//register B - 00
    input  wire [31:0] data_1,//immediate - 01
    input  wire [31:0] data_2,//pc - 10
    input  wire [31:0] data_3,//MDR - 11
    output wire [31:0] data_out,
);
    assign data_out = (selector[1] ? (selector[0] ? data_3 : data_2) : (selector[0] ? data_1 : data_0));
endmodule