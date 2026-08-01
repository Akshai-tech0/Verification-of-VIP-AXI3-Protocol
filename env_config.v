class axi_env_cfg extends uvm_object;

  `uvm_object_utils(axi_env_cfg)
  
  bit has_scoreboard = 1;
  bit has_virtual_sequencer = 1;
  bit has_master_agent = 1;
  bit has_slave_agent = 1;
  
  int no_of_masters = 1;
  int no_of_slaves = 1;
  
  master_config mcfg_h;
  slave_config scfg_h;
  
  function new (string name = "axi_env_cfg");
       super.new(name);
	endfunction
	
endclass