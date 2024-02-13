module Bus_Encoder (
    input wire [23:0] Encoder_signals_in,
    output wire [4:0] Encoder_signals_out 
	//Why are we using a register instead of wires? -- this is becuase Enocoder_signals_out is modified in real-time in the always block
);

reg [4:0] enable_signals;


//NOTE: none of these inputs should be high at the same time. Only one can be driven
always @(*) begin
    case (1'b1) // Check which input line is high
        Encoder_signals_in[0]: enable_signals = 5'd0;
        Encoder_signals_in[1]: enable_signals = 5'd1;
        Encoder_signals_in[2]: enable_signals = 5'd2;
        Encoder_signals_in[3]: enable_signals = 5'd3;
        Encoder_signals_in[4]: enable_signals = 5'd4;
        Encoder_signals_in[5]: enable_signals = 5'd5;
        Encoder_signals_in[6]: enable_signals = 5'd6;
        Encoder_signals_in[7]: enable_signals = 5'd7;
        Encoder_signals_in[8]: enable_signals = 5'd8;
        Encoder_signals_in[9]: enable_signals = 5'd9;
        Encoder_signals_in[10]: enable_signals = 5'd10;
        Encoder_signals_in[11]: enable_signals = 5'd11;
        Encoder_signals_in[12]: enable_signals = 5'd12;
        Encoder_signals_in[13]: enable_signals = 5'd13;
        Encoder_signals_in[14]: enable_signals = 5'd14;
        Encoder_signals_in[15]: enable_signals = 5'd15;
        Encoder_signals_in[16]: enable_signals = 5'd16;
        Encoder_signals_in[17]: enable_signals = 5'd17;
        Encoder_signals_in[18]: enable_signals = 5'd18;
        Encoder_signals_in[19]: enable_signals = 5'd19;
        Encoder_signals_in[20]: enable_signals = 5'd20;
        Encoder_signals_in[21]: enable_signals = 5'd21;
        Encoder_signals_in[22]: enable_signals = 5'd22;
        Encoder_signals_in[23]: enable_signals = 5'd23;
        default: enable_signals = 5'b00000; // Zero if no signal is active
    endcase
end

assign Encoder_signals_out = enable_signals;

endmodule
