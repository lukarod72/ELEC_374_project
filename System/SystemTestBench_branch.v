`timescale 1ns/10ps

module SystemTestBench_ALU;

    // Test bench parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 9;

    /*Inputs*/
    reg Clock, clear;
    reg inport_data;
    
    
    reg HIout, LOout, Zhi_out, Zlo_out, PCout, MDRout, Inport_out, Cout;
    reg MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin, CONin;
    reg outport_in, inport_data_ready;
    reg [4:0] opcode;
    reg IncPC;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    reg Mem_read, Mem_Write, Mem_enable512x32;

    reg mem_overide; reg [ADDR_WIDTH-1:0] overide_address; reg [DATA_WIDTH-1:0] overide_data_in;


    /*Outputs*/
    wire outport_data;

    wire [DATA_WIDTH-1:0] Mem_to_datapath, Mem_data_to_chip;
    wire [ADDR_WIDTH-1:0] MAR_address;
    wire con_ff_bit, memory_done;
    


    // Instantiate the System module
    System #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) UUT (
        .Clock(Clock), .clear(clear),
        .inport_data(inport_data), .outport_data(outport_data),


        .HIout(HIout), .LOout(LOout), .Zhi_out(Zhi_out), .Zlo_out(Zlo_out), .PCout(PCout), .MDRout(MDRout), .Inport_out(Inport_out), .Cout(Cout),
        .MARin(MARin), .Zin(Zin), .PCin(PCin), .MDRin(MDRin), .IRin(IRin), .Yin(Yin), .HIin(HIin), .LOin(LOin), .CONin(CONin),
        .outport_in(outport_in), .inport_data_ready(inport_data_ready),
        .opcode(opcode), .IncPC(IncPC),
        .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout),
        .con_ff_bit(con_ff_bit),
        .Mem_Read(Mem_read), .Mem_Write(Mem_Write), .Mem_enable512x32(Mem_enable512x32),
        .Mem_to_datapath_out(Mem_to_datapath), .Mem_data_to_chip_out(Mem_data_to_chip), .MAR_address_out(MAR_address), .memory_done(memory_done),


        .mem_overide(mem_overide), .overide_address(overide_address), .overide_data_in(overide_data_in)
    );


    parameter Default = 6'd0,
              
            
              BRZR_T0 = 6'd10,
              BRZR_T1 = 6'd11,
              BRZR_T2 = 6'd12,
              BRZR_T3 = 6'd13,
              BRZR_T4 = 6'd14,
              BRZR_T5 = 6'd15,
              BRZR_T6 = 6'd16,

              BRNZ_T0 = 6'd17,
              BRNZ_T1 = 6'd18,
              BRNZ_T2 = 6'd19,
              BRNZ_T3 = 6'd20,
              BRNZ_T4 = 6'd21,
              BRNZ_T5 = 6'd22,
              BRNZ_T6 = 6'd23,

              BRPL_T0 = 6'd24,
              BRPL_T1 = 6'd25,
              BRPL_T2 = 6'd26,
              BRPL_T3 = 6'd27,
              BRPL_T4 = 6'd28,
              BRPL_T5 = 6'd29,
              BRPL_T6 = 6'd30,

              BRMI_T0 = 6'd31,
              BRMI_T1 = 6'd32,
              BRMI_T2 = 6'd33,
              BRMI_T3 = 6'd34,
              BRMI_T4 = 6'd35,
              BRMI_T5 = 6'd36,
              BRMI_T6 = 6'd37;

    reg [5:0] Present_state = Default;

    /*Clock generation*/
      initial begin
          Clock = 0;
          forever #10 Clock = ~Clock; // Toggle clock every 10 ns
      end
      always @(posedge Clock) // finite state machine; if clock rising-edge
        begin
            case (Present_state)
                Default : Present_state = Mem_load_data1;
                Mem_load_data1 : Present_state = Mem_load_data2;
                Mem_load_data2 : Present_state = Mem_load_data3;
                Mem_load_data3 : Present_state = Mem_load_data4;
                Mem_load_data4 : Present_state = Mem_load_data5;
                Mem_load_data5 : Present_state = BRZR_T0;


                BRZR_T0: Present_state = BRZR_T1;
                BRZR_T1: Present_state = BRZR_T2;
                BRZR_T2: Present_state = BRZR_T3;
                BRZR_T3: Present_state = BRZR_T4;
                BRZR_T4: Present_state = BRZR_T5;
                BRZR_T5: Present_state = BRZR_T6;
                BRZR_T6: Present_state = BRNZ_T0;

                BRNZ_T0: Present_state = BRNZ_T1;
                BRNZ_T1: Present_state = BRNZ_T2;
                BRNZ_T2: Present_state = BRNZ_T3;
                BRNZ_T3: Present_state = BRNZ_T4;
                BRNZ_T4: Present_state = BRNZ_T5;
                BRNZ_T5: Present_state = BRNZ_T6;
                BRNZ_T6: Present_state = BRPL_T0;

                BRPL_T0: Present_state = BRPL_T1;
                BRPL_T1: Present_state = BRPL_T2;
                BRPL_T2: Present_state = BRPL_T3;
                BRPL_T3: Present_state = BRPL_T4;
                BRPL_T4: Present_state = BRPL_T5;
                BRPL_T5: Present_state = BRPL_T6;
                BRPL_T6: Present_state = BRMI_T0;

                BRMI_T0: Present_state = BRMI_T1;
                BRMI_T1: Present_state = BRMI_T2;
                BRMI_T2: Present_state = BRMI_T3;
                BRMI_T3: Present_state = BRMI_T4;
                BRMI_T4: Present_state = BRMI_T5;
                BRMI_T5: Present_state = BRMI_T6;

          endcase
      end


  always @(Present_state) begin
    case (Present_state) // assert the required signals in each clock cycle
      Default: begin
        
        clear <= 0;
        HIout <=0; LOout<=0; Zhi_out<=0; Zlo_out<=0; PCout<=0; MDRout<=0; Inport_out<=0; Cout<=0;
        MARin<=0; Zin <=0; PCin <=0; MDRin <=0; IRin <=0; Yin <=0; HIin <=0; LOin <=0; 
        opcode <= 5'd0; IncPC <= 0;
        Gra <=0; Grb <=0; Grc <=0; Rin <=0; Rout <=0; BAout <=0;
        Mem_read <=0; Mem_Write <=0;  Mem_enable512x32 <= 0; con_ff_bit <= 0;


        /*INIT inport and outport*/
        inport_data <=32'd0; outport_in <=0; inport_data_ready <=0;    

        mem_overide <=0; overide_address <= 9'd0; overide_data_in <= 32'd0;
      end


      /*INIT STATES: These states are for initializing the desired instruction. #TODO: add states accordingly*/
      

      /*Mem_load_instruction1 : begin
        overide_address <= 9'd0; //Load Desired Memory Address
        overide_data_in <= 32'b00011_0001_0010_0000000000000000001;//load addi r1, r2, 1
        mem_overide <= 1;
        
        Mem_enable512x32 <= 1;
        #10 Mem_enable512x32 <= 0;


      end
      Mem_load_instruction2 : begin
        overide_address <= 9'd1; //Load Desired Memory Address
        overide_data_in <= 32'b01011_0001_0010_0000000000000000011; //load andi r1, r2, 3
        
        Mem_enable512x32 <= 1;
        #10 Mem_enable512x32 <= 0;
      end 
      Mem_load_instruction3 : begin
        overide_address <= 9'd2; //Load Desired Memory Address
        overide_data_in <= 32'b01010_0001_0010_0000000000000001001; //load ori r1, r2, 9    

        Mem_enable512x32 <= 1;
        #10 Mem_enable512x32 <= 0; 
      end 
      Mem_load_data1 : begin 
        overide_address <= 9'd500; //Load Desired Memory Address
        overide_data_in <= 32'h00000014;

        Mem_enable512x32 <= 1;
        #10 Mem_enable512x32 <= 0;
      end

      Mem_load_data2 : begin
        overide_address <= 9'd501; //Load Desired Memory Address
        overide_data_in <= 32'h00000014;

        Mem_enable512x32 <= 1;
        #10 Mem_enable512x32 <= 0; mem_overide <= 0;
      end
      */

    Mem_load_data1: begin
        
    end

    /*-------------------------------------{brzr}---------------------------------------------------------------------------------------------}*/
      BRZR_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
        BRZR_T1: begin
                      PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                      Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                      
                      MDRin <= 1; Mem_read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
        end
        BRZR_T2: begin 
                      Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_read <=0;  Mem_enable512x32<=0;          
                      
                      MDRout <= 1; IRin <= 1;                     
        end
        BRZR_T3: begin 
                      MDRout <= 0; IRin <= 0;                   
                      
                      Gra <= 1; Rout <= 1; CONin <= 1;                       
        end
        BRZR_T4: begin 
                      Rout <= 0; CONin <= 0; Gra <= 0;                    
                      
                      PCout <= 1; Yin <= 1;
        end
        BRZR_T5: begin 
                      PCout <= 0; Yin <= 0;                      
        
                      Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
        end
        BRZR_T6: begin 
                      Cout <= 0; Zin <= 0;                      
        
                      Zlo_out <= 1;
                      if (con_ff_bit) PCin <= 1;
                      #20 PCin <= 0;
        end

      /*ADDi~~~~~~~~~~~~~~~~~~~~~~~~{brnz}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        BRNZ_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
        BRNZ_T1: begin
                      PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                      Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                      
                      MDRin <= 1; Mem_read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
        end
        BRNZ_T2: begin 
                      Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_read <=0;  Mem_enable512x32<=0;          
                      
                      MDRout <= 1; IRin <= 1;                     
        end
        BRNZ_T3: begin 
                      MDRout <= 0; IRin <= 0;                   
                      
                      Gra <= 1; Rout <= 1; CONin <= 1;                       
        end
        BRNZ_T4: begin 
                      Rout <= 0; CONin <= 0; Gra <= 0;                    
                      
                      PCout <= 1; Yin <= 1;
        end
        BRNZ_T5: begin 
                      PCout <= 0; Yin <= 0;                      
        
                      Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
        end
        BRNZ_T6: begin 
                      Cout <= 0; Zin <= 0;                      
        
                      Zlo_out <= 1;
                      if (con_ff_bit) PCin <= 1;
                      #20 PCin <= 0;
        end

/*~~~~~~~~~~~~~~~~~~~~~~~~{brpl}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

        BRPL_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
        BRPL_T1: begin
                      PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                      Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                      
                      MDRin <= 1; Mem_read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
        end
        BRPL_T2: begin 
                      Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_read <=0;  Mem_enable512x32<=0;          
                      
                      MDRout <= 1; IRin <= 1;                     
        end
        BRPL_T3: begin 
                      MDRout <= 0; IRin <= 0;                   
                      
                      Gra <= 1; Rout <= 1; CONin <= 1;                       
        end
        BRPL_T4: begin 
                      Rout <= 0; CONin <= 0; Gra <= 0;                    
                      
                      PCout <= 1; Yin <= 1;
        end
        BRPL_T5: begin 
                      PCout <= 0; Yin <= 0;                      
        
                      Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
        end
        BRPL_T6: begin 
                      Cout <= 0; Zin <= 0;                      
        
                      Zlo_out <= 1;
                      if (con_ff_bit) PCin <= 1;
                      #20 PCin <= 0;
        end

/*-----------------------------------{brmi}------------------------------*/
        BRMI_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
        BRMI_T1: begin
                      PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                      Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                      
                      MDRin <= 1; Mem_read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
        end
        BRMI_T2: begin 
                      Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_read <=0;  Mem_enable512x32<=0;          
                      
                      MDRout <= 1; IRin <= 1;                     
        end
        BRMI_T3: begin 
                      MDRout <= 0; IRin <= 0;                   
                      
                      Gra <= 1; Rout <= 1; CONin <= 1;                       
        end
        BRMI_T4: begin 
                      Rout <= 0; CONin <= 0; Gra <= 0;                    
                      
                      PCout <= 1; Yin <= 1;
        end
        BRMI_T5: begin 
                      PCout <= 0; Yin <= 0;                      
        
                      Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
        end
        BRMI_T6: begin 
                      Cout <= 0; Zin <= 0;                      
        
                      Zlo_out <= 1;
                      if (con_ff_bit) PCin <= 1;
                      #20 PCin <= 0;
        end

    
      endcase
    end


endmodule