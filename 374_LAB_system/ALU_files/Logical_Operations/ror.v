module ror (
    input wire [31:0] A, 
    input wire [4:0] amount,
    output wire[63:0] result
);

    assign result = (A >> amount) | (A << (32 - amount));
    
endmodule
