module N_bit_adder
   #(parameter N=8)
   (
   input [N-1:0]input1,
   input [N-1:0]input2,
   output [N-1:0]answer
   );


  wire [N-1:0] carry;
   genvar i;
   generate 
   for(i=0;i<N;i=i+1)
     begin: generate_N_bit_Adder
   if(i==0) 
  half_adder f(input1[0],input2[0],answer[0],carry[0]);
   else
  full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
     end
   endgenerate
endmodule 

module half_adder(x,y,s,c);
   input x,y;
   output s,c;
   assign s=x^y;
   assign c=x&y;
endmodule // half adder

module full_adder(x,y,c_in,s,c_out);
   input x,y,c_in;
   output s,c_out;
 assign s = (x^y) ^ c_in;
 assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule // full_adder

module pos_2_neg
   #(parameter N=16)
   (
   input [N-1:0]pos,
   output [N-1:0]neg
   );

assign neg = ~pos + 1'b1;
endmodule