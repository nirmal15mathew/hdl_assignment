module alternative_debouncer(out, in, clk, rst);

input in, clk, rst;
output reg out;

localparam [2: 0] zero = 3'b000, wait_0 = 3'b001, wait_1 = 3'b010, one = 3'b011;

// number of counter bits (2"N * 2Ons = lOms tick) 
localparam N =5; 
// signal declaration 
reg [N-1: 0] q_reg; 
wire [N-1 : 0] q_next; 
wire m_tick; 

reg [2:0] state_reg , state_next; 

always @ (posedge clk or posedge rst)  begin
    q_reg <= q_next;
    if (rst)
        q_reg <= 0;
end        
assign q_next = q_reg + 1; 
assign m_tick = (q_reg==0) ? 1'b1 : 1'b0;


always@(posedge clk, posedge rst) begin
    if (rst) 
        state_reg = zero;
    else
        state_reg = state_next;
end


always@* begin
state_next = state_reg;

case (state_reg)
    zero: begin
        out = 1'b0;
        if (in & m_tick)
            state_next = one;
        else
            state_next = state_reg;
        end
    wait_1: begin
        if (~in & m_tick)
            state_next = zero;
        end
    one: begin
        out = 1'b1;
        if (in & m_tick) state_next = state_reg;
        else begin
            state_next = wait_1;
        end
    end
    default:
        state_next = zero;
endcase
end

endmodule


module main();
reg in, clk, rst;
wire outp, out2;


alternative_debouncer d1(outp, in, clk, rst);
db_fsm f1(out2, in, clk, rst);

initial begin
clk <= 0;
rst <= 0;
in <= 0;

#10 rst <= 1;
#2 rst <= 0;
#20 in <= 1;
#80 in <= 0;

#10 in <= 1;
#2 in <= 0;
#2 in <= 1;
#4 in <= 0;
#5 in <= 1;
#30 in <= 0;
#2 in <= 1;
#1 in <= 0;
#3 in <= 1;
#2 in <= 0;

#50 $finish;
end

initial begin

forever begin
#1 clk = ~clk;
end
end

initial begin
    $dumpfile("debouncer.vcd");
    $dumpvars(0, main);
end

endmodule

