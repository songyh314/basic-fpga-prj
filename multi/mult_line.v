module mult_line #(
    parameter MULTLEN_1 = 4,  //被乘数
    parameter MULTLEN_2 = 4   //乘数
) (
    input                                clk,
    input                                rst_n,
    input                                rdy,
    input  [              MULTLEN_1-1:0] mult_1,
    input  [              MULTLEN_2-1:0] mult_2,
    output [MULTLEN_1 + MULTLEN_2 - 1:0] dout,
    output                               valid
);

  wire [MULTLEN_1 + MULTLEN_2 - 1:0] mult1_t   [MULTLEN_2-1:0];
  wire [            MULTLEN_2 - 1:0] mult2_t   [MULTLEN_2-1:0];
  wire [MULTLEN_1 + MULTLEN_2 - 1:0] mult_acc_t[MULTLEN_2-1:0];
  wire [            MULTLEN_2 - 1:0] rdy_t;

  mult_cell #(
      .MULTLEN_1(MULTLEN_1),
      .MULTLEN_2(MULTLEN_2)
  ) mult_cell_dut (
      .clk      (clk),
      .rst_n    (rst_n),
      .en       (rdy),
      .mult_1_i ({{(MULTLEN_2) {1'b0}}, mult_1}),
      .mult_2_i (mult_2),
      .mult_acci({(MULTLEN_1 + MULTLEN_2) {1'b0}}),
      .mult_1_o (mult1_t[0]),
      .mult_2_o (mult2_t[0]),
      .mult_acco(mult_acc_t[0]),
      .rdy      (rdy_t[0])
  );

  genvar i;
  generate
    for (i = 1 ; i < MULTLEN_2; i = i + 1) begin : MULT_STEP
      mult_cell #(
          .MULTLEN_1(MULTLEN_1),
          .MULTLEN_2(MULTLEN_2)
      ) mult_cell_step (
          .clk      (clk),
          .rst_n    (rst_n),
          .en       (rdy_t[i-1]),
          .mult_1_i (mult1_t[i-1]),
          .mult_2_i (mult2_t[i-1]),
          .mult_acci(mult_acc_t[i-1]),
          .mult_1_o (mult1_t[i]),
          .mult_2_o (mult2_t[i]),
          .mult_acco(mult_acc_t[i]),
          .rdy      (rdy_t[i])
      );
    end
  endgenerate

  assign valid = rdy_t[MULTLEN_2-1];
  assign dout  = mult_acc_t[MULTLEN_2-1];
endmodule
