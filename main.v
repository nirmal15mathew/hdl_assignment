module main();
reg a, b, cin;
wire sum, cout;

full_adder fa(sum, cout, a, b, cin);

initial begin
#10 a = 0; b = 0; cin = 0;
#10 a = 0; b = 0; cin = 1;
#10 a = 0; b = 1; cin = 0;
#10 a = 0; b = 1;cin = 1;
#10 a = 1; b = 0; cin = 0;
#10 a = 1;b = 0; cin = 1;
#10 a = 1;b = 1; cin = 0;
#10 a = 1;b = 1; cin = 1;
end

initial begin
$monitor("a=%d, b=%d, cin=%d, sum=%d, cout=%d", a, b, cin, sum, cout);
#120 $finish;
end

endmodule;