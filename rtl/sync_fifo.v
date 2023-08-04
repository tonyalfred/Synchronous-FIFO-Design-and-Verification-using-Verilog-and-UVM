module sync_fifo #
    (
        parameter DEPTH     = 8,
        parameter WIDTH     = 8,
        parameter PTR_WIDTH = $clog2(DEPTH)
    )
    (
        input  wire             CLK, 
        input  wire             RST, 

        input  wire [WIDTH-1:0] DATA_IN, 
        input  wire             WR_EN,

        input  wire             RD_EN, 
        output reg  [WIDTH-1:0] DATA_OUT, 

        output wire             EMPTY, 
        output wire             FULL
    );

    // FIFO RAM REGISTERS
    reg [WIDTH-1:0] FIFO_REG [0:DEPTH-1];

    // COUNTER
    reg [PTR_WIDTH:0] CNTR;

    // POINTERS
    reg [PTR_WIDTH-1:0] RD_PTR, WR_PTR;

    // RESETTING COUNTER
    integer i;

    // FLAG ASSIGNMENT
    assign EMPTY = (CNTR == 0);
    assign FULL  = (CNTR == DEPTH);

    // COUNTER 
    always @(posedge CLK, negedge RST) begin: COUNTER
        if (!RST) begin
            CNTR <= 0;
        end else begin
            case ({WR_EN, RD_EN})
                2'b00  : CNTR <= CNTR;
                2'b01  : CNTR <= (CNTR == 0)     ? 0        : CNTR - 1;
                2'b10  : CNTR <= (CNTR == DEPTH) ? DEPTH    : CNTR + 1;
                2'b11  : CNTR <= (CNTR == 0)     ? CNTR + 1 : CNTR;
                default: CNTR <= CNTR;
            endcase
        end
    end

    // POINTERS
    always @(posedge CLK, negedge RST) begin: POINTER
        if (!RST) begin
            WR_PTR <= 0;
            RD_PTR <= 0;
        end 
        else begin
            WR_PTR <= ((WR_EN && !FULL) || (WR_EN && RD_EN)) ? WR_PTR + 1: WR_PTR;
            RD_PTR <= (RD_EN && !EMPTY) || ((WR_EN && RD_EN) && (WR_PTR != RD_PTR)) ? RD_PTR + 1: RD_PTR;
        end
    end

    // WRITE OPERATION
    always @(posedge CLK, negedge RST) begin: WRITE_OPR
        if (!RST)
            for (i = 0; i < DEPTH; i = i + 1)
                FIFO_REG [i] <= 0;
        else if ((WR_EN && !FULL) || (WR_EN && RD_EN))
            FIFO_REG [WR_PTR] <= DATA_IN;
    end

    // READ OPERATION
    always @ (posedge CLK, negedge RST) begin: READ_OPR
        if (!RST)
            DATA_OUT <= 0;
        else if ((WR_EN && RD_EN) && (WR_PTR == RD_PTR))
            DATA_OUT <= 0;
        else if ((RD_EN && !EMPTY) || (WR_EN && RD_EN))
            DATA_OUT <= FIFO_REG [RD_PTR];
    end
endmodule