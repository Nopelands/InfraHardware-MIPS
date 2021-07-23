module cpu_MIPS (
    input wire clk,
    input wire reset
);

// Control wires

    // Mux control wires
    wire HI_mux_control;
    wire LO_mux_control;
    wire [1:0] in_mux_control;
    wire [2:0] mem_mux_control;
    wire [2:0] pc_mux_control;
    wire [1:0] sa_mux_control;
    wire [1:0] ula_a_mux_control;
    wire [1:0] ula_b_mux_control;
    wire [2:0] wd_mux_control;
    wire [1:0] wr_mux_control;

    // Register control wires
    wire PC_control;
    wire MDR_control;
    wire A_control;
    wire B_control;
    wire HI_control;
    wire LO_control;
    wire ALUout_control;
    wire EPC_control;

    // Other control wires
    wire [2:0] ula_control;
    wire Register_bank_control;
    wire Instruct_Reg_control;
    wire MEM_control;
    wire [2:0] Shift_register_control;

// Data wires
wire [31:0] ula_operand_A;
wire [31:0] ula_operand_B;
wire [31:0] ula_output;

wire [31:0] PC_in;
wire [31:0] PC_out;

wire [31:0] Memory_data_out; // Memory output
wire [31:0] MDR_out;

wire [31:0] RegisterBank_out_A;
wire [31:0] RegisterBank_out_B;
wire [31:0] A_Register_out;
wire [31:0] B_Register_out;

wire [31:0] HI_mux_out;
wire [31:0] LO_mux_out;
wire [31:0] HI_Register_out;
wire [31:0] LO_Register_out;

wire [31:0] ALUout_output;

wire [31:0] EPC_out;

wire [5:0] OPcode;
wire [4:0] RS;
wire [4:0] RT;
wire [15:0] Instruction_end;

wire [31:0] MEM_mux_out;
wire [31:0] Store_size_out;
wire [31:0] Load_Size_out;

wire [4:0] SA_mux_out;
wire [31:0] IN_mux_out;
wire [31:0] Shift_register_out;

wire [4:0] WR_mux_out;
wire [31:0] WD_mux_out;

wire [31:0] Signal_extender_out;

wire [31:0] Mult_msb_out;
wire [31:0] Mult_lsb_out;

wire [31:0] Div_remainder_out;
wire [31:0] Div_quotient_out;

// Flag wires
wire ula_overflow;
wire ula_negative;
wire ula_zero;
wire ula_equals;
wire ula_greaterthan;
wire ula_lessthan;
wire division_by_zero;

// Instantiating modules

    //Muxes
    hilo_mux HI_MUX (
        HI_mux_control,
        Div_remainder_out,
        Mult_msb_out,
        HI_mux_out
    );

    hilo_mux LO_MUX (
        LO_mux_control,
        Div_quotient_out,
        Mult_lsb_out,
        LO_mux_out
    );

    IN_mux IN_MUX (
        in_mux_control,
        B_Register_out,
        A_Register_out,
        Signal_extender_out,
        IN_mux_out
    );

    mem_mux MEM_MUX (
        mem_mux_control,
        PC_out,
        B_Register_out,
        ALUout_output
        MEM_mux_out
    );

    pc_mux PC_MUX (
        pc_mux_control,
        Load_Size_out,
        ula_output,
        ALUout_output,
        Shift_left_2to28_out, // TODO fix inconditional jump // wire does not exist
        EPC_out,
        A_Register_out,
        PC_in
    );

    SA_mux SA_MUX (
        sa_mux_control,
        Instruction_end, // ???
        B_Register_out,
        MDR_out
    );

    ula_A_mux ULA_A_MUX (
        ula_a_mux_control,
        shift_left_2_out, // TODO fix offset branch // wire does not exist
        A_Register_out,
        Memory_data_out,
        ula_operand_A
    );

    ula_B_mux ULA_B_MUX (
        ula_b_mux_control,
        B_Register_out,
        Signal_extender_out,
        PC_out,
        MDR_out,
        ula_operand_B
    );

    wd_mux WD_MUX (
        wd_mux_control,
        PC_out,
        ext_to_32_out, // TODO fix less than flag // wire does not exist
        LO_Register_out,
        HI_Register_out,
        Shift_register_out,
        ALUout_output,
        Load_Size_out,
        WD_mux_out
    );

    wr_mux WR_MUX (
        wr_mux_control,
        RT,
        Instruction_end, // ???
        WR_mux_out
    );

    //Registers
    Registrador PC (
        clk,
        reset,
        PC_control,
        PC_in,
        PC_out
    );

    Registrador Memory_Data (
        clk,
        reset,
        MDR_control,
        Memory_data_out, // Gets output from memory
        MDR_out
    );

    Registrador A (
        clk,
        reset,
        A_control,
        RegisterBank_out_A, // Gets output 1 from register bank
        A_Register_out
    );

    Registrador B (
        clk,
        reset,
        B_control,
        RegisterBank_out_B, // Gets output 2 from register bank
        B_Register_out
    );

    Registrador HI (
        clk,
        reset,
        HI_control,
        HI_mux_out,
        HI_Register_out
    );

    Registrador LO (
        clk,
        reset,
        LO_control,
        LO_mux_out,
        LO_Register_out
    );

    Registrador ALUOut (
        clk,
        reset,
        ALUout_control,
        ula_output, // Gets operation result from ALU
        ALUout_output
    );

    Registrador EPC (
        clk,
        reset,
        EPC_control,
        ALUout_output,
        EPC_out
    );

    //Provided modules
    Banco_reg Registers (
        clk,
        reset,
        Register_bank_control,
        RS,
        RT,
        WR_mux_out,
        WD_mux_out,
        RegisterBank_out_A,
        RegisterBank_out_B
    );

    Instr_Reg Instruction_Register (
        clk,
        reset,
        Instruct_Reg_control,
        Memory_data_out,
        OPcode,
        RS,
        RT,
        Instruction_end
    );

    Memoria Memory (
        MEM_mux_out,
        clk,
        MEM_control,
        Store_size_out,
        Memory_data_out
    );

    RegDesloc Shift_register (
        clk,
        reset,
        Shift_register_control,
        SA_mux_out,
        IN_mux_out,
        Shift_register_out
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
    div Div (
        clk,
        reset,
    );

    mult Mult (
        clk,
        reset,
    );

    extend_32 Xtnd32 (

    );

    load_size Load_size (

    );

    store_size Store_size (

    );

    shiftleft_2 Shiftleft2 (

    );

    shiftleft_2to28 Shifteleft_2to28 (

    );

    sign_extend Sign_xtnd (

    );

    //Control unit
    control_unit Control_Unit (
        clk,
        reset,
    );

endmodule