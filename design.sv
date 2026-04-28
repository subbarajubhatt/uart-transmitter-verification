module uart_tx (
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic [7:0] data_in,
    output logic tx,
    output logic busy
);

typedef enum logic [1:0] {
    IDLE  = 2'b00,
    START = 2'b01,
    DATA  = 2'b10,
    STOP  = 2'b11
} state_t;

state_t state;
logic [7:0] shift_reg;
logic [2:0] bit_index;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        tx <= 1'b1;
        busy <= 1'b0;
        shift_reg <= 8'b0;
        bit_index <= 3'b0;
    end else begin
        case (state)

            IDLE: begin
                tx <= 1'b1;
                busy <= 1'b0;
                bit_index <= 0;

                if (start) begin
                    shift_reg <= data_in;
                    state <= START;
                    busy <= 1'b1;
                end
            end

            START: begin
                tx <= 1'b0;
                state <= DATA;
            end

            DATA: begin
                tx <= shift_reg[bit_index];

                if (bit_index == 7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end

            STOP: begin
                tx <= 1'b1;
                busy <= 1'b0;
                state <= IDLE;
            end

        endcase
    end
end

endmodule
