module control_unit (
    input wire clk,
    input wire reset,
    //Flags
    input  wire of,
    input  wire ng,
    input  wire zr,
    input  wire eq,
    input  wire gt,
    input  wire lt,
    //Instruction
    input  wire [5:0] opcode,
    input  wire [5:0] funct,
    //Functional controllers
    output reg pc_load,
    output reg mdr_load,
    output reg rega_load,
    output reg regb_load,
    output reg epc_load,
    output reg aluout_load,
    output reg mem_write,
    output reg ir_write,
    output reg regs_write,
    output reg [2:0] aluop,
    output reg [2:0] shift,
    //Mux controllers
    output reg [2:0] pc_mux,
    output reg [2:0] mem_mux,
    output reg [1:0] wr_mux,
    output reg [2:0] wd_mux,
    output reg [1:0] sa_mux,
    output reg [1:0] in_mux,
    output reg [1:0] alu_a_mux,
    output reg [1:0] alu_b_mux,
);
    reg [3:0] STATE;
    reg [3:0] COUNTER;

        parameter FETCH = 4'b0000;
        parameter LIR = 4'b0001;
        parameter CBRANCH = 4'b0010;
        parameter DECODE = 4'b0011;
        parameter EXECADD = 4'b0100;
        parameter EXCEPTION = 4'b0101;
        parameter ALUOUTTOREG = 4'b0110;
        parameter RESET = 4'b0111;
        parameter OVERFLOW = 4'b1000;

        parameter RINST = 5'b00000;
        parameter ADD = 6'b010000;
    initial begin
        pc_load = 1'b0;
        mdr_load = 1'b0;
        rega_load = 1'b0;
        regb_load = 1'b0;
        epc_load = 1'b0;
        aluout_load = 1'b0;
        mem_write = 1'b0;
        ir_write = 1'b0;
        regs_write = 1'b0;
        aluop = 3'b000; //hold a
        shift = 3'b000;
        COUNTER = 3'b000;
        STATE = FETCH;
    end
    always @(posedge clk) begin
        if(reset == 1) begin
            STATE = RESET;
            COUNTER = 3'b000;
            wd_mux = 3'b010;///
            wr_mux = 2'b01;///
            regs_write = 1'b1;///
            pc_load = 1'b0;
            mdr_load = 1'b0;
            rega_load = 1'b0;
            regb_load = 1'b0;
            epc_load = 1'b0;
            aluout_load = 1'b0;
            mem_write = 1'b0;
            ir_write = 1'b0;
            aluop = 3'b000; //hold a
            shift = 3'b000;
        end
        else begin
            case (STATE)
                RESET: begin
                    STATE = FETCH;
                    COUNTER = 3'b000;
                    wd_mux = 3'b010;///
                    wr_mux = 2'b01;///
                    regs_write = 1'b1;///
                    pc_load = 1'b0;
                    mdr_load = 1'b0;
                    rega_load = 1'b0;
                    regb_load = 1'b0;
                    epc_load = 1'b0;
                    aluout_load = 1'b0;
                    mem_write = 1'b0;
                    ir_write = 1'b0;
                    aluop = 3'b000; //hold a
                    shift = 3'b000;
                end
                FETCH: begin
                    if(COUNTER == 3'b000 || COUNTER == 3'b001 || COUNTER == 3'b010) begin
                        STATE = FETCH;
                        alu_a_mux = 2'b11; ///
                        alu_b_mux = 2'b10; ///
                        aluop = 3'b001; ///
                        pc_load = 1'b0;
                        mdr_load = 1'b0;
                        rega_load = 1'b0;
                        regb_load = 1'b0;
                        epc_load = 1'b0;
                        aluout_load = 1'b0;
                        mem_write = 1'b1;
                        ir_write = 1'b0;
                        regs_write = 1'b0;
                        shift = 3'b000;
                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 3'b011) begin
                        STATE = LIR;
                        mem_write = 1'b0;///
                        ir_write = 1'b1;///
                        pc_mux = 3'b001; ///
                        pc_load = 1'b1; ///
                        aluop = 3'b000; ///
                        mdr_load = 1'b0;
                        rega_load = 1'b0;
                        regb_load = 1'b0;
                        alu_a_mux = 2'b11;
                        alu_b_mux = 2'b10;
                        epc_load = 1'b0;
                        aluout_load = 1'b0;
                        regs_write = 1'b0;
                        shift = 3'b000;
                        COUNTER = 3'b000;
                    end
                end
                LIR: begin
                    STATE = CBRANCH;
                    ir_write = 1'b1; /// Garantindo a leitura
                    alu_a_mux = 2'b00; ///
                    alu_b_mux = 2'b10; ///
                    aluop = 3'b001; ///
                    aluout_load = 1'b1; ///
                    regs_write = 1'b0;
                    pc_mux = 3'b000;
                    pc_load = 1'b0;
                    mdr_load = 1'b0;
                    rega_load = 1'b0; ///
                    regb_load = 1'b0; ///
                    epc_load = 1'b0;
                    mem_write = 1'b0;
                    shift = 3'b000;
                    COUNTER = 3'b000;
                end
                CBRANCH: begin
                    STATE:DECODE;
                    ir_write = 1'b0;///
                    regs_write = 1'b0;///
                    alu_a_mux = 2'b00; ///
                    alu_b_mux = 2'b10; ///
                    aluop = 3'b001; ///
                    aluout_load = 1'b1;
                    pc_mux = 3'b000; ///
                    pc_load = 1'b0; ///
                    mdr_load = 1'b0;
                    rega_load = 1'b0; ///
                    regb_load = 1'b0; ///
                    epc_load = 1'b0;
                    mem_write = 1'b0;
                    shift = 3'b000;
                    COUNTER = 3'b000;
                end
                DECODE: begin
                    case(opcode)
                        RINST: begin
                            if(opcode == ADD) begin
                                STATE = EXECADD;
                                regs_write = 1'b0;///
                                ir_write = 1'b0;
                                rega_load = 1'b1; ///
                                regb_load = 1'b1; ///
                                alu_a_mux = 2'b00; ///
                                alu_b_mux = 2'b10; ///
                                aluop = 3'b000; ///
                                aluout_load = 1'b0;
                                pc_mux = 3'b000; ///
                                pc_load = 1'b0; ///
                                mdr_load = 1'b0;
                                epc_load = 1'b0;
                                mem_write = 1'b0;
                                shift = 3'b000;
                                COUNTER = 3'b000;
                            end
                        end
                    endcase
                end
                EXECADD: begin //**Execute add**
                    regs_write = 1'b0;///
                    alu_a_mux = 2'b01; ///
                    alu_b_mux = 2'b00; ///
                    aluop = 3'b001; ///
                    aluout_load = 1'b1;
                    ir_write = 1'b0;
                    pc_mux = 3'b000; ///
                    pc_load = 1'b0; ///
                    mdr_load = 1'b0;
                    rega_load = 1'b0; ///
                    regb_load = 1'b0; ///
                    epc_load = 1'b0;
                    mem_write = 1'b0;
                    shift = 3'b000;
                    COUNTER = 3'b000;
                    if(of) begin
                        STATE = EXCEPTION;
                    end
                    else begin
                        STATE = ALUOUTTOREG;
                    end
                end
                EXCEPTION: begin
                    if(COUNTER == 3'b000) begin //** PC-4 operation and save in aluout **
                        STATE = EXCEPTION;
                        regs_write = 1'b0;///
                        alu_a_mux = 2'b11; ///
                        alu_b_mux = 2'b10; ///
                        aluop = 3'b010; ///
                        aluout_load = 1'b1;
                        ir_write = 1'b0;
                        pc_mux = 3'b000; ///
                        pc_load = 1'b0; ///
                        mdr_load = 1'b0;
                        rega_load = 1'b0; ///
                        regb_load = 1'b0; ///
                        epc_load = 1'b0;
                        mem_write = 1'b0;
                        shift = 3'b000;
                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 3'b001) begin //** EPC load value of PC **
                        aluout_load = 1'b0;
                        regs_write = 1'b0;///
                        epc_load = 1'b1;
                        alu_a_mux = 2'b11; ///
                        alu_b_mux = 2'b10; ///
                        aluop = 3'b010; ///
                        ir_write = 1'b0;
                        pc_mux = 3'b000; ///
                        pc_load = 1'b0; ///
                        mdr_load = 1'b0;
                        rega_load = 1'b0; ///
                        regb_load = 1'b0; ///
                        mem_write = 1'b0;
                        shift = 3'b000;
                        COUNTER = 3'b000;
                        if(of) begin
                            STATE = OVERFLOW;
                        end
                    end
                end
                OVERFLOW: begin
                    if(COUNTER == 3'b000 || COUNTER == 3'b001 || COUNTER == 3'b010) begin //**Waiting mem read**
                        STATE = OVERFLOW;
                        mem_mux = 3'b011;
                        mem_write = 1'b1;
                        aluout_load = 1'b0;
                        regs_write = 1'b0;///
                        epc_load = 1'b1;
                        alu_a_mux = 2'b11; ///
                        alu_b_mux = 2'b10; ///
                        aluop = 3'b010; ///
                        ir_write = 1'b0;
                        pc_mux = 3'b000; ///
                        pc_load = 1'b0; ///
                        mdr_load = 1'b0;
                        rega_load = 1'b0; ///
                        regb_load = 1'b0; ///
                        shift = 3'b000;
                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 3'b011) begin //**MDR save**
                        STATE = OVERFLOW;
                        mem_write = 1'b0;
                        mdr_load = 1'b1;///
                        pc_mux = 3'b000; ///
                        mem_mux = 3'b011;
                        aluout_load = 1'b0;
                        regs_write = 1'b0;///
                        epc_load = 1'b0;
                        alu_a_mux = 2'b11; ///
                        alu_b_mux = 2'b10; ///
                        aluop = 3'b010; ///
                        ir_write = 1'b0;
                        pc_load = 1'b0; ///
                        rega_load = 1'b0; ///
                        regb_load = 1'b0; ///
                        shift = 3'b000;
                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 3'b100) begin //**Set on PC for address read in mem**
                        STATE = ENDINSTRUCTION;
                        COUNTER = 3'b000;
                        pc_mux = 3'b000; ///
                        pc_load = 1'b1; ///
                        mem_write = 1'b0;
                        mdr_load = 1'b0;///
                        mem_mux = 3'b011;
                        aluout_load = 1'b0;
                        regs_write = 1'b0;///
                        epc_load = 1'b0;
                        alu_a_mux = 2'b11; ///
                        alu_b_mux = 2'b10; ///
                        aluop = 3'b010; ///
                        ir_write = 1'b0;
                        rega_load = 1'b0; ///
                        regb_load = 1'b0; ///
                        shift = 3'b000;
                    end
                end
                ALUOUTTOREG: begin
                    STATE = ENDINSTRUCTION;
                    wr_mux = 2'b11;
                    wd_mux = 3'b110;
                    regs_write = 1'b1;///
                    alu_a_mux = 2'b00; ///
                    alu_b_mux = 2'b00; ///
                    aluop = 3'b000; ///
                    aluout_load = 1'b0;
                    ir_write = 1'b0;
                    pc_mux = 3'b000; ///
                    pc_load = 1'b0; ///
                    mdr_load = 1'b0;
                    rega_load = 1'b0; ///
                    regb_load = 1'b0; ///
                    epc_load = 1'b0;
                    mem_write = 1'b0;
                    shift = 3'b000;
                    COUNTER = 3'b000;
                end
                ENDINSTRUCTION: begin
                    STATE = FETCH;
                    wr_mux = 2'b11;
                    wd_mux = 3'b110;
                    regs_write = 1'b0;///
                    alu_a_mux = 2'b00; ///
                    alu_b_mux = 2'b00; ///
                    aluop = 3'b000; ///
                    aluout_load = 1'b0;
                    ir_write = 1'b0;
                    pc_mux = 3'b000; ///
                    pc_load = 1'b0; ///
                    mdr_load = 1'b0;
                    rega_load = 1'b0; ///
                    regb_load = 1'b0; ///
                    epc_load = 1'b0;
                    mem_write = 1'b0;
                    shift = 3'b000;
                    COUNTER = 3'b000;
                end
            endcase

        end
    end
    //State and cycle variables

    //Parameters
        //States
        //Opcodes
        //Other parameters

    //Startup handler

    //Transition function

    //State output handler
endmodule
