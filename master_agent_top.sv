class master_agent_top extends uvm_env;
`uvm_component_utils(master_agent_top)

master_config mst_cfg_h;
master_agent m_agth[];

extern function new(string name="master_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass

function master_agent_top::new(string name="master_agent_top",uvm_component parent);
super.new(name,parent);
endfunction


function void master_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);

	mst_cfg_h=master_config::type_id::create("mst_cfg_h");

	if(!(uvm_config_db#(master_config)::get(this,"","master_config",mst_cfg_h)))
		`uvm_error("Master Agent Top","Unable to get master config,have you set it?");

	m_agth=new[mst_cfg_h.no_of_master];

	foreach(m_agth[i])
		m_agth[i]=master_agent::type_id::create($sformatf("m_agth[%0d]",i),this);
        
endfunction


function void master_agent_top::report_phase(uvm_phase phase);
//uvm_top.print_topology();
endfunction