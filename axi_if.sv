interface axi_if(input bit CLK);
 
//Declaration of WRITE address channel signals

logic  ARESETn;
logic [3:0] AWID;
logic [31:0] AWADDR;
logic [7:0] AWLEN;
logic [2:0] AWSIZE;
logic [1:0] AWBURST;
logic AWVALID;
logic AWREADY;

//Declaration of WRITE data channel signals

logic [3:0] WID;
logic [31:0] WDATA;
logic [3:0] WSTRB;
logic WLAST;
logic WVALID;
logic WREADY;

//Declaration of WRITE response channel signals

logic [3:0] BID;
logic [1:0] BRESP;
logic BVALID;
logic BREADY;

//Declaration of READ address channel signals

logic [3:0] ARID;
logic [31:0] ARADDR;
logic [7:0] ARLEN;
logic [2:0] ARSIZE;
logic [1:0] ARBURST;
logic ARVALID;
logic ARREADY;

//Declaration of READ data channel signals

logic [3:0] RID;
logic [31:0] RDATA;
logic [1:0] RRESP;
logic RLAST;
logic RVALID;
logic RREADY;

//Master driver clocking block

clocking mst_drv_cb@(posedge CLK);
    default input #1 output #1;
      
      input AWREADY;
      input WREADY;
      input BID, BRESP, BVALID;
      input ARREADY;
      input RID, RDATA, RRESP, RLAST, RVALID;

      output ARESETn, AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID;
      output WID, WDATA, WSTRB, WLAST, WVALID;
      output BREADY;
      output ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID;
      output RREADY;

endclocking

//Master monitor clocking block

clocking mst_mon_cb@(posedge CLK);
    default input #1 output #1;
       
      input ARESETn, AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY;
      input WID, WDATA, WSTRB, WLAST, WVALID, WREADY;
      input BID, BRESP,BVALID, BREADY;
      input ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, ARREADY;
      input RID, RDATA, RRESP, RLAST, RVALID, RREADY;

endclocking

//Slave driver clocking block

clocking slv_drv_cb@(posedge CLK);
    default input #1 output #1;
      input ARESETn, AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID;
      input WID, WDATA, WSTRB, WLAST, WVALID;
      input BREADY;
      input ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID;
      input RREADY;

      output AWREADY;
      output WREADY;
      output BID, BRESP, BVALID;
      output ARREADY;
      output RID, RDATA, RRESP, RLAST, RVALID;

endclocking

//Slave monior clocking block

clocking slv_mon_cb@(posedge CLK);
    default input #1 output #1;
      input ARESETn, AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY;
      input WID, WDATA, WSTRB, WLAST, WVALID, WREADY;
      input BID, BRESP, BVALID, BREADY;
      input ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, ARREADY;
      input RID, RDATA, RRESP, RLAST, RVALID, RREADY;

endclocking

//modports

modport AXI_MDRV(clocking mst_drv_cb);
modport MST_MON(clocking mst_mon_cb);
modport AXI_SDRV(clocking slv_drv_cb);
modport SLV_MON(clocking slv_mon_cb);

endinterface
