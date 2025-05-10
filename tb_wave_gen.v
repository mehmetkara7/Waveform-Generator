`timescale 1ns / 1ps

module tb_wave_gen;

    // Testbench sinyalleri
    reg clk;                      // Clock signal
    reg rst;                      // Reset signal
    reg en;                       // Enable signal
    reg cmd_rdy;                  // Command ready signal
    reg [7:0] wave_type;          // Wave type (SAWTOOTH, TRIANGLE, SQUARE)
    wire [7:0] wave_out;          // Wave output

    // wave_gen modülü instantiation
    wave_gen uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .cmd_rdy(cmd_rdy),
        .wave_type(wave_type),
        .wave_out(wave_out)
    );

    // Clock generation: 100 MHz -> 10 ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // VCD dosyası (dalgaların izlenmesi için)
        $dumpfile("wave_gen_test.vcd");
        $dumpvars(0, tb_wave_gen);

        // Başlangıç değerleri
        clk = 0;
        rst = 0;
        en = 1;
        cmd_rdy = 0;
        wave_type = 8'b00000000;

        // Reset işlemi
        #5  rst = 1;
        #10 rst = 0;

        // *****************************
        // Sawtooth testi
        #10;
        cmd_rdy = 1;
        wave_type = 8'b00000001;  // SAWTOOTH
        #10;
        cmd_rdy = 0;
        #5000; // Sawtooth gözlemi

        // *****************************
        // Triangle testi
        #10;
        rst = 1;
        #10 rst = 0;
        cmd_rdy = 1;
        wave_type = 8'b00000010;  // TRIANGLE
        #10;
        cmd_rdy = 0;
        #8000; // Triangle gözlemi

        // *****************************
        // Square testi
        #10;
        rst = 1;
        #10 rst = 0;
        cmd_rdy = 1;
        wave_type = 8'b00000011;  // SQUARE
        #10;
        cmd_rdy = 0;
        #5000; // Square gözlemi

        // Testin sonlandırılması
        $finish;
    end

endmodule
