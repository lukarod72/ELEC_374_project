module RAM512x32  #(parameter   DATA_WIDTH = 32,  // # of bits in word
                                ADDR_WIDTH = 9,  /* # of address bits*/
                                INIT = 32'd0)
(
    input wire read, write, enable,
    input wire [(ADDR_WIDTH-1):0] address,
    input wire [(DATA_WIDTH-1):0] data_in,
    output wire [(DATA_WIDTH-1):0] data_out, // Changed to reg since it's driven by always block
    output reg done,

    input wire overide, 
    input wire [(ADDR_WIDTH-1):0] overide_address,
    input wire [(DATA_WIDTH-1):0] overide_data_in
);

    // Memory array
    reg [DATA_WIDTH-1:0] FullMemorySpace [(2**ADDR_WIDTH)-1:0]; 
    reg [DATA_WIDTH-1:0] q;
    integer i;
    initial begin   
        q <= INIT;
        done <= 0;
        // Load memory contents from a hex file
        $readmemh("Memory_test_preset.hex", FullMemorySpace, 0, 511);
    end


    always @(enable) begin
        done <= 0;
        if(enable) begin
            if (overide) begin
            FullMemorySpace[overide_address] <= overide_data_in;
            end 
            else begin
                if (read) begin
                    q <= FullMemorySpace[address]; // Correctly assigns the read value from memory to q
                end
                else if (write) begin
                    FullMemorySpace[address] <= data_in; // This should be data_in, not q
                end
                done <= 1;
            end
        end 
    end

    assign data_out = q; // Continuously drive data_out with q


endmodule
