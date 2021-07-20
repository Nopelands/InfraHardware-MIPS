module hilo_mux (

    input wire  [31:0]  div, // outputs when true
    input wire  [31:0]  mult, // outputs when false
    input wire          control,

    output wire [31:0]  data_out
);
    
    assign data_out = (control) ? div : mult;

endmodule