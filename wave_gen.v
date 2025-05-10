module wave_gen(
    input clk,                // 100 MHz saat sinyali
    input rst,                // Active high sıfırlama
    input en,                 // Dalga üretimini etkinleştiren enable sinyali
    input cmd_rdy,            // Komut hazır sinyali
    input [7:0] wave_type,    // Dalga türü (SAWTOOTH, TRIANGLE, SQUARE)
    output reg [7:0] wave_out // 8-bit çıkış dalga şekli
);

    reg [7:0] counter;        // Sayıcı
    reg [7:0] amplitude;      // Amplitüd
    reg count_down;           // Artma veya azalma yönü
    reg [7:0] wave_type_reg;  // İçsel kayıtlı dalga türü

    parameter SAWTOOTH = 8'b00000001;
    parameter TRIANGLE = 8'b00000010;
    parameter SQUARE   = 8'b00000011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 8'b0;              
            amplitude <= 8'd128;          
            wave_out <= 8'b0;             
            count_down <= 1'b0;           
            wave_type_reg <= 8'b0;        
        end else if (en) begin
            if (cmd_rdy) begin
                wave_type_reg <= wave_type; 
            end

            case (wave_type_reg)

                // Dişli Dalga (Sawtooth)
                SAWTOOTH: begin
                    counter <= counter + 1;
                    if (counter >= 255) begin
                        counter <= 8'b0; 
                    end
                    wave_out <= counter;
                end

                // Üçgen Dalga (Triangle)
                TRIANGLE: begin
                    if (count_down == 1'b0) begin
                        if (counter < amplitude) begin
                            counter <= counter + 1;
                        end else begin
                            count_down <= 1'b1;
                        end
                    end else begin
                        if (counter > 0) begin
                            counter <= counter - 1;
                        end else begin
                            count_down <= 1'b0; 
                            amplitude <= (amplitude * 2 <= 200) ? amplitude * 2 : 200;
                        end
                    end
                    wave_out <= counter;
                end
                // Kare Dalga (Square)
                SQUARE: begin
                    counter <= counter + 1;

                    if (counter < 64)
                        wave_out <= 8'b11111111;
                    else if (counter < 128)
                        wave_out <= 8'b00000000;
                    else
                        counter <= 0;
                end

                default: begin
                    wave_out <= 8'b0;
                end

            endcase
        end
    end 

endmodule
