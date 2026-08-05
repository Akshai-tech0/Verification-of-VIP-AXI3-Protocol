class master_config extends uvm_object;
  
  `uvm_object_utils(master_config)

virtual axi_if mif;

uvm_active_passive_enum is_active=UVM_ACTIVE;

int no_of_master=1;

function new(string name="master_config");
   super.new(name); 
endfunction

endclass
