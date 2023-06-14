module mult_cell #(
    parameter MULTLEN_1 = 4,
    parameter MULTLEN_2 = 4
) (
    input                                    clk,
    input                                    rst_n,
    input                                    en,
    input      [MULTLEN_1 + MULTLEN_2 - 1:0] mult_1_i,   //被乘数
    input      [            MULTLEN_2 - 1:0] mult_2_i,   //乘数
    input      [MULTLEN_1 + MULTLEN_2 - 1:0] mult_acci,
    output reg [MULTLEN_1 + MULTLEN_2 - 1:0] mult_1_o,
    output reg [MULTLEN_1 + MULTLEN_2 - 1:0] mult_2_o,
    output reg [MULTLEN_1 + MULTLEN_2 - 1:0] mult_acco,
    output reg                               rdy
);
  reg [MULTLEN_1 + MULTLEN_2 - 1:0] mult_acco_t;
  always @(*) begin
    mult_acco_t = mult_acci + mult_1_i;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mult_1_o  <= 'd0;
      mult_2_o  <= 'd0;
      mult_acco <= 'd0;
      rdy       <= 0;
    end else if (en) begin
      mult_1_o <= mult_1_i << 1;
      mult_2_o <= mult_2_i >> 1;
      rdy      <= 1;
      if (mult_2_i[0]) begin
        mult_acco <= mult_acco_t;
      end else mult_acco <= mult_acci;
    end else begin
      mult_1_o  <= 'd0;
      mult_2_o  <= 'd0;
      mult_acco <= 'd0;
      rdy       <= 0;
    end
  end


endmodule
