module mult_line_tb;

  // Parameters
  localparam  MULTLEN_1 = 8;
  localparam  MULTLEN_2 = 8;

  // Ports
  reg clk = 0;
  reg rst_n = 0;
  reg rdy = 0;
  reg [              MULTLEN_1-1:0] mult_1;
  reg [              MULTLEN_2-1:0] mult_2;
  wire [MULTLEN_1 + MULTLEN_2 - 1:0] dout;
  wire valid;

  mult_line 
  #(
    .MULTLEN_1(MULTLEN_1 ),
    .MULTLEN_2 (
        MULTLEN_2 )
  )
  mult_line_dut (
    .clk (clk ),
    .rst_n (rst_n ),
    .rdy (rdy ),
    .mult_1 (mult_1 ),
    .mult_2 (mult_2 ),
    .dout (dout ),
    .valid  ( valid)
  );

  initial begin
    reset_mod();
    @(negedge clk);
    rdy  = 1;
    mult_1 = 25; mult_2 = 5;
    #10 ;      mult_1  = 16;      mult_2      = 10;
        #10 ;      mult_1  = 10;      mult_2      = 4;
        #10 ;      mult_1  = 15;      mult_2      = 7;
        mult_2      = 7;   repeat(32)    #10   mult_1   = mult_1 + 1 ;
        mult_2      = 1;   repeat(32)    #10   mult_1   = mult_1 + 1 ;
        mult_2      = 15;  repeat(32)    #10   mult_1   = mult_1 + 1 ;
        mult_2      = 3;   repeat(32)    #10   mult_1   = mult_1 + 1 ;
        mult_2      = 11;  repeat(32)    #10   mult_1   = mult_1 + 1 ;
        mult_2      = 4;   repeat(32)    #10   mult_1   = mult_1 + 1 ;
        mult_2      = 9;   repeat(32)    #10   mult_1   = mult_1 + 1 ;
  end

  reg  [MULTLEN_1-1:0]   mult1_ref [MULTLEN_2-1:0];
  reg  [MULTLEN_2-1:0]   mult2_ref [MULTLEN_2-1:0];
  always @(posedge clk) begin
      mult1_ref[0] <= mult_1 ;
      mult2_ref[0] <= mult_2 ;
  end

  genvar         i ;
  generate
      for(i=1; i<=MULTLEN_2-1; i=i+1) begin
          always @(posedge clk) begin
          mult1_ref[i] <= mult1_ref[i-1];
          mult2_ref[i] <= mult2_ref[i-1];
          end
      end
  endgenerate
  always
    #5  clk = ! clk ;

    task reset_mod ();
        begin
            rst_n = 1;
            #50 rst_n = 0;
            #50 rst_n = 1;
            #20;
        end
    endtask

endmodule
