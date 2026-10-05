//======================================================
// DAY 7
// D FLIP-FLOP WITH ENABLE
// SYNCHRONOUS + ASYNCHRONOUS RESET
//======================================================


//======================================================
// 1. BASIC D FLIP-FLOP
//======================================================

module dff_basic(
    input clk,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule


//======================================================
// 2. D FLIP-FLOP WITH ENABLE
//======================================================

module dff_enable(
    input clk,
    input en,
    input d,
    output reg q
);

    always @(posedge clk) begin

        if (en)
            q <= d;
        else
            q <= q;

    end

endmodule


//======================================================
// 3. D FLIP-FLOP
//    SYNCHRONOUS RESET + ENABLE
//======================================================

module dff_sync_reset(
    input clk,
    input reset,
    input en,
    input d,
    output reg q
);

    always @(posedge clk) begin

        if (reset)
            q <= 1'b0;

        else if (en)
            q <= d;

        else
            q <= q;

    end

endmodule


//======================================================
// 4. D FLIP-FLOP
//    ASYNCHRONOUS RESET + ENABLE
//======================================================

module dff_async_reset(
    input clk,
    input reset,
    input en,
    input d,
    output reg q
);

    always @(posedge clk or posedge reset) begin

        if (reset)
            q <= 1'b0;

        else if (en)
            q <= d;

        else
            q <= q;

    end

endmodule


//======================================================
// 5. TOP MODULE
//    Contains BOTH synchronous and asynchronous DFF
//======================================================

module dff_reset_top(
    input clk,
    input reset_sync,
    input reset_async,
    input en,
    input d,

    output q_sync,
    output q_async
);

    // Synchronous reset DFF
    dff_sync_reset SYNC_DFF(
        .clk(clk),
        .reset(reset_sync),
        .en(en),
        .d(d),
        .q(q_sync)
    );


    // Asynchronous reset DFF
    dff_async_reset ASYNC_DFF(
        .clk(clk),
        .reset(reset_async),
        .en(en),
        .d(d),
        .q(q_async)
    );

endmodule