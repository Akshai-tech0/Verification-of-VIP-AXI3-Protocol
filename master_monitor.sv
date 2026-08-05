class master_monitor extends uvm_monitor;
    `uvm_component_utils(master_monitor)

    virtual axi_if.MST_MON mif;
    master_config mst_cfg_h;
  
    axi_transaction xtn,xtn1,xtn2,xtn3,xtn4;
	axi_transaction q1[$],q2[$];
	semaphore sem_awdc = new();
	semaphore sem_wdrc = new();
	semaphore sem_wdc = new(1);
	semaphore sem_awc = new(1);
	semaphore sem_wrc = new(1);
	
	semaphore sem_ardc = new();
	semaphore sem_arc = new(1);
	semaphore sem_rdc = new(1);
        static int pkt_sent;	
	
	uvm_analysis_port#(axi_transaction) monitor_port;
    
    extern function new(string name = "master_monitor", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern task collect_awaddr();
	extern task collect_wdata(axi_transaction xtn);
	extern task collect_bresp();
	extern task collect_raddr();
	extern task collect_rdata(axi_transaction xtn);
    extern function void report_phase(uvm_phase phase); 
endclass: master_monitor

    function master_monitor::new(string name = "master_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void master_monitor::build_phase(uvm_phase phase);
        if(!uvm_config_db#(master_config)::get(this, "", "master_config", mst_cfg_h))
            `uvm_fatal("Master Driver", "getting config failed");
            super.build_phase(phase);
            monitor_port=new("monitor_port",this);
    endfunction

    function void master_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mif=mst_cfg_h.mif;
    endfunction
	
    task  master_monitor::run_phase(uvm_phase phase);
              forever
		collect_data();
    endtask
	
	task master_monitor::collect_data();
	fork
		begin
			sem_awc.get(1);
			collect_awaddr();
			sem_awdc.put(1);
			sem_awc.put(1);
		end
		
		begin
			sem_awdc.get(1);
			sem_wdc.get(1);
			collect_wdata(q1.pop_front());
			sem_wdc.put(1);
			sem_wdrc.put(1);
		end
		
		begin
			sem_wdrc.get(1);
			sem_wrc.get(1);
			collect_bresp();
			sem_wrc.put(1);
		end
		
		begin
			sem_arc.get(1);
			collect_raddr();
			sem_arc.put(1);
			sem_ardc.put(1);
		end
		
		begin
			sem_ardc.get(1);
			sem_rdc.get(1);
			collect_rdata(q2.pop_front());
			sem_rdc.put(1);
		end
    
	join_any
      endtask
	
	task master_monitor::collect_awaddr();
	    xtn=axi_transaction::type_id::create("xtn");
		wait(mif.mst_mon_cb.AWVALID && mif.mst_mon_cb.AWREADY)
		     xtn.AWVALID= mif.mst_mon_cb.AWVALID;
		     xtn.AWADDR = mif.mst_mon_cb.AWADDR;
		     xtn.AWSIZE = mif.mst_mon_cb.AWSIZE;
		     xtn.AWID = mif.mst_mon_cb.AWID;
		     xtn.AWLEN =mif.mst_mon_cb.AWLEN;
		     xtn.AWBURST =mif.mst_mon_cb.AWBURST;
                  q1.push_back(xtn);
		monitor_port.write(xtn);
                pkt_sent++;
	//	xtn.print();
                 `uvm_info("MONITOR",$sformatf("printing from master monitor collect_awaddr \n %s", xtn.sprint()),UVM_LOW)
		@(mif.mst_mon_cb);
	endtask
	
	task master_monitor::collect_wdata(axi_transaction xtn);
	xtn1=axi_transaction::type_id::create("xtn1");
	xtn1=xtn;
	xtn.cal_addr();
	xtn1.WDATA=new[xtn.AWLEN+1];
	xtn1.WSTRB=new[xtn.WDATA.size()];
		foreach(xtn1.WDATA[i])
			begin
			   wait(mif.mst_mon_cb.WVALID && mif.mst_mon_cb.WREADY)
			    xtn1.WSTRB[i]=mif.mst_mon_cb.WSTRB;
				  if(mif.mst_mon_cb.WSTRB==15)
					   xtn1.WDATA[i]=mif.mst_mon_cb.WDATA;

			      if(mif.mst_mon_cb.WSTRB==8)
					   xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[31:24];

				  if(mif.mst_mon_cb.WSTRB==4)
					   xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[23:16];

				  if(mif.mst_mon_cb.WSTRB==2)
					   xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[15:8];

				  if(mif.mst_mon_cb.WSTRB==1)
					   xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[7:0];

				  if(mif.mst_mon_cb.WSTRB==7)
						 xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[23:0];

				  if(mif.mst_mon_cb.WSTRB==14)
						xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[31:8];

				  if(mif.mst_mon_cb.WSTRB==12)
						xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[31:16];

				  if(mif.mst_mon_cb.WSTRB==3)
						xtn1.WDATA[i]=mif.mst_mon_cb.WDATA[15:0];

				xtn1.WID=mif.mst_mon_cb.WID;
				xtn1.WLAST=mif.mst_mon_cb.WLAST;
                                xtn1.WVALID=mif.mst_mon_cb.WVALID;
				@(mif.mst_mon_cb);
			end
		       monitor_port.write(xtn1);
                       pkt_sent++;
                       `uvm_info("MONITOR",$sformatf("printing from master monitor collect_wdata \n %s", xtn1.sprint()),UVM_LOW)
			//xtn1.print();
	endtask
	
	task master_monitor::collect_bresp();
	     xtn2=axi_transaction::type_id::create("xtn2");
	     wait(mif.mst_mon_cb.BREADY && mif.mst_mon_cb.BVALID)
		 xtn2.BRESP=mif.mst_mon_cb.BRESP;
		 monitor_port.write(xtn2);
	         //xtn2.print();
                 pkt_sent++;
                 `uvm_info("MONITOR",$sformatf("printing from master monitor collect_bresp \n %s", xtn2.sprint()),UVM_LOW)
		 @(mif.mst_mon_cb);
	endtask
	
	task master_monitor::collect_raddr();
	    xtn3=axi_transaction::type_id::create("xtn3");
		wait(mif.mst_mon_cb.ARVALID && mif.mst_mon_cb.ARREADY)
		     xtn3.ARVALID= mif.mst_mon_cb.ARVALID;
		     xtn3.ARADDR = mif.mst_mon_cb.ARADDR;
		     xtn3.ARSIZE = mif.mst_mon_cb.ARSIZE;
		     xtn3.ARID = mif.mst_mon_cb.ARID;
		     xtn3.ARLEN = mif.mst_mon_cb.ARLEN;
		     xtn3.ARBURST= mif.mst_mon_cb.ARBURST;
                     q2.push_back(xtn3);
		@(mif.mst_mon_cb);
		monitor_port.write(xtn3);
                pkt_sent++;
	       // xtn3.print();
               `uvm_info("MONITOR",$sformatf("printing from master monitor collect_raddr \n %s", xtn3.sprint()),UVM_LOW)
	endtask
	
	task master_monitor::collect_rdata(axi_transaction  xtn);
		xtn4=axi_transaction::type_id::create("xtn4");
		xtn4=xtn;
		xtn4.RDATA=new[xtn.ARLEN+1];
		foreach(xtn4.RDATA[i])
			begin
			   wait(mif.mst_mon_cb.RVALID && mif.mst_mon_cb.RREADY)
		          xtn4.RID=mif.mst_mon_cb.RID;
                  xtn4.RVALID=mif.mst_mon_cb.RVALID;
			      xtn4.RREADY=mif.mst_mon_cb.RREADY;
			      xtn4.RDATA[i]=mif.mst_mon_cb.RDATA;
			      xtn4.RRESP[i]=mif.mst_mon_cb.RRESP;

			if(i==(xtn4.RDATA.size-1))
			begin
			xtn4.RLAST = mif.mst_mon_cb.RLAST;
			end
			$display("last = %b",mif.mst_mon_cb.RLAST);
			@(mif.mst_mon_cb);
			end
			monitor_port.write(xtn4);
                        pkt_sent++;
                       `uvm_info("MONITOR",$sformatf("printing from master monitor monitor_rdata \n %s", xtn4.sprint()),UVM_LOW)
		//	xtn4.print();
	endtask


        function void master_monitor::report_phase(uvm_phase phase); 
            `uvm_info("MASTER MONITOR",$sformatf("no of packet sent are:%0d",pkt_sent),UVM_LOW);
        endfunction
