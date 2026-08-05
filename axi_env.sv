
class axi_env extends uvm_env;
`uvm_component_utils(axi_env)
axi_env_config m_cfg;
master_agent_top mst_agt_top;
slave_agent_top slv_agt_top;
axi_sequencer vseqr_h;
axi_scoreboard sb_h;

extern function new(string name="axi_env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);


endclass

//new method
	function axi_env:: new(string name="axi_env",uvm_component parent);
	super.new(name,parent);
	endfunction

//build phase method
	function void axi_env:: build_phase(uvm_phase phase);

	if(!uvm_config_db#(axi_env_config)::get(this,"*","axi_env_config",m_cfg))
	`uvm_fatal("AXI_ENV","unable to get axi env config , have you set it in test?")

	if(m_cfg.has_master_agent) 
	begin
	foreach(m_cfg.mst_cfg_h[i])
	uvm_config_db#(master_config)::set(this,"mst_agt_top*","master_config",m_cfg.mst_cfg_h[i]);
		mst_agt_top=master_agent_top::type_id::create("mst_agt_top",this);
	end

	if(m_cfg.has_slave_agent) 
	begin
	foreach(m_cfg.slv_cfg_h[i])
		uvm_config_db#(slave_config)::set(this,"slv_agt_top*","slave_config",m_cfg.slv_cfg_h[i]);
		slv_agt_top=slave_agent_top::type_id::create("slv_agt_top",this);
	end

	if(m_cfg.has_virtual_sequencer)
		vseqr_h=axi_sequencer::type_id::create("vseqr_h",this);

	if(m_cfg.has_scoreboard)
		sb_h=axi_scoreboard::type_id::create("sb_h",this);

	super.build_phase(phase);

	endfunction

//connect phase method
	function void axi_env:: connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(m_cfg.has_virtual_sequencer)
				begin
					foreach(vseqr_h.mst_seqrh[i])
			    		vseqr_h.mst_seqrh[i]=mst_agt_top.m_agth[i].seqrh;
			
					foreach(vseqr_h.slv_seqrh[i])
			    		vseqr_h.slv_seqrh[i]=slv_agt_top.s_agth[i].seqrh;
				end

		if(m_cfg.has_scoreboard)
		begin
			foreach(mst_agt_top.m_agth[i])
			   mst_agt_top.m_agth[i].monh.monitor_port.connect(sb_h.mst_fifo_h[i].analysis_export);
			foreach(slv_agt_top.s_agth[i])
			   slv_agt_top.s_agth[i].monh.slave_port.connect(sb_h.slv_fifo_h[i].analysis_export);
		end


	endfunction