//======================================================
// DAY 7 TESTBENCH
// SYNCHRONOUS + ASYNCHRONOUS RESET
//======================================================

module day7_tb;


    //==================================================
    // INPUT SIGNALS
    //==================================================

    reg clk;

    reg reset_sync;
    reg reset_async;

    reg en;
    reg d;


    //==================================================
    // OUTPUT SIGNALS
    //==================================================

    wire q_sync;
    wire q_async;


    //==================================================
    // DUT
    //==================================================

    dff_reset_top DUT(

        .clk(clk),

        .reset_sync(reset_sync),
        .reset_async(reset_async),

        .en(en),
        .d(d),

        .q_sync(q_sync),
        .q_async(q_async)

    );


    //==================================================
    // CLOCK
    // 10 ns PERIOD
    //==================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    //==================================================
    // TEST
    //==================================================

    initial begin

        // Initial values
        reset_sync  = 1'b0;
        reset_async = 1'b0;

        en = 1'b0;
        d  = 1'b0;


        // ---------------------------------------------
        // Initial reset
        // ---------------------------------------------

        #2;

        reset_sync  = 1'b1;
        reset_async = 1'b1;

        #3;

        reset_sync  = 1'b0;
        reset_async = 1'b0;


        // ---------------------------------------------
        // Enable and load D = 1
        // ---------------------------------------------

        #2;

        en = 1'b1;
        d  = 1'b1;

        #10;


        // ---------------------------------------------
        // Hold
        // ---------------------------------------------

        en = 1'b0;
        d  = 1'b0;

        #10;


        // ---------------------------------------------
        // ASYNCHRONOUS RESET TEST
        // ---------------------------------------------

        $display("====================================");
        $display("ASYNC RESET TEST");
        $display("====================================");

        reset_async = 1'b1;

        #2;

        $display("Time=%0t reset_async=%b q_async=%b",
                 $time, reset_async, q_async);

        reset_async = 1'b0;


        // ---------------------------------------------
        // Load again
        // ---------------------------------------------

        en = 1'b1;
        d  = 1'b1;

        #10;


        // ---------------------------------------------
        // SYNCHRONOUS RESET TEST
        // ---------------------------------------------

        $display("====================================");
        $display("SYNC RESET TEST");
        $display("====================================");

        reset_sync = 1'b1;

        #2;

        $display("Before clock edge:");
        $display("Time=%0t reset_sync=%b q_sync=%b",
                 $time, reset_sync, q_sync);

        #3;

        $display("After clock edge:");
        $display("Time=%0t reset_sync=%b q_sync=%b",
                 $time, reset_sync, q_sync);

        reset_sync = 1'b0;


        // ---------------------------------------------
        // Final
        // ---------------------------------------------

        #10;

        $display("====================================");
        $display("DAY 7 TEST COMPLETE");
        $display("====================================");

        $finish;

    end


    //==================================================
    // MONITOR
    //==================================================

    initial begin

        $monitor(
            "TIME=%0t CLK=%b SYNC_RST=%b ASYNC_RST=%b EN=%b D=%b Q_SYNC=%b Q_ASYNC=%b",
            $time,
            clk,
            reset_sync,
            reset_async,
            en,
            d,
            q_sync,
            q_async
        );

    end


    //==================================================
    // WAVEFORM FILE
    //==================================================

    initial begin

        $dumpfile("day7.vcd");

        $dumpvars(0, day7_tb);

    end

endmodule