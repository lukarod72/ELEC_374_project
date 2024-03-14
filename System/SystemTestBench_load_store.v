`timescale 1ns/10ps

module SystemTestBench_load_store;

    // Test bench parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 9;

    /*Inputs*/
    reg Clock, clear;
    reg[DATA_WIDTH-1:0] inport_data;
    
    
    reg HIout, LOout, Zhi_out, Zlo_out, PCout, MDRout, Inport_out, Cout;
    reg MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin, CONin;
    reg outport_in, inport_data_ready;
    reg [4:0] opcode;
    reg IncPC;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    reg Mem_Read, Mem_Write, Mem_enable512x32;

    reg mem_overide; reg [ADDR_WIDTH-1:0] overide_address; reg [DATA_WIDTH-1:0] overide_data_in;


    /*Outputs*/
    wire[DATA_WIDTH-1:0] outport_data;

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
        .Mem_Read(Mem_Read), .Mem_Write(Mem_Write), .Mem_enable512x32(Mem_enable512x32),
        .Mem_to_datapath_out(Mem_to_datapath), .Mem_data_to_chip_out(Mem_data_to_chip), .MAR_address_out(MAR_address), .memory_done(memory_done),


        .mem_overide(mem_overide), .overide_address(overide_address), .overide_data_in(overide_data_in)
    );


    parameter Default = 6'd0, Mem_load_instruction1 = 6'd1, Mem_load_instruction2 = 6'd2, Mem_load_instruction3 = 6'd3,
                              Mem_load_instruction4 = 6'd4,Mem_load_instruction5 = 6'd5, Mem_load_instruction6 = 6'd6,

                              Mem_load_data1 = 6'd7, Mem_load_data2 = 6'd8, Mem_load_data3 = 6'd9,
              
            
              LD_T0 = 6'd10, LD_T1 = 6'd11, LD_T2 = 6'd12, LD_T3 = 6'd13, LD_T4 = 6'd14, LD_T5 = 6'd15, LD_T6 = 6'd16, LD_T7 = 6'd17,  
              LD1_T0 = 6'd20, LD1_T1 = 6'd21, LD1_T2 = 6'd22, LD1_T3 = 6'd23, LD1_T4 = 6'd24, LD1_T5 = 6'd25, LD1_T6 = 6'd26, LD1_T7 = 6'd27,
              LDI_T0 = 6'd30, LDI_T1 = 6'd31, LDI_T2 = 6'd32, LDI_T3 = 6'd33, LDI_T4 = 6'd34, LDI_T5 = 6'd35,
              LDI1_T0 = 6'd40, LDI1_T1 = 6'd41, LDI1_T2 = 6'd42, LDI1_T3 = 6'd43, LDI1_T4 = 6'd44, LDI1_T5 = 6'd45, 

              ST_T0 = 6'd46, ST_T1 = 6'd47, ST_T2 = 6'd48, ST_T3 = 6'd49, ST_T4 = 6'd50, ST_T5 = 6'd51, ST_T6 = 6'd52, ST_T7 = 6'd53,
              ST1_T0 = 6'd56, ST1_T1 = 6'd57, ST1_T2 = 6'd58, ST1_T3 = 6'd59, ST1_T4 = 6'd60, ST1_T5 = 6'd61, ST1_T6 = 6'd62, ST1_T7 = 6'd63;

    reg [5:0] Present_state = Default;



    /*Clock generation*/
      initial begin
          Clock = 0;
          forever #10 Clock = ~Clock; // Toggle clock every 10 ns
      end
      always @(posedge Clock) // finite state machine; if clock rising-edge
        begin
            case (Present_state)
                Default : Present_state = Mem_load_instruction1;
                Mem_load_instruction1 : Present_state = Mem_load_instruction2;
                Mem_load_instruction2 : Present_state = Mem_load_instruction3;
                Mem_load_instruction3 : Present_state = Mem_load_instruction4;
                Mem_load_instruction4 : Present_state = Mem_load_instruction5;
                Mem_load_instruction5 : Present_state = Mem_load_instruction6;
                Mem_load_instruction6 : Present_state = Mem_load_data1;

                Mem_load_data1 : Present_state = Mem_load_data2;
                Mem_load_data2 : Present_state = Mem_load_data3;
                Mem_load_data3 : Present_state = LD_T0;
                

                LD_T0: Present_state = LD_T1;
                LD_T1: Present_state = LD_T2;
                LD_T2: Present_state = LD_T3;
                LD_T3: Present_state = LD_T4;
                LD_T4: Present_state = LD_T5;
                LD_T5: Present_state = LD_T6;
                LD_T6: Present_state = LD_T7;
                LD_T7: Present_state = LD1_T0;

                LD1_T0: Present_state = LD1_T1;
                LD1_T1: Present_state = LD1_T2;
                LD1_T2: Present_state = LD1_T3;
                LD1_T3: Present_state = LD1_T4;
                LD1_T4: Present_state = LD1_T5;
                LD1_T5: Present_state = LD1_T6;
                LD1_T6: Present_state = LD1_T7;
                LD1_T7: Present_state = LDI_T0;





                LDI_T0: Present_state = LDI_T1;
                LDI_T1: Present_state = LDI_T2;
                LDI_T2: Present_state = LDI_T3;
                LDI_T3: Present_state = LDI_T4;
                LDI_T4: Present_state = LDI_T5;
                LDI_T5: Present_state = LDI1_T0;

                LDI1_T0: Present_state = LDI1_T1;
                LDI1_T1: Present_state = LDI1_T2;
                LDI1_T2: Present_state = LDI1_T3;
                LDI1_T3: Present_state = LDI1_T4;
                LDI1_T4: Present_state = LDI1_T5;
                LDI1_T5: Present_state = ST_T0;


                
            

                ST_T0: Present_state = ST_T1;
                ST_T1: Present_state = ST_T2;
                ST_T2: Present_state = ST_T3;
                ST_T3: Present_state = ST_T4;
                ST_T4: Present_state = ST_T5;
                ST_T5: Present_state = ST_T6;
                ST_T6: Present_state = ST_T7;
                ST_T7: Present_state = ST1_T0;

                ST1_T0: Present_state = ST1_T1;
                ST1_T1: Present_state = ST1_T2;
                ST1_T2: Present_state = ST1_T3;
                ST1_T3: Present_state = ST1_T4;
                ST1_T4: Present_state = ST1_T5;
                ST1_T5: Present_state = ST1_T6;
                ST1_T6: Present_state = ST1_T7;
            

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
        Mem_Read <=0; Mem_Write <=0;  Mem_enable512x32 <= 0; CONin <= 0;


        /*INIT inport and outport*/
        inport_data <=32'd0; outport_in <=0; inport_data_ready <=0;    

        mem_overide <=0; overide_address <= 9'd0; overide_data_in <= 32'd0;
      end


        /*INIT STATES: These states are for initializing the desired instruction. #TODO: add states accordingly*/
      

          Mem_load_instruction1 : begin
            overide_address <= 9'd0; //Load Desired Memory Address
            overide_data_in <= 32'b00000_0010_0000_00000000000_10010101;//load  r2, 0x95(r0)
            mem_overide <= 1;
            
            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0;
          end
          Mem_load_instruction2 : begin
            overide_address <= 9'd1; //Load Desired Memory Address
            overide_data_in <= 32'b00000_0000_0010_00000000000_00111000; //load   r0, 0x38(r2) - 38 + 13 = 4B
            
            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0;
          end 
          Mem_load_instruction3 : begin
            overide_address <= 9'd2; //Load Desired Memory Address
            overide_data_in <= 32'b00001_0010_0000_00000000000_10010101; //mv  r2, 0x95(r0)

            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0; 
          end 

          Mem_load_instruction4 : begin
            overide_address <= 9'd3; //Load Desired Memory Address
            overide_data_in <= 32'b00001_0000_0010_00000000000_00111000; //mv  r0, 0x38(r2) ==> 98 + 38 = CD

            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0; 
          end 

          Mem_load_instruction5 : begin
            overide_address <= 9'd4; //Load Desired Memory Address
            overide_data_in <= 32'b00010_0010_0000_00000000000_10000111; //store  0x87(r0), r2

            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0; 
          end 

          Mem_load_instruction6 : begin
            overide_address <= 9'd5; //Load Desired Memory Address
            overide_data_in <= 32'b00010_0000_0000_00000000000_10000111; //store  0x87(r0), r0

            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0; 
          end 


          Mem_load_data1 : begin 
            overide_address <= 9'd149; //Load Desired Memory Address (0x95)
            overide_data_in <= 32'h00000013;

            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0;
          end

          Mem_load_data2 : begin
            overide_address <= 9'd75; //Load Desired Memory Address (0x4B)
            overide_data_in <= 32'h00000014;

            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0; 


          end

          Mem_load_data3 : begin
            overide_address <= 9'd135; //Load Desired Memory Address (0x87)
            overide_data_in <= 32'h00000011;

            Mem_enable512x32 <= 1;
            #10 Mem_enable512x32 <= 0; mem_overide <= 0;

            
          end

          



        /*ld~~~~~~~~~~~~~~~~~~~~~~~~{ld  ra, C(rb)}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
          LD_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
          LD_T1: begin
                        PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                        Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                        
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
          end
          LD_T2: begin 
                        Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_Read <=0;  Mem_enable512x32<=0;          
                        
                        MDRout <= 1; IRin <= 1;                     
          end
          LD_T3: begin 
                        MDRout <= 0; IRin <= 0;                   
                        
                        Grb <= 1; Rout <= 1; BAout <= 0; Yin <= 1;                       
          end
          LD_T4: begin 
                        Rout <= 0; BAout <= 0; Yin <= 0; Grb <= 0;                    
                        
                        Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
          end
          LD_T5: begin 
                        Cout <= 0; Zin <= 0;                      
          
                        Zlo_out <= 1; MARin <= 1;
          end
          LD_T6: begin 
                        Zlo_out <= 0; MARin <= 0;                     
          
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;
          end
          LD_T7: begin 
                        MDRin <= 0; Mem_Read <= 0; Mem_enable512x32 <= 0;                     
          
                        MDRout <= 1; Gra <= 1; Rin <= 1;

                        #20 MDRout <= 0; Gra <= 0; Rin <= 0;
          end

        /*ld1~~~~~~~~~~~~~~~~~~~~~~~~{ld  ra, C(rb)}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
          LD1_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
          LD1_T1: begin
                        PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                        Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                        
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
          end
          LD1_T2: begin 
                        Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_Read <=0;  Mem_enable512x32<=0;          
                        
                        MDRout <= 1; IRin <= 1;                     
          end
          LD1_T3: begin 
                        MDRout <= 0; IRin <= 0;                   
                        
                        Grb <= 1; Rout <= 1; BAout <= 1; Yin <= 1;                       
          end
          LD1_T4: begin 
                        Rout <= 0; BAout <= 0; Yin <= 0; Grb <= 0;                    
                        
                        Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
          end
          LD1_T5: begin 
                        Cout <= 0; Zin <= 0;                      
          
                        Zlo_out <= 1; MARin <= 1;
          end
          LD1_T6: begin 
                        Zlo_out <= 0; MARin <= 0;                     
          
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;
          end
          LD1_T7: begin 
                        MDRin <= 0; Mem_Read <= 0; Mem_enable512x32 <= 0;                     
          
                        MDRout <= 1; Gra <= 1; Rin <= 1;

                        #20 MDRout <= 0; Gra <= 0; Rin <= 0;
          end

        /*ldi~~~~~~~~~~~~~~~~~~~~~~~~{ldi  ra, C(rb)}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
          LDI_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
          LDI_T1: begin
                        PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                        Zlo_out <= 1; PCin <= 1;//Capture incremented PC
          
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
          end
          LDI_T2: begin 
                        Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_Read <=0;  Mem_enable512x32<=0;          
                        
                        MDRout <= 1; IRin <= 1;                     
          end
          LDI_T3: begin 
                        MDRout <= 0; IRin <= 0;                   
                        
                        Grb <= 1; Rout <= 1; BAout <= 1; Yin <= 1;                       
          end
          LDI_T4: begin 
                        Rout <= 0; BAout <= 0; Yin <= 0; Grb <= 0;                    
                        
                        Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
          end
          LDI_T5: begin 
                        Cout <= 0; Zin <= 0;                      
          
                        Zlo_out <= 1; Gra <= 1; Rin <= 1;
                        #20 Zlo_out <= 0; Gra <= 0; Rin <= 0;
          end

        /*ld1i~~~~~~~~~~~~~~~~~~~~~~~~{ldi  ra, C(rb)}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
          LDI1_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
          LDI1_T1: begin
                        PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                        Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                        
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
          end
          LDI1_T2: begin 
                        Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_Read <=0;  Mem_enable512x32<=0;          
                        
                        MDRout <= 1; IRin <= 1;                     
          end
          LDI1_T3: begin 
                        MDRout <= 0; IRin <= 0;                   
                        
                        Grb <= 1; Rout <= 1; BAout <= 1; Yin <= 1;                       
          end
          LDI1_T4: begin 
                        Rout <= 0; BAout <= 0; Yin <= 0; Grb <= 0;                    
                        
                        Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
          end
          LDI1_T5: begin 
                        Cout <= 0; Zin <= 0;                      
          
                        Zlo_out <= 1; Gra <= 1; Rin <= 1;
                        #20 Zlo_out <= 0; Gra <= 0; Rin <= 0;
          end

        /*st~~~~~~~~~~~~~~~~~~~~~~~~{st  C(rb), ra}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
          ST_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
          ST_T1: begin
                        PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                        Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                        
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
          end
          ST_T2: begin 
                        Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_Read <=0;  Mem_enable512x32<=0;          
                        
                        MDRout <= 1; IRin <= 1;                     
          end
          ST_T3: begin 
                        MDRout <= 0; IRin <= 0;                   
                        
                        Grb <= 1; Rout <= 1; BAout <= 1; Yin <= 1;                       
          end
          ST_T4: begin 
                        Rout <= 0; BAout <= 0; Yin <= 0; Grb <= 0;                    
                        
                        Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
          end
          ST_T5: begin 
                        Cout <= 0; Zin <= 0;                      
          
                        Zlo_out <= 1; MARin <= 1;
          end
          ST_T6: begin 
                        Zlo_out <= 0; MARin <= 0;                     
          
                        MDRin <= 1; Gra <= 1; Rout <= 1; BAout <= 1;
          end
          ST_T7: begin 
                        MDRin <= 0; Gra <= 0; Rout <= 0; BAout <= 0;
                        
                        Mem_Write <= 1; Mem_enable512x32 <= 1; MDRout <= 1;

                        #20 Mem_Write <= 0; Mem_enable512x32 <= 0; MDRout <= 0;
          end

        /*st1~~~~~~~~~~~~~~~~~~~~~~~~{st  C(rb), ra}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
          ST1_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
          ST1_T1: begin
                        PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                        Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                        
                        MDRin <= 1; Mem_Read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
          end
          ST1_T2: begin 
                        Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_Read <=0;  Mem_enable512x32<=0;          
                        
                        MDRout <= 1; IRin <= 1;                     
          end
          ST1_T3: begin 
                        MDRout <= 0; IRin <= 0;                   
                        
                        Grb <= 1; Rout <= 1; BAout <= 1; Yin <= 1;                       
          end
          ST1_T4: begin 
                        Rout <= 0; BAout <= 0; Yin <= 0; Grb <= 0;                    
                        
                        Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
          end
          ST1_T5: begin 
                        Cout <= 0; Zin <= 0;                      
          
                        Zlo_out <= 1; MARin <= 1;
          end
          ST1_T6: begin 
                        Zlo_out <= 0; MARin <= 0;                     
          
                        MDRin <= 1; Gra <= 1; Rout <= 1; BAout <= 1;
          end
          ST1_T7: begin 
                        MDRin <= 0; Gra <= 0; Rout <= 0; BAout <= 0;
                        
                        Mem_Write <= 1; Mem_enable512x32 <= 1; MDRout <= 1;

                        #20 Mem_Write <= 0; Mem_enable512x32 <= 0; MDRout <= 0;
          end


    
        

    
      




    
      endcase
    end


endmodule
