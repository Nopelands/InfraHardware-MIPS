module IN_mux (
    input  wire [1:0] selector,
    input  wire [31:0] data_0,//register B - 00
    input  wire [31:0] data_1,//register A - 01
    input  wire [31:0] data_2,//Sign Extend - 10
    output wire [31:0] data_out,
);
    assign data_out = (selector[1] ? data_2 : (selector[0] ? data_1 : data_0));
endmodule