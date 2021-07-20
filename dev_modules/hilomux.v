module hilomux (

    input wire  [31:0]  div, // outputs when true
    input wire  [31:0]  mut, // outputs when false
    input wire          control,

    output wire [31:0]  data_out
);
    
    assign data_out = (control) ? div : mut;

endmodule