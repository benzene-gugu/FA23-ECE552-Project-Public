/*
 * File name: shifter.v
 * File Type: Verilog Source
 * Module name: shifter(in, amount, mode, out)
 * Testbench: shifter_tb.sv
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This module is used to shift the input by the amount specified by the amount input. The mode input specifies
 *              the type of shift: 00 - logical left, 01 - arithmetic right, 10 - rotate right, 11 - undefined. The output
 *              is the shifted input.
 * Dependent files: NULL
 */
`default_nettype none
module shifter(in, amount, mode, out);

    // Inputs
    input wire [15:0] in;
    input wire [3:0] amount;
    input wire [1:0] mode;

    // Outputs
    output wire [15:0] out;

    // Internal wires
    reg [1:0] ternary_amount [0:2];
    wire [15:0] shifted_input_1;
    wire [15:0] shifted_input_3;
    
    // Assignments
    // ! Warning: The following code is the result of the death of many brain cells for alignment.
    assign shifted_input_1[15:0] =
        (mode == 2'b00) ?
        (
            (ternary_amount[0] == 2'b00) ? 
            (in[15:0]) : 
            (
                (ternary_amount[0] == 2'b01) ? 
                ({in[14:0],1'h0}) : 
                ({in[13:0],2'h0})
            )
        ) : 
        (
            (mode == 2'b01) ?
            (
                (ternary_amount[0] == 2'b00) ?
                (in[15:0]) :
                (
                    (ternary_amount[0] == 2'b01) ? 
                    ({{1{in[15]}},in[15:1]}) : 
                    ({{2{in[15]}},in[15:2]})
                )
            ) : 
            (
                (ternary_amount[0] == 2'b00) ? 
                (in[15:0]) :
                (
                    (ternary_amount[0] == 2'b01) ? 
                    ({in[0],in[15:1]}) : 
                    ({in[1:0],in[15:2]})
                )
            )
        );
    assign shifted_input_3[15:0] = 
        (mode == 2'b00) ?
        (
            (ternary_amount[1] == 2'b00) ?
            (shifted_input_1[15:0]) :
            (
                (ternary_amount[1] == 2'b01) ?
                ({shifted_input_1[12:0],3'h0}) :
                ({shifted_input_1[9:0],6'h00})
            )
        ) :
        (
            (mode == 2'b01) ?
            (
                (ternary_amount[1] == 2'b00) ?
                (shifted_input_1[15:0]) :
                (
                    (ternary_amount[1] == 2'b01) ?
                    ({{3{in[15]}},shifted_input_1[15:3]}) :
                    ({{6{in[15]}},shifted_input_1[15:6]})
                )
            ) :
            (
                (ternary_amount[1] == 2'b00) ? 
                (shifted_input_1[15:0]) :
                (
                    (ternary_amount[1] == 2'b01) ? 
                    ({shifted_input_1[2:0],shifted_input_1[15:3]}) : 
                    ({shifted_input_1[5:0],shifted_input_1[15:6]})
                )
            )
        );
    assign out[15:0] =
        (mode == 2'b00) ?
        (
            (ternary_amount[2] == 2'b00) ?
            (shifted_input_3[15:0]) :
            ({shifted_input_3[6:0],9'h0})
        ) :
        (
            (mode == 2'b01) ?
            (
                (ternary_amount[2] == 2'b00) ?
                (shifted_input_3[15:0]) :
                ({{9{in[15]}},shifted_input_3[15:9]})
            ) :
            (
                (ternary_amount[2] == 2'b00) ? 
                (shifted_input_3[15:0]) :
                ({shifted_input_3[8:0],shifted_input_3[15:9]})
            )
        );

    // Case statements
    // Case on amount to convert to ternary
    // ! Warning: Reading the following code may cause one to lose their sanity.
    always @(*) begin
        casex (amount)
            4'h0: begin
                ternary_amount[0] = 2'b00;
                ternary_amount[1] = 2'b00;
                ternary_amount[2] = 2'b00;
            end
            4'h1: begin
                ternary_amount[0] = 2'b01;
                ternary_amount[1] = 2'b00;
                ternary_amount[2] = 2'b00;
            end
            4'h2: begin
                ternary_amount[0] = 2'b10;
                ternary_amount[1] = 2'b00;
                ternary_amount[2] = 2'b00;
            end
            4'h3: begin
                ternary_amount[0] = 2'b00;
                ternary_amount[1] = 2'b01;
                ternary_amount[2] = 2'b00;
            end
            4'h4: begin
                ternary_amount[0] = 2'b01;
                ternary_amount[1] = 2'b01;
                ternary_amount[2] = 2'b00;
            end
            4'h5: begin
                ternary_amount[0] = 2'b10;
                ternary_amount[1] = 2'b01;
                ternary_amount[2] = 2'b00;
            end
            4'h6: begin
                ternary_amount[0] = 2'b00;
                ternary_amount[1] = 2'b10;
                ternary_amount[2] = 2'b00;
            end
            4'h7: begin
                ternary_amount[0] = 2'b01;
                ternary_amount[1] = 2'b10;
                ternary_amount[2] = 2'b00;
            end
            4'h8: begin
                ternary_amount[0] = 2'b10;
                ternary_amount[1] = 2'b10;
                ternary_amount[2] = 2'b00;
            end
            4'h9: begin
                ternary_amount[0] = 2'b00;
                ternary_amount[1] = 2'b00;
                ternary_amount[2] = 2'b01;
            end
            4'hA: begin
                ternary_amount[0] = 2'b01;
                ternary_amount[1] = 2'b00;
                ternary_amount[2] = 2'b01;
            end
            4'hB: begin
                ternary_amount[0] = 2'b10;
                ternary_amount[1] = 2'b00;
                ternary_amount[2] = 2'b01;
            end
            4'hC: begin
                ternary_amount[0] = 2'b00;
                ternary_amount[1] = 2'b01;
                ternary_amount[2] = 2'b01;
            end
            4'hD: begin
                ternary_amount[0] = 2'b01;
                ternary_amount[1] = 2'b01;
                ternary_amount[2] = 2'b01;
            end
            4'hE: begin
                ternary_amount[0] = 2'b10;
                ternary_amount[1] = 2'b01;
                ternary_amount[2] = 2'b01;
            end
            4'hF: begin
                ternary_amount[0] = 2'b00;
                ternary_amount[1] = 2'b10;
                ternary_amount[2] = 2'b01;
            end
            default: begin
                ternary_amount[0] = 2'bzz;
                ternary_amount[1] = 2'bzz;
                ternary_amount[2] = 2'bzz;
            end
        endcase
    end
endmodule
`default_nettype wire