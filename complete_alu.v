`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

module complete_alu #(
        parameter BITS_DATA = 8,
        parameter BITS_OP = 6,
        parameter BUTTONS = 3
    )(
        input wire clk,
        input wire i_reset,
        input wire signed [BITS_DATA-1:0] i_switches,
        input wire [BUTTONS-1:0] i_buttons, // indicates which value is the input (001: i_a, 010: i_b, 100: i_op)
        output wire signed [BITS_DATA-1:0] o_result
    );
    
    // internal registers to store inputs
    reg signed [BITS_DATA-1:0] dato_A;
    reg signed [BITS_DATA-1:0] dato_B;
    reg signed [BITS_OP-1:0] operacion;

    always @(posedge clk) begin              
        if(i_buttons[0]) dato_A <= i_switches;
        if(i_buttons[1]) dato_B <= i_switches;
        if(i_buttons[2]) operacion <= i_switches;
        if(i_reset) begin
            dato_A <= {BITS_DATA {1'b0}};
            dato_B <= {BITS_DATA {1'b0}};
            operacion <= {BITS_OP {1'b0}};
        end
    end
    
    alu #(
        .BITS_DATA(BITS_DATA),
        .BITS_OP(BITS_OP)
    ) u_alu (
        .i_a(dato_A),
        .i_b(dato_B),
        .i_op(operacion),
        .o_result(o_result)
    );

endmodule

