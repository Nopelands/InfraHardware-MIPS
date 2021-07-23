module control_unit (
    input wire clk,
    input wire reset,

    //Instruction
    input wire [5:0] OPcode,
    input wire [15:0] funct, // rd + shamt + funct

    //Flags
    input wire ula_overflow,
    input wire ula_negative,
    input wire ula_zero,
    input wire ula_equals,
    input wire ula_greaterthan,
    input wire ula_lessthan,
    input wire division_by_zero,

    //Mux controllers
    output wire HI_mux_control,
    output wire LO_mux_control,
    output wire [1:0] in_mux_control,
    output wire [2:0] mem_mux_control,
    output wire [2:0] pc_mux_control,
    output wire [1:0] sa_mux_control,
    output wire [1:0] ula_a_mux_control,
    output wire [1:0] ula_b_mux_control,
    output wire [2:0] wd_mux_control,
    output wire [1:0] wr_mux_control,

    //Register controllers
    output wire PC_control,
    output wire MDR_control,
    output wire A_control,
    output wire B_control,
    output wire HI_control,
    output wire LO_control,
    output wire ALUout_control,
    output wire EPC_control,
    
    //Functional controllers
    output wire [2:0] ula_control,
    output wire Register_bank_control,
    output wire Instruct_Reg_control,
    output wire MEM_control,
    output wire [2:0] Shift_register_control,
);
    
    //State and cycle variables

    //Parameters
        //States
        //Opcodes
        //Other parameters

    //Startup handler

    //Transition function

    //State output handler
endmodule