module Mult(A, B,MultHi,MultLow,clock, acabou, start, reset);
input [31:0] A;
input [31:0] B;
input clock;
input reset;
input start;
output reg [31:0] MultLow;
output reg [31:0] MultHi;
output reg [1:0] acabou;
reg [64:0] Ax;
reg [64:0] S;
reg [64:0] P;
reg [5:0] cont;
reg inicio;
initial inicio = 0;  
initial cont = 0;
initial Ax = 64'b0;
initial S = 64'b0;
initial P = 64'b0;

always@(posedge clock)begin
	if ((inicio == 0) &&  (start == 1)) begin
		inicio = 1;
	end	
	
	if (acabou == 2'd2) begin
		Ax = 64'b0;
		S = 64'b0;
		P= 64'b0;
		MultLow = 32'b0;
		MultHi = 32'b0;
		cont = 6'b0;
		acabou = 1'b0;
	end
	
	if (acabou == 2'd1) begin
		acabou = 2'd2;
	end
	
	if (reset == 1) begin
		Ax = 64'b0;
		S = 64'b0;
		P= 64'b0;
		MultLow = 32'b0;
		MultHi = 32'b0;
		cont = 6'b0;
	end
	
	if (inicio == 1) begin	
		if(cont == 0)begin
			Ax = {A, 32'b0, 1'b0};
			S = {~A+1, 32'b0, 1'b0};
			P = {32'b0 , B, 1'b0};
			P = $signed(P)>>>1;
		end 
		else if(cont == 32)begin
			MultLow = P[32:1];
			MultHi = P[64:33];
			cont = 1'b0;
			acabou = 2'd1;
			inicio = 1'b0;
		end		 
		else begin
			if(P[1:0] == 2'b01)begin
				P = P + Ax;
			end 
			else if(P[1:0]==2'b10)begin
				P = P + S;
			end		
			P = $signed(P)>>>1;

		end
		cont = cont+1;
end	
end
endmodule