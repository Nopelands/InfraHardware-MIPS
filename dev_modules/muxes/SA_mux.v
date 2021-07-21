module SA_mux (
    input  wire [1:0] selector,
    input  wire [15:0] data_0,//shift amount from instruction - 00
    input  wire [31:0] data_1,//from register B - 01
                              //from 16 - 10
    input  wire [31:0] data_2,//from MDR - 11
    output wire [4:0] data_out,
);
    assign data_out = (selector[1] ? (selector[0] ? data_2[4:0] : 5'b10000) : (selector[0] ? data_1[4:0] : data_0[10:6]));
endmodule