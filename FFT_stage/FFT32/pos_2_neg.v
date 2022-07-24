module pos_2_neg
   #(parameter N=16)
   (
   input [N-1:0]pos,
   output [N-1:0]neg
   );

assign neg = ~pos + 1'b1;
endmodule