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

    // Register control wires

    // Other control wires
    wire [2:0] ula_control;

// Data wires
wire [31:0] ula_operand_A;
wire [31:0] ula_operand_B;
wire [31:0] ula_output;

// Flag wires
wire ula_overflow;
wire ula_negative;
wire ula_zero;
wire ula_equals;
wire ula_greaterthan;
wire ula_lessthan;

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
        wr_mux_control,
    );

    //Registers
    Registrador PC (
        clk,
        reset,
    );

    Registrador Memory_Data (
        clk,
        reset,
    );

    Registrador A (
        clk,
        reset,
    );

    Registrador B (
        clk,
        reset,
    );

    Registrador HI (
        clk,
        reset,
    );

    Registrador LO (
        clk,
        reset,
    );

    Registrador ALUOut (
        clk,
        reset,
    );

    Registrador EPC (
        clk,
        reset,
    );

    //Provided modules
    Banco_reg Registers (
        clk,
        reset,
    );

    Instr_Reg Instruction_Register (
        clk,
        reset,
    );

    Memoria Memory (

    );

    RegDesloc Shift_register (
        clk,
        reset,
    );

    ula32 ULA (
        ula_operand_A,
        ula_operand_B,
        ula_control,
        ula_output,
        ula_overflow,
        ula_negative,
        ula_zero,
        ula_equals,
        ula_greaterthan,
        ula_lessthan
    );
    //Miscellaneous modules

    //Control unit
    control_unit Control_Unit (
        clk,
        reset,
    );

endmodule