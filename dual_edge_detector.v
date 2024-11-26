module dual_edge_detector(tick, signal, clk, rst);

input clk, rst, signal;
output reg tick;


localparam [1: 0] LOW = 2'b00, POS_EDGE = 2'b01, NEG_EDGE = 2'b10, HIGH=2'b11;

reg [1: 0] state_current, next_state;

always@(posedge clk or posedge rst) begin
  if (rst)
    state_current = LOW;
  else
    state_current = next_state;

end

always@* begin
tick <= 0;
case (state_current)
    LOW: begin
        if (signal)
            next_state = POS_EDGE;
        else
            next_state = LOW;
    end
    POS_EDGE: begin
        tick  <= 1'b1;
        if (signal)
            next_state = HIGH;
        else
            next_state = NEG_EDGE;
    end
    NEG_EDGE: begin
        tick <= 1'b1;
        if (signal)
            next_state = POS_EDGE;
        else
            next_state = LOW;
    end        
    HIGH: begin
        if (signal)
            next_state = HIGH;
        else
            next_state = NEG_EDGE;
    end
    default: next_state = LOW;
endcase
end

endmodule


module dual_edge_detector_mealy(tick, signal, clk, rst);

input signal, clk, rst;
output reg tick;

reg state_current, next_state;

localparam LOW = 0, HIGH = 1;

always@(posedge clk or posedge rst) begin
    if (rst) 
        state_current = LOW;
    else
        state_current = next_state;
end
always@* begin
tick <= 0;
next_state = state_current;
    case(state_current)
        LOW: begin
            if (signal)
                next_state = HIGH;
                tick <= 1;
        end
        HIGH: begin
            if (~signal)
                next_state = LOW;
                tick <= 1;
        end
    endcase
end

endmodule



module main();

reg clk, rst, signal;
wire tick;

dual_edge_detector_mealy d1(tick, signal, clk, rst);

initial begin

rst <= 1;
clk <= 0;
signal <= 0;
#10 rst <= 0;
#30 signal <= 1'b1;
#20 signal <= 1'b0;


#1000 $finish;
end

initial begin
forever
    #5 clk = ~clk;
end


initial begin

    $dumpfile("dual_edge.vcd");
    $dumpvars(0, main);
end

endmodule