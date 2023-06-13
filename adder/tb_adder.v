module adder_tb;

  // Parameters

  // Ports
  reg clk = 0;
  reg [5:0] din;
  reg en = 0;
  reg rst_n = 0;
  wire [7:0] dout;
/*
md build
iverilog -o ./build/test.out  tb_test.v test.v
vvp -n ./build/test.out
gtkwave ./build/wave.vcd
*/

  adder 
  adder_dut (
    .clk (clk ),
    .din (din ),
    .en (en ),
    .rst_n (rst_n ),
    .dout  ( dout)
  );

  initial begin
    $dumpfile("./build/wave.vcd");
    $dumpvars(0,adder_tb);
    #10000 $finish;
  end
  initial begin
    reset_mod();
    en = 1;
    #5 din <= 'd0;
    #10 din <= 'd1;
    #10 din <= 'd2;
    #10 din <= 'd3;
    #10 din <= 'd4;
    #10 din <= 'd5;
    #10 din <= 'd6;
    #10 din <= 'd7;
    #10 din <= 'd8;
    #10 din <= 'd9;
    #10 din <= 'd10;
    #10 din <= 'd11;
    #10 din <= 'd12;
    #10 din <= 'd13;
    #10 din <= 'd14;
    #10 din <= 'd15;
    #20 en = 0;

  end

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
