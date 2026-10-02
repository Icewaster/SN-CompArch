`include "fade.sv"
`include "pwm.sv"

// Fade top level module

module top #(
    parameter PWM_INTERVAL = 1200       // CLK frequency is 12MHz, so 1,200 cycles is 100us
)(
    input logic     clk, 
    output logic RGB_R, output logic RGB_G, output logic RGB_B
);

    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value;
    logic pwm_out;
    parameter CHANGE_TIME = 2000000;
    logic [$clog2(CHANGE_TIME) - 1:0] count = 0;
    logic [2:0] currentCase;

    // These will store the duty cycle values of the RGB lights plotted on GTKWave.
    // These will be used for plotting and maintaining current RGB states.
    logic [$clog2(PWM_INTERVAL) - 1:0] r_pwm_value = PWM_INTERVAL - 1; // Red starts as on
    logic [$clog2(PWM_INTERVAL) - 1:0] g_pwm_value = '0;
    logic [$clog2(PWM_INTERVAL) - 1:0] b_pwm_value = '0;

    initial begin
        RGB_R = 1'b0;
        RGB_G = 1'b1;
        RGB_B = 1'b1;
        currentCase = 2'b00;
    end

    fade #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u1 (
        .clk            (clk), 
        .pwm_value      (pwm_value)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u2 (
        .clk            (clk), 
        .pwm_value      (pwm_value), 
        .pwm_out        (pwm_out)
    );
    
    always_ff @(posedge clk) begin
        if (count == CHANGE_TIME - 1) begin
            count <= 0;
            if (currentCase < 2'b10) begin
                currentCase <= currentCase + 2'b01;
            end
            else begin
                currentCase <= 2'b00;
            end
        end
        else begin
            count <= count + 1;
        end
        case(currentCase)
            0: begin
                // Fade green and maintain current value/state of red and blue
                RGB_R <= ~r_pwm_value[$high(r_pwm_value)];
                RGB_G <= ~pwm_out;
                g_pwm_value <= pwm_value;
                RGB_B <= ~b_pwm_value[$high(b_pwm_value)];
            end
            1: begin
                // Fade red and maintain current value/state of green and blue
                RGB_R <= ~pwm_out;
                r_pwm_value <= pwm_value;
                RGB_G <= ~g_pwm_value[$high(g_pwm_value)];
                RGB_B <= ~b_pwm_value[$high(b_pwm_value)];
            end
            2: begin
                // Fade blue and maintain current value/state of red and green
                RGB_R <= ~r_pwm_value[$high(r_pwm_value)];
                RGB_G <= ~g_pwm_value[$high(g_pwm_value)];
                RGB_B <= ~pwm_out;
                b_pwm_value <= pwm_value;
            end
        endcase
    end

endmodule

// `include "fade.sv"
// `include "pwm.sv"

// // Fade top level module

// module top #(
//     parameter PWM_INTERVAL = 1200       // CLK frequency is 12MHz, so 1,200 cycles is 100us
// )(
//     input logic     clk, 
//     output logic RGB_R, output logic RGB_G, output logic RGB_B
// );

//     logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value;
//     logic pwm_out;
//     parameter CHANGE_TIME = 2000000;
//     logic [$clog2(CHANGE_TIME) - 1:0] count = 0;
//     logic [2:0] currentColor;

//     logic [$clog2(PWM_INTERVAL) - 1:0] r_pwm_value = PWM_INTERVAL - 1;
//     logic [$clog2(PWM_INTERVAL) - 1:0] g_pwm_value = '0;
//     logic [$clog2(PWM_INTERVAL) - 1:0] b_pwm_value = '0;

//     initial begin
//         RGB_R = 1'b0;
//         RGB_G = 1'b1;
//         RGB_B = 1'b1;
//         currentColor = 3'b000;
//     end

//     fade #(
//         .PWM_INTERVAL   (PWM_INTERVAL)
//     ) u1 (
//         .clk            (clk), 
//         .pwm_value      (pwm_value)
//     );

//     pwm #(
//         .PWM_INTERVAL   (PWM_INTERVAL)
//     ) u2 (
//         .clk            (clk), 
//         .pwm_value      (pwm_value), 
//         .pwm_out        (pwm_out)
//     );
    
//     always_ff @(posedge clk) begin
//         if (count == CHANGE_TIME - 1) begin
//             count <= 0;
//             if (currentColor < 3'b101) begin
//                 currentColor <= currentColor + 3'b001;
//             end
//             else begin
//                 currentColor <= 3'b000;
//             end
//         end
//         else begin
//             count <= count + 1;
//         end
//         case(currentColor)
//             0: begin
//                 RGB_R <= 1'b0;
//                 RGB_G <= ~pwm_out;
//                 g_pwm_value <= pwm_value;
//                 RGB_B <= 1'b1;
//             end
//             1: begin
//                 RGB_R <= ~pwm_out;
//                 r_pwm_value <= pwm_value;
//                 RGB_G <= 1'b0;
//                 RGB_B <= 1'b1;
//             end
//             2: begin
//                 RGB_R <= 1'b1;
//                 RGB_G <= 1'b0;
//                 RGB_B <= ~pwm_out;
//                 b_pwm_value <= pwm_value;
//             end
//             3: begin
//                 RGB_R <= 1'b1;
//                 RGB_G <= ~pwm_out;
//                 g_pwm_value <= pwm_value;
//                 RGB_B <= 1'b0;
//             end
//             4: begin
//                 RGB_R <= ~pwm_out;
//                 r_pwm_value <= pwm_value;
//                 RGB_G <= 1'b1;
//                 RGB_B <= 1'b0;
//             end
//             5: begin
//                 RGB_R <= 1'b0;
//                 RGB_G <= 1'b1;
//                 RGB_B <= ~pwm_out;
//                 b_pwm_value <= pwm_value;
//             end
//         endcase
//     end

// endmodule