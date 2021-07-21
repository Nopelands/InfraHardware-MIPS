module mem_mux(
    input  wire [2:0] selector,
                             //253 - 000
    input  wire [31:0] data_0,//pc - 001
    input  wire [31:0] data_1,//register B - 010
                             //254 - 011
    input  wire [31:0] data_2,//ALUOut - 100
                             //255 - 101
    output wire [31:0] data_out,
);
    assign data_out = (selector[2] ? (selector[0] ? 32'b00000000000000000000000011111111 : data_2) : (selector[1] ? (selector[0] ? 32'b00000000000000000000000011111110 : data_1) : (selector[0] ? data_0 : 32'b00000000000000000000000011111101)));
endmodule