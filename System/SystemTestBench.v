`timescale 1ns/10ps

module SystemTestBench;

    // Test bench parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 9;

    /*Inputs*/
    reg Clock, clear;
    reg inport_data;
    
    
    reg HIout, LOout, Zhi_out, Zlo_out, PCout, MDRout, Inport_out, Cout;
    reg MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin;
    reg outport_in, inport_data_ready;
    reg [4:0] opcode;
    reg IncPC;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    reg Mem_Read, Mem_Write, Mem_enable512x32;

    reg mem_overide; reg [ADDR_WIDTH-1:0] overide_address; reg [DATA_WIDTH-1:0] overide_data_in;


    /*Outputs*/
    wire outport_data;

    wire [DATA_WIDTH-1:0] Mem_to_datapath, Mem_data_to_chip, MAR_address;
    wire con_ff_bit;
    wire [DATA_WIDTH-1:0] register[7:0];
    wire [DATA_WIDTH-1:0] registerMDR, BusMuxOut, registerPC, registerHI, registerLO, registerIR;


    // Instantiate the System module
    System #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) UUT (
        .Clock(Clock), .clear(clear),
        .inport_data(inport_data), .outport_data(outport_data),


        .HIout(HIout), .LOout(LOout), .Zhi_out(Zhi_out), .Zlo_out(Zlo_out), .PCout(PCout), .MDRout(MDRout), .Inport_out(Inport_out), .Cout(Cout),
        .MARin(MARin), .Zin(Zin), .PCin(PCin), .MDRin(MDRin), .IRin(IRin), .Yin(Yin), .HIin(HIin), .LOin(LOin),
        .outport_in(outport_in), .inport_data_ready(inport_data_ready),
        .opcode(opcode), .IncPC(IncPC),
        .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout),
        .con_ff_bit(con_ff_bit),
        .Mem_Read(Mem_Read), .Mem_Write(Mem_Write), .Mem_enable512x32(Mem_enable512x32),
        .Mem_to_datapath(Mem_to_datapath), .Mem_data_to_chip(Mem_data_to_chip), .MAR_address(MAR_address), 


        .register(register), .registerMDR(registerMDR), .BusMuxOut(BusMuxOut), .registerPC(registerPC), .registerHI(registerHI), .registerLO(registerLO), .registerIR(registerIR),
        .mem_overide(mem_overide), .overide_address(overide_address), .overide_data_in(overide_data_in)
    );


    parameter Default = 6'd0, Mem_load_instruction1 = 6'd1, Mem_load_instruction2 = 6'd2, 
              Mem_load_data1 = 6'd3, Mem_load_data2 = 6'd4, 
              
            
              ADDi_T0 = 6'd10, ADDi_T1 = 6'd11, ADDi_T2 = 6'd12, ADDi_T3 = 6'd13, ADDi_T4 = 6'd14, ADDi_T5 = 6'd15,
              ANDi_T0 = 6'd20, ANDi_T1 = 6'd21, ANDi_T2 = 6'd22, ANDi_T3 = 6'd23, ANDi_T4 = 6'd24, ANDi_T5 = 6'd25;
              ORi_T0 = 6'd30, ORi_T1 = 6'd31, ORi_T2 = 6'd32, ORi_T3 = 6'd33, ORi_T4 = 6'd34, ORi_T5 = 6'd35;

    reg [5:0] Present_state = Default;



    /*Clock generation*/
      initial begin
          Clock = 0;
          forever #10 Clock = ~Clock; // Toggle clock every 10 ns
      end
      always @(posedge Clock) // finite state machine; if clock rising-edge
        begin
            case (Present_state)
                Default : Present_state = Reg_load1a;
                Reg_load1a : Present_state = Reg_load1b;
                Reg_load1b : Present_state = Reg_load2a;
                Reg_load2a : Present_state = Reg_load2b;
                Reg_load2b : Present_state = Reg_load3a;
                Reg_load3a : Present_state = Reg_load3b;
                Reg_load3b : Present_state = ADD_T0;


                ADD_T0: Present_state = ADD_T1;
                ADD_T1: Present_state = ADD_T2;
                ADD_T2: Present_state = ADD_T3;
                ADD_T3: Present_state = ADD_T4;
                ADD_T4: Present_state = ADD_T5;
                ADD_T5: Present_state = SUB_T0; // Example transition to next operation

                SUB_T0: Present_state = SUB_T1;
                SUB_T1: Present_state = SUB_T2;
                SUB_T2: Present_state = SUB_T3;
                SUB_T3: Present_state = SUB_T4;
                SUB_T4: Present_state = SUB_T5;


            

          endcase
      end


  always @(Present_state) begin
    case (Present_state) // assert the required signals in each clock cycle
      Default: begin
        
        clear <= 0;
        HIout <=0;<=0; LOout<=0; Zhi_out<=0; Zlo_out<=0; PCout<=0; MDRout<=0; Inport_out<=0; Cout<=0;
        MARin<=0; Zin <=0; PCin <=0; MDRin <=0; IRin <=0; Yin <=0; HIin <=0; LOin <=0; 
        opcode <= 5'd0; IncPC <= 0;
        Gra <=0; Grb <=0; Grc <=0; Rin <=0; Rout <=0; BAout <=0;
        Mem_Read <=0; Mem_Write <=0;  Mem_enable512x32 <= 0;


        /*INIT inport and outport*/
        inport_data <=32'd0; outport_in <=0; inport_data_ready <=0;    

        mem_overide <=0; overide_address <= 9'd0; overide_data_in <= 32'd0;
      end


      /*INIT STATES: These states are for initializing the desired instruction. #TODO: add states accordingly*/
      

      Mem_load_instruction1 : begin
        overide_address <= 9'd0; //Load Desired Memory Address
        overide_data_in <= 32'h00000010;
        mem_overide <= 1;
      end
      Mem_load_instruction2 : begin
        overide_address <= 9'd1; //Load Desired Memory Address
        overide_data_in <= 32'h00000014;
        mem_overide <= 1; 

        #20 mem_overide <= 0;    
      end 
      Mem_load_data1 begin :
        overide_address <= 9'd500; //Load Desired Memory Address
        overide_data_in <= 32'h00000014;
        mem_overide <= 1; 
      end

      Mem_load_data2 begin :
        overide_address <= 9'd501; //Load Desired Memory Address
        overide_data_in <= 32'h00000014;
        mem_overide <= 1; 
      end

      



      /*ADDi~~~~~~~~~~~~~~~~~~~~~~~~{addi  ra, rb, C}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        ADDi_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
        ADDi_T1: begin
                      PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                      Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                      
                      Read <= 1; MDRin <= 1; Mem_read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
        end
        ADDi_T2: begin 
                      Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_read <=0;  Mem_enable512x32<=0;          
                      
                      MDRout <= 1; IRin <= 1;                     
        end
        ADDi_T3: begin 
                      MDRout <= 0; IRin <= 0;                   
                      
                      Grb <= 1; Rout <= 1; Yin <= 1;                       
        end
        ADDi_T4: begin 
                      Rout <= 0; Yin <= 0; Grb <= 0;                    
                      
                      Cout <= 1; Zin <= 1; opcode <= 5'b00011;//ADD
        end
        ADDi_T5: begin 
                      Cout <= 0; Zin <= 0;                      
        
                      Zlo_out <= 1; Rin <= 1; Gra <= 1;
        end

      /*ADDi~~~~~~~~~~~~~~~~~~~~~~~~{andi  ra, rb, C}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        ANDi_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
        ANDi_T1: begin
                      PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                      Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                      
                      Read <= 1; MDRin <= 1; Mem_read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
        end
        ANDi_T2: begin 
                      Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_read <=0;  Mem_enable512x32<=0;          
                      
                      MDRout <= 1; IRin <= 1;                     
        end
        ANDi_T3: begin 
                      MDRout <= 0; IRin <= 0;                   
                      
                      Grb <= 1; Rout <= 1; Yin <= 1;                       
        end
        ANDi_T4: begin 
                      Rout <= 0; Yin <= 0; Grb <= 0;                    
                      
                      Cout <= 1; Zin <= 1; opcode <= 5'b01011;//ADD
        end
        ANDi_T5: begin 
                      Cout <= 0; Zin <= 0;                      
        
                      Zlo_out <= 1; Rin <= 1; Gra <= 1;
        end

      /*ORi~~~~~~~~~~~~~~~~~~~~~~~~{ori  ra, rb, C}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        ORi_T0: begin Zlo_out <= 0; Rin <= 0;  Gra <= 0;               PCout <= 1; IncPC <= 1; MARin <= 1; Zin <= 1;/*Get instruction form mem*/ end
        ORi_T1: begin
                      PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                      Zlo_out <= 1; PCin <= 1;//Capture incremented PC
                      
                      Read <= 1; MDRin <= 1; Mem_read <= 1; Mem_enable512x32 <= 1;//recieving instruction from memory
        end
        ORi_T2: begin 
                      Zlo_out <= 0; PCin <= 0;  MDRin <= 0; Mem_read <=0;  Mem_enable512x32<=0;          
                      
                      MDRout <= 1; IRin <= 1;                     
        end
        ORi_T3: begin 
                      MDRout <= 0; IRin <= 0;                   
                      
                      Grb <= 1; Rout <= 1; Yin <= 1;                       
        end
        ORi_T4: begin 
                      Rout <= 0; Yin <= 0; Grb <= 0;                    
                      
                      Cout <= 1; Zin <= 1; opcode <= 5'b01010;//ADD
        end
        ORi_T5: begin 
                      Cout <= 0; Zin <= 0;                      
        
                      Zlo_out <= 1; Rin <= 1; Gra <= 1;
        end
    
      




    
      endcase
    end


endmodule