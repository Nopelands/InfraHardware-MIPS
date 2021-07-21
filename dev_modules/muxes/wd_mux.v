module wd_mux (
    input  wire [2:0] selector,
    input  wire [31:0] data_0,//pc - 000
    input  wire [31:0] data_1,//less than (flag) - 001
                              // 227 - 010
    input  wire [31:0] data_2,//register lo - 011
    input  wire [31:0] data_3,//register hi - 100
    input  wire [31:0] data_4,//shift register - 101
    input  wire [31:0] data_5,//ALUOut - 110
    input  wire [31:0] data_6,//load size - 111
    output wire [31:0] data_out,
);
    assign data_out = (selector[2] ? (selector[1] ? (selector[0] ? data_6 : data_5) : (selector[0] ? data_4 : data_3)) : (selector[1] ? (selector[0] ? data_2 : 32'b11100011000000000000000000000000) : (selector[0] ? data_1 : data_0)));
endmodule