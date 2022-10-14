// FULL ADDER
module FA(Cout, S, A, B, Cin);
	input A, B, Cin;
	output Cout, S;
	wire AxorB, AxorBandCin, AandB;
	XOR2X1 x0(.A(A), .B(B), .Y(AxorB));
	XOR2X1 x1(.A(AxorB), .B(Cin), .Y(S) );
	AND2X1 x2(.A(AxorB), .B(Cin), .Y(AxorBandCin) );
	AND2X1 x3(.A(A), .B(B), .Y(AandB) );
	OR2X1  x4(.A(AandB), .B(AxorBandCin), .Y(Cout) );
endmodule	
 
module Node1(Carryout, Sumout, A, B, Sum, Carry ); 
		input A, B, Sum, Carry;
		output Carryout, Sumout;
		wire W1;		
		assign W1 = A&B;  //0*0=0 0*1=0 1*0=0 1*1=1 -->and
		FA fa1(Carryout, Sumout, W1, Sum, Carry);
endmodule


module Lab4(mul, A, B); //output input 
	
	input [3:0] A, B; //input 4-bit
	output [7:0] mul; //output 8-bit
	wire [3:0] c0, c1, c2, c3, c4, c5, c6; //carry
	wire [3:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6; //sum
	
	//First row
	Node1 node0(c0[0], sum0[0], A[0], B[0], 0, 0);
	Node1 node1(c1[0], sum1[0], A[1], B[0], 0, c0[0]);
	Node1 node2(c2[0], sum2[0], A[2], B[0], 0, c1[0]);
	Node1 node3(c3[0], sum3[0], A[3], B[0], 0, c2[0]);
	
	//Second row
	Node1 node4(c1[1], sum1[1], A[0], B[1], sum1[0], 0);
	Node1 node5(c2[1], sum2[1], A[1], B[1], sum2[0], c1[1]);
	Node1 node6(c3[1], sum3[1], A[2], B[1], sum3[0], c2[1]);
	Node1 node7(c4[1], sum4[1], A[3], B[1],   c3[0], c3[1]);
	
	//Third row
	Node1 node8(c2[2], sum2[2], A[0], B[2], sum2[1], 0);
	Node1 node9(c3[2], sum3[2], A[1], B[2], sum3[1], c2[2]);
	Node1 node10(c4[2], sum4[2], A[2], B[2],sum4[1], c3[2]);
	Node1 node11(c5[2], sum5[2], A[3], B[2], c4[1], c4[2]);	
	
	//Forth row
	Node1 node12(c3[3], sum3[3], A[0], B[3], sum3[2], 0);
	Node1 node13(c4[3], sum4[3], A[1], B[3], sum4[2], c3[3]);
	Node1 node14(c5[3], sum5[3], A[2], B[3], sum5[2], c4[3]);
	Node1 node15(c6[3], sum6[3], A[3], B[3],  c5[2], c5[3]);

	assign mul[0] = sum0[0];
	assign mul[1] = sum1[1];
	assign mul[2] = sum2[2];
	assign mul[3] = sum3[3];
	assign mul[4] = sum4[3];
	assign mul[5] = sum5[3];
	assign mul[6] = sum6[3];
	assign mul[7] = c6[3];
endmodule	