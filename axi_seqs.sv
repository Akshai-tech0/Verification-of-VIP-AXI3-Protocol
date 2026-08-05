class axi_seqs extends uvm_sequence #(uvm_sequence_item);

      `uvm_object_utils(axi_seqs)

       master_sequencer mst_seqrh[];
       slave_sequencer slv_seqrh[];
       
       axi_sequencer v_seqrh;
       axi_env_config m_cfg;

       extern function new(string name="axi_seqs");
       extern task body();

endclass

      function axi_seqs::new(string name="axi_seqs");
	super.new(name);
      endfunction

     task axi_seqs::body();

	if(!uvm_config_db #(axi_env_config)::get(null,get_full_name(),"axi_env_config",m_cfg))
	   `uvm_fatal("CONFIG","cannot get e_cfg have you set it?");

        	mst_seqrh=new[m_cfg.no_of_master];
	        slv_seqrh=new[m_cfg.no_of_slave];

	        if(!$cast(v_seqrh,m_sequencer))
		`uvm_error("BODY","CASTING FAILED")

	   foreach(mst_seqrh[i])
         	mst_seqrh[i]=v_seqrh.mst_seqrh[i];

	   foreach(slv_seqrh[i])
	        slv_seqrh[i]=v_seqrh.slv_seqrh[i];
endtask
//////////////////////////////////////////////////////////////////////////////////////////////

class axi_seqs_2 extends axi_seqs;
`uvm_object_utils(axi_seqs_2)
master_seq_fixed m1;
//slave_seqs1 sl1;
extern function new(string name="axi_seqs_2");
extern task body();
endclass

function axi_seqs_2::new(string name="axi_seqs_2");
super.new(name);
endfunction

task axi_seqs_2::body();
super.body();
m1=master_seq_fixed::type_id::create("m1");
//sl1=slave_seqs1::type_id::create("sl1");
        fork
          m1.start(mst_seqrh[0]);
        join

//foreach(mst_seqrh[i])
//m1.start(mst_seqrh[i]);
//foreach(slv_seqrh[i])
//sl1.start(slv_seqrh[i]);
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
class axi_seqs_3 extends axi_seqs;
`uvm_object_utils(axi_seqs_3)
master_seq_incr m2;
//slave_seqs3 sl1;
extern function new(string name="axi_seqs_3");
extern task body();
endclass

function axi_seqs_3::new(string name="axi_seqs_3");
super.new(name);
endfunction

task axi_seqs_3::body();
super.body();
m2=master_seq_incr::type_id::create("m2");
//sl1=slave_seqs::type_id::create("sl1");
 //fork
   //        m2.start(mst_seqrh[0]);
     //   join
foreach(mst_seqrh[i])
m2.start(mst_seqrh[i]);


//foreach(slv_seqrh[i])
//sl1.start(slv_seqrh[i]);

endtask
/////////////////////////////////////////////////////////////////////////////////////////////////
class axi_seqs_4 extends axi_seqs;
`uvm_object_utils(axi_seqs_4)
master_seq_wrap m3;
//slave_seqs4 sl1;
extern function new(string name="axi_seqs_4");
extern task body();
endclass

function axi_seqs_4::new(string name="axi_seqs_4");
super.new(name);
endfunction

task axi_seqs_4::body();
super.body();
m3=master_seq_wrap::type_id::create("m3");
//sl1=slave_seqs::type_id::create("sl1");
 // fork
   //        m3.start(mst_seqrh[0]);
     //   join

foreach(mst_seqrh[i])
m3.start(mst_seqrh[i]);

//foreach(slv_seqrh[i])
//sl1.start(slv_seqrh[i]);
endtask

/////////////////////////////////////////////////////////////////////////////////

/*class axi_seqs_5 extends axi_seqs;
`uvm_object_utils(axi_seqs_5)
master_seq_random m4;
//slave_seqs5 sl1;
extern function new(string name="axi_seqs_5");
extern task body();
endclass

function axi_seqs_5::new(string name="axi_seqs_5");
super.new(name);
endfunction

task axi_seqs_5::body();
super.body();
m4=master_seq_random::type_id::create("m4");
//sl1=slave_seqs::type_id::create("sl1");
  //fork
    //       m4.start(mst_seqrh[0]);
   //join
foreach(mst_seqrh[i])
m4.start(mst_seqrh[i]);


endtask

*/
////////////////////////////////////////////////////////////////////////////////
/*
class axi_seqs_6 extends axi_seqs;
`uvm_object_utils(axi_seqs_6)
master_seqs5 m5;
//slave_seqs5 sl1;
extern function new(string name="axi_seqs_6");
extern task body();
endclass

function axi_seqs_6::new(string name="axi_seqs_6");
super.new(name);
endfunction

task axi_seqs_6::body();
super.body();
m5=master_seqs5::type_id::create("m5");
//sl1=slave_seqs::type_id::create("sl1");
  fork
           m5.start(mst_seqrh[0]);
   join
endtask
*/
////////////////////////////////////////////////////////////////////////////////