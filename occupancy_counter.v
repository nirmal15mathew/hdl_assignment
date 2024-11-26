module occupancy_counter(enter, exit, a, b, clk, rst);

input a, b, clk, rst;
output reg enter, exit;

localparam [2: 0] NO_OBJECT = 3'b000, ENTRY = 3'b001, MOVING = 3'b010, EXIT = 3'b011;

reg [2: 0] current_state, next_state;

always@(posedge clk, posedge rst) begin
  if (rst)
    current_state = NO_OBJECT;
  else
    current_state = next_state;
end

always@* begin
next_state = current_state;
enter = 1'b0;
exit = 1'b0;
    case(current_state)
        NO_OBJECT: begin
            if (a & ~b)
                next_state = ENTRY;
            if (b & ~a)
                next_state = EXIT;
            end
        ENTRY: begin
            if (a & b) begin
                enter <= 1'b1;
                next_state = MOVING;
            end
            if (~a) begin
                next_state = NO_OBJECT;
            end
        end
        MOVING: begin
            if (a & ~b)
                next_state = EXIT;
            else if (~a & b)
                next_state = ENTRY;
        end
        EXIT: begin
            if (~b) begin
                next_state = NO_OBJECT;
            end
            else if (a & b) begin
                exit <= 1'b1;
                next_state = MOVING;
            end
        end
endcase
end

endmodule


module car_counter#(parameter size=4)(count, inc, dec, rst);
input inc, dec, rst;
output reg [size - 1: 0] count;

always@(rst, inc, dec) begin
    if (rst)
        count <= 0;
    if (inc)
        count <= count + 1;
    else if (dec)
        count <= count - 1;
end

endmodule

module main();

reg a, b, clk, rst;
wire entry, exit;
wire [3: 0] car_count;
occupancy_counter oc(entry, exit, a, b, clk ,rst);
car_counter cc(car_count, entry, exit, rst);

initial begin
rst <= 1'b0;
clk <= 1'b0;
a <= 1'b0;
b <= 1'b0;

// testing entry
#5 rst <= 1'b1;
#5 rst <= 1'b0;
#10 a <= 1'b1;
#10 b <= 1'b1;
#10 a <= 1'b0;
#10 b <= 1'b0;

// testing exit
#10 b <= 1'b1;
#10 a <= 1'b1;
#10 b <= 1'b0;
#10 a <= 1'b0;

//
#10 a <= 1'b1;
#10 b <= 1'b1;
#10 a <= 1'b0;

#40 $finish;
end

initial begin
    forever
        #2 clk = ~clk;
end

initial begin
    $dumpfile("occupancy.vcd");
    $dumpvars(0, main);
end

endmodule