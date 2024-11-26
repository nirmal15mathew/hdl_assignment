module full_adder(sum, cout, a, b, cin);

input a, b, cin;
output reg sum, cout;

initial begin
sum <= 0;
cout <=0;
end

always@(*) begin
case({a, b, cin})
	3'b011, 3'b101, 3'b110: begin
	sum <= 0;
	cout <= 1; 
	end
	3'b000: begin 
	sum <= 0;
	cout <= 0;
	end
	3'b001, 3'b010, 3'b100, 3'b111: sum <= 1;
	3'b111: cout <= 1;
	endcase
end

endmodule