class slave_config extends uvm_object;
  
  `uvm_object_utils(slave_config)
   
   virtual axi_if mif;
   
   uvm_active_passive_enum is_active;
   int no_of_slaves = 1;
   
   function new (string name = "slave_config");
       super.new(name);
	endfunction
	
endclass