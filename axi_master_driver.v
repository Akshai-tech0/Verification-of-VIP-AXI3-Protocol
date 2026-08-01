class axi_driver extends uvm_driver #(axi_xtn);
    
	`uvm_component_utils(axi_driver)
	
	//handles for necessary claases
	virtual axi_if.AXI_MDRV mif;
	master_config mdrv_h;
	axi_xtn xtn;
	
	//queues to  store transactions
	axi_xtn q1[$],q2[$],q3[$],q4[$],q5[$];
	
	//semaphores
	semaphore sem_awdc = new(); //write addr-data dependancy channel
	semaphore sem_wrdc = new(); //write data-dependency  channel
	semaphore sem_wac  = new(1); //write address chnnel 
	semaphore sem_wdc  = new(1); //write data channel
	semaphore sem_wrc  = new(1); //write response channel
	semaphore sem_radc = new(); //read data-address dependency channel
	semaphore sem_rac  = new(1); //read address channel
	semaphore sem_rdc  = new(1); //read data  channel
	
	//function new
	function new (string name = "axi_driver",  uvm_component parent);
	    super.new(name,parent);
	endfunction
	
	//build phase
	function  void  build_phase (uvm_phase phase);
	    super.build_phase(phase);
		if(!uvm_config_db #(master_config)::get(this,"","master_config",mdrv_h)
		    `uvm_fatal(get_type_name(),"config file  not reached)
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
		mif = mdrv_h.mif;
	endfunction
	
	//run phase
	task run_phase(uvm_phase phase);
	    forever
		   begin
		     seq_item_port.get_next_item(req);
			 drive(req);
			 #10;
			 seq_item_port.item_done();
			 req.print();
			end
	endtask
	
	task drive(axi_xtn xtn);
	    q1.push_back(xtn);
		q2.push_back(xtn);
		q3.push_back(xtn);
		q4.push_back(xtn);
		q5.push_back(xtn);
		fork 
		  begin //write_addr channel
		    sem_awc.get(1);
			drive_awddr(q1.pop_front);
			sem_awdc.put(1);
			sem_awc.put(1);
		  end
		  begin //data channel
		    sem_awdc.get(1);
			sem_wdc.get(1);
			drive_wdata(q2.pop_front);
			sem_wdc.put(1);
			sem_wrdc.put(1); //write data response dependency semaphore
		   end
		   begin //response channel
		    sem_wrdc.get(1);
			sem_wrc.get(1);
			drive_wresp(q3.pop_front);
			sem_wrc.put(1);
		   end
		   begin //read address channel
			 sem_rac.get(1);
			 drive_raddr(q4.pop_front);
			 sem_radc.put(1);
			 sem_rac.put(1);
			end
			begin
			  sem_radc.get(1);
			  sem_wdc.get(1);
			  drive_rdata(q5.pop_front);
			  sem_rdc.put(1);
			 end
			join_any
			endtask 
			
		task drive_awddr(axi_xtn xtn);
		   $display("start of drive_waddr");
		   mif.mst_drv_cb.AWVALID <= 1;
		   mif.mst_drv_cb.AWADDR  <= xtn.AWADDR;
		   mif.mst_drv_cb.AWID    <= xtn.AWID;
		   mif.mst_drv_cb.AWLEN   <= xtn.AWLEN;
		   mif.mst_drv_cb.AWSIZE  <= xtn.AWSIZE;
		   mif.mst_drv_cb.AWBURST <= xtn.AWBURST;
		   repeat ($urandom_range(1,5))
		      @(mif.mst_drv_cb);
			    wait(mif.mst_drv_cb.AWREADY)
				  mif.mst_drv_cb.AWVALID <= 0;
			$display("End of drive  awddr");
		endtask 
			 
		task drive_wdata(axi_xtn xtn);
		     $display("start of drive_wdata");
			foreach (xtn.WDATA[i])
			begin 
			  mif.mst_drv_cb.WVALID <= 1;
			  mif.mst_drv_cb.WID    <= xtn.WID;
			  mif.mst_drv_cb.WDATA  <= xtn.WDATA[i];
			  mif.mst_drv_cb.WSTRB  <= xtn.WSTRB[i];
			  if (i == xtn.AWLEN)
			  mif.mst_drv_cb.WLAST <= 1;
			  else
			  mif.mst_drv_cb.WLAST <= 0;
			  @(mif.mst_drv_cb)
			     wait(mif.mst_drv_cb.WREADY)
				   mif.mst_drv_cb.WVALID <= 0;
				   mif.mst_drv_cb..WLAST <= 0;
				   repeat ($urandom_range(2,5))
				    @(mif.mst_drv_cb);
			end
			$display("end of drive wdata");
		endtask
		
		task drive_wresp(axi_xtn xtn);
		   begin
		     $display("start of response task");
			 repeat ($urandom_range(1,5))
			   @(mif.mst_drv_cb)
			  mif.mst_drv_cb.BREADY <= 1;
			  wait (mif.mst_drv_cb.BVALID)
			  mif.mst_drv_cb.BREADY <= 0;
			  repeat ($urandom_range(1,5))
			   @(mif.mst_drv_cb)
			  $display("end of response task");
		endtask
		
		task drive_raddr(axi_xtn xtn);
		   begin
		     $display("start of read addr task");
			  repeat ($urandom_range(1,5))
			   @(mif.mst_drv_cb)
			 mif.mst_drv_cb.ARVALID  <= 1;
			 mif.mst_drv_cb.ARID     <= xtn.ARID;
			 mif.mst_drv_cb.ARLEN    <= xtn.ARLEN;
			 mif.mst_drv_cb.ARSIZE   <= xtn.ARSIZE;
			 mif.mst_drv_cb.ARBURST  <= xtn.ARBURST;
			 mif.mst_drv_cb.ARADDR   <= xtn.ARADDR;
			 @(mif.mst_drv_cb)
			 wait (mif.mst_drv_cb.ARREADY)
			    mif.mst_drv_cb.ARVALID <= 0;
			repeat($urandom_range(1,5))
                @(mif.mst_drv_cb);
            $display("end of drive_raddr");	
		endtask 
		
		task drive_rdata(axi_xtn xtn);
		   begin
		     $display("read data task started");
			 for (i=0,i<(xtn.ARLEN),i++)
			    mif.mst_drv_cb.RREADY <= 1;
			 @(mif.mst_drv_cb)
			    wait (mif.mst_drv_cb.RVALID)
				  mif.mst_drv_cb.RREADY <= 0;
			   repeat($urandom_range(1,5))
	                @(mif.mst_drv_cb);	  
			end
		endtask 
		
endclass
			
		   
			
		    
			
		