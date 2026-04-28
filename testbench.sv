module uart_tx_tb;

logic clk;
logic reset;
logic start;
logic [7:0] data_in;
logic tx;
logic busy;

uart_tx dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .tx(tx),
    .busy(busy)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, uart_tx_tb);

    clk = 0;
    reset = 1;
    start = 0;
    data_in = 8'b0;

    #10 reset = 0;

    data_in = 8'b10101010;
    start = 1;
    #10 start = 0;

    #120;

    data_in = 8'b11001100;
    start = 1;
    #10 start = 0;

    #120;

    $display("UART transmission completed.");
    $finish;
end

endmodule
