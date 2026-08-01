class slave_agent_top extends uvm_component;
   
   `uvm_component_utils(slave_agent_top)
   //declaraing handles for config and agent
   master_config scfg_h;
   master_agent sagt_h[];
   
   //function new
   function new(string name = "slave_agent_top", uvm_component parent);
        super.new(name,parent);
	endfunction
	
	//build phase
	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	    scfg_h = master_config::type_id::create("scfg_h");
		if(!uvm_config_db#(master_config)::get(this,"","master_config",scfg_h);
		  `uvm_fatal(get_type_name(),"config file not received by master agent")
		sagt_h = new[scfg_h.no_of_slaves];
		foreach(magt_h[i])
		     sagt_h[i]=slave_agent::type_id::create($sformatf("sagt_h[%0d]",i,this));
	endfunction
	
	endclass