module adder (
    input        clk,
    input  [5:0] din,
    input        en,
    input        rst_n,
    output [7:0] dout
);

  reg [7:0] p;
  reg [7:0] p_t;
  reg [7:0] dout_t;
  reg [7:0] q_t1;
  reg [7:0] q_t2;
  reg [7:0] q_t3;
  //reg [7:0] q_t4;
  reg [2:0] cnt_1;
  reg [2:0] cnt_2;
  reg       ce;
  reg       capture_t;
  reg       capture;

  assign dout = dout_t;

  always @(*) begin
    if (cnt_2 != 'd0) begin
      ce = 1;
    end else ce = 0;
  end
  always @(*) begin
    if (cnt_2 == 'd3) begin
        capture_t = 1;
    end else capture_t = 0;
  end
  always @(posedge clk ) begin
    capture <= capture_t;
  end



  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_1 <= 'd0;
    end else if (en) begin
      if (cnt_1 == 'd4) begin
        cnt_1 <= 'd1;
      end else begin
        cnt_1 <= cnt_1 + 1;
      end
    end else cnt_1 <= 'd0;
  end
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_2 <= 'd0;
    end else if (en) begin
      if (cnt_1 == 'd4) begin
        cnt_2 <= cnt_2 + 1;
      end else if (cnt_2 == 'd4) begin
        cnt_2 <= 'd0;
      end else begin
        cnt_2 <= cnt_2;
      end
    end else begin
      cnt_2 <= 'd0;
    end
  end


  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p    <= 'd0;
      q_t1 <= 'd0;
      q_t2 <= 'd0;
      q_t3 <= 'd0;
      //q_t4 <= 'd0;
    end else if (en) begin
      p    <= p_t;
      q_t1 <= p;
      q_t2 <= q_t1;
      q_t3 <= q_t2;
      //q_t4 <= q_t3;
    end else begin
      p    <= p;
      q_t1 <= q_t1;
      q_t2 <= q_t2;
      q_t3 <= q_t3;
    end
  end
  always @(*) begin
    if (ce) begin
      p_t = din + q_t3;
    end else p_t = {2'b0, din};
  end
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout_t <= 'd0;
    end else if (capture) begin
        dout_t <= p;
    end else begin
        dout_t <= 'd0;
    end
  end


endmodule
