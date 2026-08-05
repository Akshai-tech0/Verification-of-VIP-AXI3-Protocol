class slave_agent_top extends uvm_env;
`uvm_component_utils(slave_agent_top)

slave_config slv_cfg_h;
slave_agent s_agth[];

extern function new(string name="slave_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass

function slave_agent_top::new(string name="slave_agent_top",uvm_component parent);
super.new(name,parent);
endfunction


function void slave_agent_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
      slv_cfg_h=slave_config::type_id::create("slv_cfg_h");

      if(!(uvm_config_db#(slave_config)::get(this,"","slave_config",slv_cfg_h)))
        `uvm_error("Slave Agent Top","Unable to get slave config,have you set it?");

	   s_agth=new[slv_cfg_h.no_of_slave];
        foreach(s_agth[i])
	    s_agth[i]=slave_agent::type_id::create($sformatf("s_agth[%0d]",i),this);

        
endfunction


function void slave_agent_top::report_phase(uvm_phase phase);
//uvm_top.print_topology();
endfunction