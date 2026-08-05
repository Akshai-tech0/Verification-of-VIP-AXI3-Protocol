
module axi_top;

import test_pkg::*;
import uvm_pkg::*;


bit clk;
always #5 clk=~clk;

axi_if axi_if0(clk);

initial
	begin
	
	uvm_config_db #(virtual axi_if)::set(null,"*","axi_if",axi_if0);
	run_test();
	
	end
endmodule