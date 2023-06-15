module rom_mult_tb;

  // Parameters

  // Ports
  reg        clk = 0;
  reg        rst_n = 0;
  reg        en = 0;
  reg  [3:0] mult1;
  reg  [3:0] mult2;
  wire [7:0] dat;
  wire       rdy;

  rom_mult rom_mult_dut (
      .clk  (clk),
      .rst_n(rst_n),
      .en   (en),
      .mult1(mult1),
      .mult2(mult2),
      .dat  (dat),
      .rdy  (rdy)
  );

  initial begin
    reset_mod();
    @(negedge clk);
    en  = 1;
    mult1 = 5;
    mult2 = 5;
    #10;
    mult1 = 10;
    repeat (5) #10 mult2 = mult2 + 1;
    #10;
    mult1 = 3; mult2 = 0;
    repeat (5) #10 mult2 = mult2 + 1;
  end

  always #5 clk = !clk;

  task reset_mod();
    begin
      rst_n = 1;
      #50 rst_n = 0;
      #50 rst_n = 1;
      #20;
    end
  endtask

endmodule
