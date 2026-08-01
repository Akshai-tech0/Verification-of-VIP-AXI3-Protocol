//AXI protocol verification
interface axi_if (input bit clk);
   
   //declaration of signals of each channel
   logic ARESETn;   //global channel
   //write address channel
   logic [3:0] AWID;
   logic [31:0] AWADDR;
   logic [3:0] AWLEN;
   logic [2:0] AWSIZE;
   logic [1:0] AWBURST;
   logic AWVALID;
   logic AWREADY;
   
   //write data channel
   logic [3:0] WID;
   logic [31:0] WDATA;
   logic [3:0] WSTRB;
   logic WLAST;
   logic WVALID;
   logic WREADY;
   
   //WRITE RESPONSE channel
   logic [3:0] BID;
   logic [1:0] BRESP;
   logic BVALID;
   logic BREADY;
   
   //READ ADDRESS channel
   logic [3:0] ARID;
   logic [31:0] ARADDR;
   logic [3:0] ARLEN;
   logic [2:0] ARSIZE;
   logic [1:0] ARBURST;
   logic ARVALID;
   logic ARREADY;
   
   //READ DATA channel
   logic [3:0] RID;
   logic [31:0] RDATA;
   logic [1:0] RRESP;
   logic RLAST;
   logic RVALID;
   logic RREADY;
   
   //MASTER DRIVER CLOCKING BLOCK 
   clocking mst_drv_cb @(posedge clk);
        default input #1 output #0;
		//input from master write address channel
		input AWREADY;
		//input from master write data channel
		input WREADY;
		//input  from master write response channel
		input BID,BRESP,BVALID;
		//input  from master read address channel
		input ARREADY;
		//input  from master read data channel
		input RID,RDATA,RRESP,RLAST,RVALID;
		
		//output from DRIVER
		output ARESETn;
		//from write address
		output AWID,AWADDR,AWBURST,AWLEN,AWSIZE,AWVALID;
		//from write data channel
		output WID,WDATA,WSTRB,WLAST,WVALID;
		//from write response channel
		output BREADY;
		//from read address
		output ARID,ARADDR,ARBURST,ARLEN,ARSIZE,ARVALID;
		//from read data
		output RREADY;
		
	endclocking 
	
	//Master Monitor CLOCKING BLOCK
	clocking mst_mon_cb @(posedge clk);
	    default input #1 output #0;
		//write address channel
		input AWID,AWADDR,AWBURST,AWLEN,AWSIZE,AWVALID,AWREADY;
		//write data channel
		input WID,WDATA,WSTRB,WLAST,WVALID,WREADY;
		//write response channel
		input BID,BRESP,BVALID,BREADY;
		//read address channel
		input ARID,ARADDR,ARBURST,ARLEN,ARSIZE,ARVALID,ARREADY;
		//read data channel
		input RID,RDATA,RRESP,RVALID,RLAST,RREADY;
	
	endclocking
	
	//Slave DRIVER Clocking BLOCK
	clocking slv_drv_cb @(posedge clk);
        default input #1 output #0;		
		//input from DRIVER
		input ARESETn;
		//from write address
		input AWID,AWADDR,AWBURST,AWLEN,AWSIZE,AWVALID;
		//from write data channel
		input WID,WDATA,WSTRB,WLAST,WVALID;
		//from write response channel
		input BREADY;
		//from read address
		input ARID,ARADDR,ARBURST,ARLEN,ARSIZE,ARVALID;
		//from read data
		input RREADY;
		
		// from master write address channel
		output AWREADY;
		// from master write data channel
		output WREADY;
		//from master write response channel
		output BID,BRESP,BVALID;
		//from master read address channel
		output ARREADY;
		//from master read data channel
		output RID,RDATA,RRESP,RLAST,RVALID;
		
	endclocking 
	
	//slave Monitor CLOCKING BLOCK
	clocking slv_mon_cb @(posedge clk);
	    default input #1 output #0;
		//write address channel
		input AWID,AWADDR,AWBURST,AWLEN,AWSIZE,AWVALID,AWREADY;
		//write data channel
		input WID,WDATA,WSTRB,WLAST,WVALID,WREADY;
		//write response channel
		input BID,BRESP,BVALID,BREADY;
		//read address channel
		input ARID,ARADDR,ARBURST,ARLEN,ARSIZE,ARVALID,ARREADY;
		//read data channel
		input RID,RDATA,RRESP,RVALID,RLAST,RREADY;
	
	endclocking
	
	//Modport
	modport AXI_MDRV(clocking mst_drv_cb);
	modport AXI_MMON(clocking mst_mon_cb);
    modport AXI_SDRV(clocking slv_drv_cb);
    modport	AXI_SMON(clocking slv_mon_cb);
	
 endinterface
	