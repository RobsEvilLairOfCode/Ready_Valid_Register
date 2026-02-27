module ready_valid_register#(
    parameter int DATA_WIDTH = 8
)(
    input logic clk,
    input logic rst_n,

    input logic ready_in, //another register tells this register that it is ready
    input logic valid_in,//another register tells this register that its output is valid and can be read
    input logic [DATA_WIDTH - 1: 0] data_in, //input data from another register

    output logic ready_out, //this register tells another register that it is ready to recieve input
    output logic valid_out, //this register tells another register that it's data is ready
    output logic [DATA_WIDTH -1:0] data_out //output data to another register
);

always_ff @(posedge clk) begin
    if(!rst_n) begin
        data_out <= '0;
        ready_out <= 1'b1;
        valid_out <= 1'b0;
    end else begin
        //writing
        if(ready_in && valid_out) begin
            valid_out <= 1'b0; //register has released the item
            ready_out <= 1'b1; //register is ready to recieve a new item.
        end
        //reading
        if(ready_out && valid_in) begin
            data_out <= data_in;
            valid_out <= 1'b1; //register has a valid item
            ready_out <= 1'b0; //register is currently full.
        end
    end
end


endmodule