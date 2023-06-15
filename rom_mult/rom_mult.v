module rom_mult (
    input            clk,
    input            rst_n,
    input            en,
    input      [3:0] mult1,
    input      [3:0] mult2,
    output  [7:0] dat,
    output           rdy
);

  wire [3:0] dat_hh;
  wire [3:0] dat_hl;
  wire [3:0] dat_lh;
  wire [3:0] dat_ll;

  wire [1:0] mult1_h;
  wire [1:0] mult1_l;
  wire [1:0] mult2_h;
  wire [1:0] mult2_l;

  assign mult1_h = mult1[3:2];
  assign mult1_l = mult1[1:0];
  assign mult2_h = mult2[3:2];
  assign mult2_l = mult2[1:0];
  reg [7:0] add1_1;
  reg [7:0] add1_2;
  reg [7:0] add2;
  reg [7:0] add1_1_t;
  reg [7:0] add1_2_t;
  reg [7:0] add2_t;
  reg rdy_t1;
  reg rdy_t2;

  always @(posedge clk) begin
    rdy_t1 <= en;
    rdy_t2 <= rdy_t1;
  end
  assign rdy = rdy_t2;
  assign dat = add2;

  dist_mem_gen_0 rom1 (
      .a  ({mult1_h, mult2_h}),  // input wire [3 : 0] a
      .spo(dat_hh)               // output wire [3 : 0] spo
  );
  dist_mem_gen_0 rom2 (
      .a  ({mult1_h, mult2_l}),  // input wire [3 : 0] a
      .spo(dat_hl)               // output wire [3 : 0] spo
  );
  dist_mem_gen_0 rom3 (
      .a  ({mult1_l, mult2_h}),  // input wire [3 : 0] a
      .spo(dat_lh)               // output wire [3 : 0] spo
  );
  dist_mem_gen_0 rom4 (
      .a  ({mult1_l, mult2_l}),  // input wire [3 : 0] a
      .spo(dat_ll)               // output wire [3 : 0] spo
  );
    always @(*) begin
        add1_1_t = {dat_hh,4'b0} + {2'b0,dat_hl,2'b0};
        add1_2_t = {2'b0,dat_lh,2'b0} + {4'b0,dat_ll};
        add2_t = add1_1 + add1_2;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add1_1 <= 'd0; add1_2 <= 'd0; add2 <= 'd0;
        end else if (en) begin
            add1_1 <= add1_1_t;
            add1_2 <= add1_2_t;
            add2 <= add2_t;
        end else begin
            add1_1 <= 'd0;
            add1_2 <= 'd0;
            add2 <= 'd0;
        end
    end


endmodule
