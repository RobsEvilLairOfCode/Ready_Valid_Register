module tb_ready_valid_register;
    logic clk, rst_n;
    logic ready_in, ready_out, valid_in, valid_out;
    logic [7:0] data_in, data_out;

    ready_valid_register #(.DATA_WIDTH(8)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .ready_in (ready_in),
        .data_in(data_in),
        .valid_out(valid_out),
        .ready_out(ready_out),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        @(posedge clk);
        @(posedge clk);
        rst_n = 1;

        repeat (20) begin
            data_in = $urandom_range(2**8);
            valid_in = $urandom_range(0,1);
            ready_in = $urandom_range(0,1);
            @(posedge clk);
        end
        $finish;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,tb_ready_valid_register);
    end
endmodule