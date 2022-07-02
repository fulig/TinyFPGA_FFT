module fft_stage #(parameter N=16,
	parameter MSB = 16)
(
	input clk,
	input start,
	input [N-1:0] [MSB-1:0]  data_in,
	output [N-1:0] [MSB-1:0] data_out,
	output [$clog2(N)-1:0] addr_out
	);

wire dv;

genvar i;
generate
    for (i=1; i<N/2; i=i+1) begin : bf_id // bf_id[0] => acces to bf_1

    bfprocessor bfs (
        .clk(clk),
        .start_calc(start),
        .data_valid(dv),
        .A_re(data_in[i][MSB-1:MSB/2]),
        .A_im(data_in[i][MSB/2-1:0]), 
        .B_re(data_in[i+N/2][MSB-1:MSB/2]),
        .B_im(data_in[i+N/2][MSB/2-1:0]),
        .D_re(data_out[i][MSB-1:MSB/2]),
        .D_im(data_out[i][MSB/2-1:0]), 
        .E_re(data_out[i+N/2][MSB-1:MSB/2]),
        .E_im(data_out[i+N/2][MSB/2-1:0])
    );	
end 
endgenerate

endmodule // fft_stage