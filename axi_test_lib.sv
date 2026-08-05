class axi_test_lib extends uvm_test;
`uvm_component_utils(axi_test_lib)
axi_env_config cfg;
master_config m_cfg[];
slave_config sl_cfg[];
bit has_slave_agent=1;
bit has_master_agent=1;
int no_of_master=1;
int no_of_slave=1;
int has_scoreboard=1;
int has_virtual_sequencer=1;
axi_env env;

extern function new(string name="axi_test_lib",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);
//extern task run_phase(uvm_phase);

endclass

function axi_test_lib:: new(string name="axi_test_lib",uvm_component parent);
	super.new(name,parent);
endfunction

function void axi_test_lib:: build_phase(uvm_phase phase);
	sl_cfg=new[no_of_slave];
	m_cfg=new[no_of_master];
	cfg=axi_env_config::type_id::create("cfg");
	cfg.slv_cfg_h=new[no_of_slave];
	cfg.mst_cfg_h=new[no_of_master];
if(has_master_agent)
begin
	foreach(m_cfg[i])
	begin
		m_cfg[i]=master_config::type_id::create($sformatf("m_cfg[%0d]",i));
		if(!uvm_config_db #(virtual axi_if)::get(this,"","axi_if",m_cfg[i].mif))
			`uvm_fatal("axi_test_lib","cannot get config data");
		m_cfg[i].is_active=UVM_ACTIVE;
		cfg.mst_cfg_h[i]=m_cfg[i];
	end
end

if(has_slave_agent)
begin
	foreach(sl_cfg[i])
	begin
		sl_cfg[i]=slave_config::type_id::create($sformatf("sl_cfg[%0d]",i));
if(!uvm_config_db #(virtual axi_if)::get(this,"","axi_if",sl_cfg[i].sif))
			`uvm_fatal("axi_test_lib","cannot get config data");
		sl_cfg[i].is_active=UVM_ACTIVE;
		cfg.slv_cfg_h[i]=sl_cfg[i];
	end
end

env=axi_env::type_id::create("env",this);
        cfg.has_slave_agent=has_slave_agent;
        cfg.has_master_agent=has_master_agent;
	cfg.no_of_master=no_of_master;
	cfg.no_of_slave=no_of_slave;
	cfg.has_scoreboard=has_scoreboard;
	cfg.has_virtual_sequencer=has_virtual_sequencer;
	uvm_config_db#(axi_env_config)::set(this,"*","axi_env_config",cfg);
	super.build_phase(phase);
endfunction
function void axi_test_lib::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  `uvm_info("TOPOLOGY", "Printing UVM Topology", UVM_LOW)
  uvm_top.print_topology();
endfunction
////////////////////////////////////////////////////////////////////

class axi_extd_test extends axi_test_lib;
`uvm_component_utils(axi_extd_test)
axi_seqs_2 v_seq;
extern function new(string name="axi_extd_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function axi_extd_test::new(string name="axi_extd_test",uvm_component parent);
super.new(name,parent);
endfunction

function void axi_extd_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task axi_extd_test::run_phase(uvm_phase phase);
phase.raise_objection(this);
v_seq=axi_seqs_2::type_id::create("v_seq");
v_seq.start(env.vseqr_h);
phase.drop_objection(this);
endtask
////////////////////////////////////////////////////////////////////
class axi_extd_test1 extends axi_test_lib;
`uvm_component_utils(axi_extd_test1)
axi_seqs_3 v_seq;
extern function new(string name="axi_extd_test1",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function axi_extd_test1::new(string name="axi_extd_test1",uvm_component parent);
super.new(name,parent);
endfunction

function void axi_extd_test1::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task axi_extd_test1::run_phase(uvm_phase phase);
phase.raise_objection(this);
v_seq=axi_seqs_3::type_id::create("v_seq");
v_seq.start(env.vseqr_h);
phase.drop_objection(this);
endtask
////////////////////////////////////////////////////////////////////
class axi_extd_test2 extends axi_test_lib;
`uvm_component_utils(axi_extd_test2)
axi_seqs_4 v_seq;
extern function new(string name="axi_extd_test2",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function axi_extd_test2::new(string name="axi_extd_test2",uvm_component parent);
super.new(name,parent);
endfunction

function void axi_extd_test2::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task axi_extd_test2::run_phase(uvm_phase phase);
phase.raise_objection(this);
v_seq=axi_seqs_4::type_id::create("v_seq");
v_seq.start(env.vseqr_h);
phase.drop_objection(this);
endtask
////////////////////////////////////////////////////////////////////
/*
class axi_extd_test3 extends axi_test_lib;
`uvm_component_utils(axi_extd_test3)
axi_seqs_5 v_seq;
extern function new(string name="axi_extd_test3",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function axi_extd_test3::new(string name="axi_extd_test3",uvm_component parent);
super.new(name,parent);
endfunction

function void axi_extd_test3::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task axi_extd_test3::run_phase(uvm_phase phase);
phase.raise_objection(this);
v_seq=axi_seqs_5::type_id::create("v_seq");
v_seq.start(env.vseqr_h);
phase.drop_objection(this);
endtask*/
////////////////////////////////////////////////////////////////////
/*
class axi_extd_test4 extends axi_test_lib;
`uvm_component_utils(axi_extd_test4)
axi_seqs_6 v_seq;
extern function new(string name="axi_extd_test4",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function axi_extd_test4::new(string name="axi_extd_test4",uvm_component parent);
super.new(name,parent);
endfunction

function void axi_extd_test4::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task axi_extd_test4::run_phase(uvm_phase phase);
phase.raise_objection(this);
v_seq=axi_seqs_6::type_id::create("v_seq");
v_seq.start(env.v_seqr);
phase.drop_objection(this);
endtask
*/
////////////////////////////////////////////////////////////////////