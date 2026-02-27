module fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int MEMORY_WIDTH = 8
)(
    input logic [DATA_WIDTH - 1:0] data_in,
    input logic read_enable,
    input logic write_enable,

    input logic clk,
    input logic rst,

    output logic [DATA_WIDTH - 1:0] data_out,
    output logic full,
    output logic empty
);
    localparam int POINTER_WIDTH = $clog2(MEMORY_WIDTH);
    logic [DATA_WIDTH - 1: 0] memory_array [MEMORY_WIDTH - 1:0];
    logic [POINTER_WIDTH: 0] read_pointer, write_pointer;

    int memory_counter;

    logic [POINTER_WIDTH:0] write_pointer_next;
        
    always_ff @(posedge clk) begin
        memory_counter = 0;
        if(rst) begin //Reset signal is high
            for(memory_counter = 0; memory_counter < MEMORY_WIDTH ; memory_counter++) begin
                memory_array[memory_counter] = '0; //Reset the data to zero 
            end

            full <= 1'b0;
            empty <= 1'b1;

            read_pointer <= '0;
            write_pointer <= '0;
     
        end else begin //Reset signal is low

            if(read_enable && !empty) begin //If a read operation is signaled and there is something to read...
                read_pointer <= read_pointer + 1;

                empty <= (read_pointer + 1 == write_pointer);
                full <= 1'b0;

            end else if(write_enable && !full) begin //If a write operation is signaled and queue is not full...
              memory_array[write_pointer[POINTER_WIDTH-1:0]] <= data_in ;

                write_pointer <= write_pointer + 1;

                
                write_pointer_next = write_pointer + 1;
                full <= (write_pointer_next [POINTER_WIDTH - 1:0] == read_pointer[POINTER_WIDTH - 1:0]) && (write_pointer_next[POINTER_WIDTH] != read_pointer[POINTER_WIDTH]);
                empty <= 1'b0;
            end
          
        end
    end

    //ASYNC read for CDC usage
    always_comb begin
        data_out = memory_array[read_pointer[POINTER_WIDTH-1:0]];
    end
endmodule