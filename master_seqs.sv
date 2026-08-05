class master_base_seqs extends uvm_sequence #(axi_transaction);
   
   `uvm_object_utils(master_base_seqs)

function new(string name="master_base_seqs");
  super.new(name);
endfunction

endclass

class master_seq_fixed extends master_base_seqs;
   `uvm_object_utils(master_seq_fixed)

function new(string name="master_seq_fixed");
    super.new(name);
endfunction

task body();
 
     repeat(50)
            begin
                req=axi_transaction::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {AWBURST==0;ARBURST==0;})
                finish_item(req);

            end
endtask

endclass

class master_seq_incr extends master_base_seqs;
   `uvm_object_utils(master_seq_incr)

function new(string name="master_seq_incr");
    super.new(name);
endfunction

task body();
 
     repeat(50)
            begin
                req=axi_transaction::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {AWBURST==1;ARBURST=1;})
                finish_item(req);

            end
endtask

endclass

class master_seq_wrap extends master_base_seqs;
   `uvm_object_utils(master_seq_wrap)

function new(string name="master_seq_wrap");
    super.new(name);
endfunction

task body();
 
     repeat(50)
            begin
                req=axi_transaction::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {AWBURST==2;ARBURST=2;})
                finish_item(req);

            end
endtask

endclass
