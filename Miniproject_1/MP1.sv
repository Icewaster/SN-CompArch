module top(input logic clk, output logic RGB_R, output logic RGB_G, output logic RGB_B);

    parameter CHANGE_TIME = 2000000;
    logic [$clog2(CHANGE_TIME) - 1:0] count = 0;
    logic [1:0] currentColor;

    initial begin
        RGB_R = 1'b0;
        RGB_G = 1'b1;
        RGB_B = 1'b1;
        currentColor = 2'b00;
    end

    always_ff @(posedge clk) begin
        if (count == CHANGE_TIME - 1) begin
            count <= 0;
            if (currentColor < 2'b10) begin
                currentColor = currentColor + 2'b01;
            end
            else begin
                currentColor = 2'b00;
            end
            case(currentColor)
                0: RGB_B <= ~RGB_B;
                1: RGB_G <= ~RGB_G;
                2: RGB_R <= ~RGB_R;
            endcase
        end
        else begin
            count <= count + 1;
        end
    end

endmodule