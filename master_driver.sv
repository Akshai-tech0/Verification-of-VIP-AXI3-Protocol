class master_driver extends uvm_driver #(axi_transaction);

`uvm_component_utils(master_driver)

virtual axi_if.AXI_MDRV mif;
master_config mst_cfg_h;
axi_transaction xtn;

axi_transaction q1[$], q2[$], q3[$], q4[$], q5[$];

	semaphore sem_awdc = new();//write data dependency
        semaphore sem_wdrc = new();//write resp dependency
        semaphore sem_wdc = new(1);//write data
        semaphore sem_awc = new(1);//write addr
        semaphore sem_wrc = new(1);//write resp

       semaphore sem_ardc = new();//read data dependency
       semaphore sem_arc = new(1);//read addr
       semaphore sem_rdc = new(1);//read data

    extern function new(string name = "master_driver", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
        extern task  run_phase(uvm_phase phase);
        extern task drive(axi_transaction xtn);
        extern task drive_awaddr(axi_transaction xtn);
        extern task drive_wdata(axi_transaction xtn);
        extern task drive_bresp(axi_transaction xtn);
	extern task drive_raddr(axi_transaction xtn);
        extern task drive_rdata(axi_transaction xtn);
endclass


function master_driver::new(string name="master_driver", uvm_component parent);
	super.new(name,parent);
endfunction


function void master_driver::build_phase(uvm_phase phase);
	 if(!uvm_config_db#(master_config)::get(this, "", "master_config", mst_cfg_h))
            `uvm_fatal("Master Driver", "getting config failed");
            super.build_phase(phase);		
endfunction


 function void master_driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
     mif=mst_cfg_h.mif;
 endfunction


 task master_driver::run_phase(uvm_phase phase);
              //  $display("here inside driver's run phase");
                forever
                begin
                        seq_item_port.get_next_item(req);
                        drive(req);
                //      #10;
                        seq_item_port.item_done();

                req.print();
                end
 endtask


task master_driver::drive(axi_transaction xtn);
        q1.push_back(xtn);
        q2.push_back(xtn);
        q3.push_back(xtn);
        q4.push_back(xtn);
        q5.push_back(xtn);
           fork
               begin
                        sem_awc.get(1);
                        drive_awaddr(q1.pop_front());
                        sem_awdc.put(1);//after write address channel we have to start data channel for that we need to pass key
                        sem_awc.put(1);
                end

               begin
                        sem_awdc.get(1);//getting the key from the write address channel
                        sem_wdc.get(1);
                        drive_wdata(q2.pop_front());
                        sem_wdc.put(1);
                        sem_wdrc.put(1);
                end

                begin
                        sem_wdrc.get(1);
                        sem_wrc.get(1);
                        drive_bresp(q3.pop_front());
                        sem_wrc.put(1);
                end

                begin
                        sem_arc.get(1);
                        drive_raddr(q4.pop_front());
                        sem_arc.put(1);
                        sem_ardc.put(1);
                end
                begin
                        sem_ardc.get(1);
                        sem_rdc.get(1);
                        drive_rdata(q5.pop_front());
                        sem_rdc.put(1);
                end  
           join_any
      endtask


 task master_driver::drive_awaddr(axi_transaction xtn);
                $display("start of drive_awaddr");
                mif.mst_drv_cb.AWVALID <= 1;                                 
                mif.mst_drv_cb.AWADDR <= xtn.AWADDR;
                mif.mst_drv_cb.AWSIZE <= xtn.AWSIZE;
                mif.mst_drv_cb.AWID <= xtn.AWID;
                mif.mst_drv_cb.AWLEN <= xtn.AWLEN;
                mif.mst_drv_cb.AWBURST <= xtn.AWBURST;

                @(mif.mst_drv_cb);
                wait(mif.mst_drv_cb.AWREADY)
                mif.mst_drv_cb.AWVALID <= 0;

                repeat($urandom_range(1,5))
                        @(mif.mst_drv_cb);

                $display("end of drive_awaddr");
 endtask


 task master_driver::drive_wdata(axi_transaction xtn);
             

                $display("start of drive_wdata");
        foreach(xtn.WDATA[i])
                     begin
                                mif.mst_drv_cb.WVALID <= 1;
                                mif.mst_drv_cb.WDATA <= xtn.WDATA[i];
                                mif.mst_drv_cb.WSTRB <= xtn.WSTRB[i];
                                mif.mst_drv_cb.WID <= xtn.WID;
                                if(i==(xtn.AWLEN))
                                        mif.mst_drv_cb.WLAST <= 1;
                                else
                                        mif.mst_drv_cb.WLAST <= 0;

                                @(mif.mst_drv_cb);
                                wait(mif.mst_drv_cb.WREADY)
                                    mif.mst_drv_cb.WVALID <= 0;
                                    mif.mst_drv_cb.WLAST <= 0;

                                repeat($urandom_range(1,5))
                                        @(mif.mst_drv_cb);
                        end

                $display("end of drive_wdata");
  endtask


 task master_driver::drive_bresp(axi_transaction xtn);
                $display("start of drive_bresp");
            mif.mst_drv_cb.BREADY<=1;
           @(mif.mst_drv_cb)
           wait(mif.mst_drv_cb.BVALID)
              mif.mst_drv_cb.BREADY<=0;
           repeat($urandom_range(1,5))
               @(mif.mst_drv_cb);
            $display("end of drive_bresp");
 endtask



 task master_driver:: drive_raddr(axi_transaction xtn);
                $display("start of drive_raddr");
           repeat($urandom_range(1,5))
                  @(mif.mst_drv_cb);
           mif.mst_drv_cb.ARID<=xtn.ARID;
           mif.mst_drv_cb.ARLEN<=xtn.ARLEN;
           mif.mst_drv_cb.ARSIZE<=xtn.ARSIZE;
           mif.mst_drv_cb.ARBURST<=xtn.ARBURST;
           mif.mst_drv_cb.ARADDR<=xtn.ARADDR;
           mif.mst_drv_cb.ARVALID<=1;                  
        
                 @(mif.mst_drv_cb);
            $display("inside drive_raddr before wait ARREADY");
                 wait(mif.mst_drv_cb.ARREADY)
                    mif.mst_drv_cb.ARVALID<=0;
              repeat($urandom_range(1,5))
                    @(mif.mst_drv_cb);

                $display("end of drive_raddr");
  endtask

task master_driver::drive_rdata(axi_transaction xtn);
	$display("start of drive_rdata");
	
	repeat($urandom_range(1,5))
		@(mif.mst_drv_cb);
	mif.mst_drv_cb.RREADY<=1;
	wait(mif.mst_drv_cb.RVALID)
	@(mif.mst_drv_cb);
	mif.mst_drv_cb.RREADY<=0;
	repeat($urandom_range(1,5))
                    @(mif.mst_drv_cb);

	 $display("end of drive_rdata");

endtask


