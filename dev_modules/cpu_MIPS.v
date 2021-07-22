module cpu_MIPS (
    input wire clk,
    input wire reset
);

// Control wires

    // Mux control wires
    wire mult_mux_control;
    wire div_mux_control;
    wire [1:0] in_mux_control;
    wire [2:0] mem_mux_control;
    wire [2:0] pc_mux_control;
    wire [1:0] sa_mux_control;
    wire [1:0] ula_a_mux_control;
    wire [1:0] ula_b_mux_control;
    wire [2:0] wd_mux_control;
    wire [1:0] wr_mux_control;
    // Other control wires

// Data wires

// Flag wires

// Instantiating modules

    //Muxes
    hilo_mux MULT_MUX (
        mult_mux_control,
    );

    hilo_mux DIV_MUX (
        div_mux_control,
    );

    IN_mux IN_MUX (
        in_mux_control,
    );

    mem_mux MEM_MUX (
        mem_mux_control,
    );

    pc_mux PC_MUX (
        pc_mux_control,
    );

    SA_mux SA_MUX (
        sa_mux_control,
    );

    ula_A_mux ULA_A_MUX (
        ula_a_mux_control,
    );

    ula_B_mux ULA_B_MUX (
        ula_b_mux_control,
    );

    wd_mux WD_MUX (
        wd_mux_control,
    );

    wr_mux WR_MUX (
        wr_mux_control
    );

    //Registers

    //Provided modules

    //Miscellaneous modules

    //Control unit

endmodule