module pc_mux (
    input  wire [2:0] selector,
    input  wire [31:0] data_0,//load size - 000
    input  wire [31:0] data_1,//ALU result - 001
    input  wire [31:0] data_2,//ALUOut - 010
    input  wire [31:0] data_3,//Inconditional jump - 011
    input  wire [31:0] data_4,//EPC - 100
    input  wire [31:0] data_5,//register A - 101
    output wire [31:0] data_out,
);
    assign data_out = (selector[2] ? (selector[0] ? data_5 : data_4) : (selector[1] ? (selector[0] ? data_3 : data_2) : (selector[0] ? data_1 : data_0)));
endmodule