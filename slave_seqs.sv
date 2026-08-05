class slave_seqs extends uvm_sequence #(axi_transaction);

      `uvm_object_utils(slave_seqs)
 
       function new(string name = "slave_seqs");
                 super.new(name);
       endfunction
endclass
class slave_seqs1 extends slave_seqs;

      `uvm_object_utils(slave_seqs1)
 
       function new(string name = "slave_seqs1");
                 super.new(name);
       endfunction

       task body();

               req=axi_transaction::type_id::create("req");
               start_item(req);
               assert(req.randomize());
               finish_item(req);
       endtask  
endclass       