class master_agent_top extends uvm_component;
   
   `uvm_component_utils(master_agent_top)
   //declaraing handles for config and agent
   master_config mcfg_h;
   master_agent magt_h[];
   
   //function new
   function new(string name = "master_agent_top", uvm_component parent);
        super.new(name,parent);
	endfunction
	
	//build phase
	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	    mcfg_h = master_config::type_id::create("mcfg_h");
		if(!uvm_config_db#(master_config)::get(this,"","master_config",mcfg_h);
		  `uvm_fatal(get_type_name(),"config file not received by master agent")
		magt_h = new[mcfg_h.no_of_masters];
		foreach(magt_h[i])
		     magt_h[i]=master_agent::type_id::create($sformatf("magt_h[%0d]",i,this));
	endfunction
	
	endclass