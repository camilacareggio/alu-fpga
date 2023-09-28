`timescale 1ns / 1ps

module testbench_complete();

    //local parameters
    localparam  BITS_DATA = 8;
    localparam  BITS_OP = 6;
    localparam  BUTTONS = 3;
    
    // Operation codes
    localparam  ADD = 6'b100000;
    localparam  SUB = 6'b100010;
    localparam  AND = 6'b100100;
    localparam  OR  = 6'b100101;
    localparam  XOR = 6'b100110;
    localparam  SRA = 6'b000011;
    localparam  SRL = 6'b000010;
    localparam  NOR = 6'b100111;
    reg [BITS_OP*10-1:0] codeOperation;

    // clock signal
    reg clk;
    reg i_reset;
    
    // in out
    reg [BITS_DATA-1 : 0] i_switches;
    reg [BUTTONS-1 : 0] i_buttons;
    wire [BITS_DATA-1 : 0] o_resultado;
    
    // interal register for data validatio
    reg signed [BITS_DATA-1:0] dato_A;
    reg signed [BITS_DATA-1:0] dato_B;
    reg signed [BITS_OP-1:0] operacion;
    reg [BITS_DATA-1 : 0] esperado;

    initial begin
    clk = 1'b0;
    i_reset = 1'b0;
    i_switches = {BITS_DATA {1'b0}};
    i_buttons = 3'b000;
    codeOperation = {ADD, SUB, AND, OR, XOR, SRA, SRL, NOR};

    #1000
    $finish;
    end

    complete_alu #(
        .BITS_DATA (BITS_DATA),
        .BITS_OP (BITS_OP),
        .BUTTONS (BUTTONS)
    )
    u_complete_alu (
        .clk (clk),
        .i_reset(i_reset),
        .i_switches (i_switches),
        .i_buttons (i_buttons),
        .o_result (o_resultado)
    );

    always #10 clk = ~clk;

    always @(posedge clk) begin
        case(i_buttons)
            3'b000: // Asigno dato A
                begin
                    i_switches <= $random;
                    i_buttons <= 3'b001;
                    #1
                    dato_A <= i_switches;
                    $display("Dato A: %b (%d) (%h)", i_switches, $signed(i_switches), $signed(i_switches)); 
                end

            3'b001: // Asigno dato B
                begin
                    i_switches <= $random;
                    i_buttons <= 3'b010;
                    #1
                    dato_B <= i_switches;
                    $display("Dato B: %b (%d) (%h)", i_switches, $signed(i_switches), $signed(i_switches));
                end
            3'b010: // Asigno Operación
                begin
                    //i_switches <= ADD;
                    i_switches <= codeOperation[($urandom % 10) * BITS_OP +: BITS_OP];
                    i_buttons <= 3'b100;
                    #1
                    operacion <= i_switches;
                    $display("Operación: %b (%d) (%h)", i_switches, i_switches, $signed(i_switches));
                end
            3'b100: // Muestro y verifico Resultado
                begin 
                    i_buttons <= 3'b000;
                    #1
                    case (operacion)
                        ADD: esperado = dato_A + dato_B;
                        SUB: esperado = dato_A - dato_B;
                        AND: esperado = dato_A & dato_B;
                        OR : esperado = dato_A | dato_B;
                        XOR: esperado = dato_A ^ dato_B;
                        SRA: esperado = dato_A >>> dato_B; // desplazamiento aritmético a la derecha
                        SRL: esperado = dato_A >> dato_B; // desplazamiento lógico a la derecha
                        NOR: esperado = ~(dato_A | dato_B);
                        default: esperado = {BITS_DATA{1'b0}}; // resultado 0 si la operación no es válida
                    endcase
                    $display("RESULTADO: %b (%d) (%h)", o_resultado, $signed(o_resultado), $signed(o_resultado));
                    if (o_resultado == esperado) begin
                        $display("Test: Resultado CORRECTO");
                    end else begin
                        $display("Test: Resultado INCORRECTO");
                    end
                    $display("##############################");
                end
        endcase     
    end
endmodule