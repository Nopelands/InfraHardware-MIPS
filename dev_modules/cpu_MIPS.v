module cpu_MIPS (
    input wire clk,
    input wire reset
);

// Control wires
    wire [2:0] PC_MUX;
    wire [2:0] MEM_MUX;
    wire [1:0] WR_MUX;
    wire [2:0] WD_MUX;
    wire [1:0] SA_MUX;
    wire [1:0] IN_MUX;
    wire [1:0] ULA_A_MUX;
    wire [1:0] ULA_B_MUX;
    wire [2:0] Shift;
    wire [2:0] ALUOp;
    wire PC_load;
    wire MDR_load;
    wire regA_load;
    wire regB_load;
    wire EPC_load;
    wire ALUOut_load;
    wire Mem_write;
    wire IR_write;
    wire REGS_write;
// Data wires
    //Data from instruction
    wire [5:0] OPCODE;
    wire [4:0] RT;
    wire [4:0] RS;
    wire [15:0] OFFSET;
//*************************************************************************************************************
    wire [31:0] PC_out;
    wire [31:0] ALUResult;
    wire [31:0] ALUOut;
    wire [31:0] Incond_j = {PC_out[31:28], RS,RT, OFFSET, 2'b00};
    wire [31:0] EPC_out;
    wire [31:0] REG1DATA_out;
    wire [31:0] REG2DATA_out;
    wire [31:0] regA_out;
    wire [31:0] regB_out;
    wire [31:0] MDR_out;
    wire [31:0] SR_out;
    wire [31:0] SE_out;
    wire [31:0] SFL2_out;
    wire [31:0] PC_MUX_out;
    wire [31:0] MEM_MUX_out;
    wire [4:0] WR_MUX_out;
    wire [31:0] WD_MUX_out;
    wire [4:0] SA_MUX_out;
    wire [31:0] ULA_A_MUX_out;
    wire [31:0] ULA_B_MUX_out;
// Flag wires
    wire O;
    wire N;
    wire ZR;
    wire EQ;
    wire GT;
    wire LT;
// Instantiating modules
    //Muxes
    pc_mux PC_MUX_(
        PC_MUX,
        ALUResult,//SUBSTITUIR DEPOIS POR LOAD SIZE
        ALUResult,
        ALUOut,
        Incond_j,
        EPC_out,
        regA_out,
        PC_MUX_out
    );
    mem_mux MEM_MUX_(
        MEM_MUX,
        PC_out,
        regB_out,
        ALUOut,
        MEM_MUX_out
    );
    wr_mux WR_MUX_(
        WR_MUX,
        RT,
        OFFSET,
        WR_MUX_out
    );
    wd_mux WD_MUX_(
        WD_MUX,
        PC_out,
        extend_1_32_out,
        LO_out,
        HI_out,
        SR_out,
        ALUOut,
        ALUout,//Substituir depois pelo LOAD SIZE
        WD_MUX_out
    );
    SA_mux SA_MUX_(
        SA_MUX,
        OFFSET,
        regB_out,
        MDR_out,
        SA_MUX_out,
    );
    IN_mux IN_MUX_(
        IN_MUX,
        regB_out,
        regA_out,
        SE_out,
        IN_MUX_out
    );
    ula_A_mux ULA_A_MUX_(
        ULA_A_MUX,
        SLF2_out,
        regA_out,
        Mem_out,
        ULA_A_MUX_out
    );
    ula_B_mux ULA_B_MUX_(
        ULA_B_MUX,
        regB_out,
        SE_out,
        PC_out,
        MDR_out,
        ULA_B_MUX_out
    );
    //Registers
    Registrador PC_(
        clk,
        reset,
        PC_load,
        PC_MUX_out,
        PC_out
    );
    Memoria MEM_(
        MEM_MUX_out,
        clk,
        Mem_Write,
        Mem_in,
        Mem_out
    );
    Registrador MDR_(
        clk,
        reset,
        MDR_load,
        Mem_out,
        MDR_out,
    );
    Instr_Reg IR_(
        clk,
        reset,
        IR_write,
        Mem_out,
        OPCODE,
        RS,
        RT,
        OFFSET
    );
    Banco_reg REGS_(
        clk,
        reset,
        REGS_write,
        RS,
        RT,
        WR_MUX_out,
        WD_MUX_out,
        REG1DATA_out,
        REG2DATA_out
    );
    shiftleft_2 SFL2_(
        SE_out,
        SFL2_out
    );
    Registrador regA_(
        clk,
        reset,
        regA_load,
        REG1DATA_out,
        regA_out
    );
    Registrador regA_(
        clk,
        reset,
        regB_load,
        REG2DATA_out,
        regB_out
    );
    ula32 ALU_(
        ALU_A_MUX_out,
        ALU_B_MUX_out,
        ALUOp,
        ALUResult,
        O,
        N,
        ZR,
        EQ,
        GT,
        LT
    );
    Registrador ALUOut_(
        clk,
        reset,
        ALUOut_load,
        ALUResult,
        ALUOut
    );
    Registrador EPC_(
        clk,
        reset,
        EPC_load,
        ALUOut,
        EPC_out
    );
    extend_32 extend_1_32_(
        LT,
        extend_1_32_out
    );
    RegDesloc SR_(
        clk,
        reset,
        Shift,
        SA_MUX_out,
        IN_MUX_out,
        SR_out
    );
    sign_extend SE_(
        OFFSET,
        SE_out
    );
    control_unit CONTROL_UNIT_(
        clk,
        reset,
        O,
        N,
        ZR,
        EQ,
        GT,
        LT,
        OPCODE,
        OFFSET[5:0],
        PC_load,
        MDR_load,
        regA_load,
        regB_load,
        EPC_load,
        ALUOut_load,
        Mem_write,
        IR_write,
        REGS_write,
        ALUOp,
        Shift,
        PC_MUX,
        MEM_MUX,
        WR_MUX,
        WD_MUX,
        SA_MUX,
        IN_MUX,
        ULA_A_MUX,
        ULA_B_MUX,
    );
    //Provided modules

    //Miscellaneous modules

    //Control unit

endmodule
