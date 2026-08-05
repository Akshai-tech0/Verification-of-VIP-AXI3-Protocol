class slave_driver extends uvm_driver#(axi_transaction);
`uvm_component_utils(slave_driver)

virtual axi_if.AXI_SDRV sif;
slave_config slv_cfg_h;
axi_transaction xtn,xtn1;
axi_transaction q1[$] , q2[$] , q3[$];
int count,ending;


semaphore sem_awad   = new();
semaphore sem_wdrp   = new();
semaphore sem_awaddr = new(1);
semaphore sem_awdata = new(1);
semaphore sem_wrp    = new(1);
semaphore sem_radc   = new();
semaphore sem_rac    = new(1);
semaphore sem_rdc    = new(1);


extern function new(string name="slave_driver" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task drive();
extern task drive_awaddr(axi_transaction xtn);
extern task drive_wdata(axi_transaction xtn);
extern task drive_bresp(axi_transaction xtn);
extern task drive_raddr();
extern task drive_rdata(axi_transaction xtn1); 

endclass

function slave_driver ::new(string name="slave_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void slave_driver:: build_phase(uvm_phase phase);
  if(!uvm_config_db#(slave_config)::get(this,"","slave_config",slv_cfg_h))
	`uvm_fatal("slave driver", "getting config failed")
	super.build_phase(phase);
endfunction

function void slave_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	sif=slv_cfg_h.sif;
endfunction

task slave_driver::run_phase(uvm_phase phase);
    forever
	drive();
endtask

task slave_driver::drive();

xtn=axi_transaction::type_id::create("xtn");
fork
               begin//write address channel
                        sem_awaddr.get(1);
                        drive_awaddr(xtn);
                        sem_awad.put(1);
                        sem_awaddr.put(1);
                end

               begin//data channel
                        sem_awad.get(1);
                        sem_awdata.get(1);
                        drive_wdata(q1.pop_front());
                        sem_awdata.put(1);
                        sem_wdrp.put(1);
                end

                begin
                        sem_wdrp.get(1);
                        sem_wrp.get(1);
                        drive_bresp(q2.pop_front());
                        sem_wrp.put(1);
                end

                begin
                        sem_rac.get(1);
                        drive_raddr();
                        sem_rac.put(1);
                        sem_radc.put(1);
                end
                begin
                        sem_radc.get(1);
                        sem_rdc.get(1);
                        drive_rdata(q3.pop_front());
                        sem_rdc.put(1);
                end  
           join_any
endtask


task slave_driver:: drive_awaddr(axi_transaction xtn);

$display("start of slave awaddr");
	repeat($urandom_range(1,5))
	@(sif.slv_drv_cb);
	sif.slv_drv_cb.AWREADY<=1;
	@(sif.slv_drv_cb);
	wait(sif.slv_drv_cb.AWVALID)

	xtn.ARESETn = sif.slv_drv_cb.ARESETn;
	xtn.AWID = sif.slv_drv_cb.AWID;
	xtn.AWLEN = sif.slv_drv_cb.AWLEN;
	xtn.AWSIZE = sif.slv_drv_cb.AWSIZE;
	xtn.AWBURST = sif.slv_drv_cb.AWBURST;
	xtn.AWVALID = sif.slv_drv_cb.AWVALID;
	xtn.AWADDR = sif.slv_drv_cb.AWADDR;
	
	q1.push_back(xtn);
	q2.push_back(xtn);
	
	repeat($urandom_range(1,5))
	@(sif.slv_drv_cb);
	sif.slv_drv_cb.AWREADY <=0;
$display("end of slave awaddr");
endtask


task slave_driver::drive_wdata(axi_transaction xtn);

$display("start of wdata");

for(int i=0;i<(xtn.AWLEN+1);i++)
  begin
	sif.slv_drv_cb.WREADY<=1;
	@(sif.slv_drv_cb);
	wait(sif.slv_drv_cb.WVALID)

        sif.slv_drv_cb.WREADY<=0;
        repeat($urandom_range(1,5))
        @(sif.slv_drv_cb);
        count=1;
 end
   // $display("memory is %p",mem);

    $display("end of wdata");

endtask


task slave_driver:: drive_bresp(axi_transaction xtn);

$display("start of drive bresp");

sif.slv_drv_cb.BVALID<=1;
sif.slv_drv_cb.BRESP<=0;
sif.slv_drv_cb.BID<=xtn.AWID;
$display("BID sent is %d",xtn.AWID);

@(sif.slv_drv_cb);
wait(sif.slv_drv_cb.BREADY)
sif.slv_drv_cb.BVALID<=0;
sif.slv_drv_cb.BRESP<='hx;

repeat($urandom_range(1,5))
@(sif.slv_drv_cb);
$display("end of drive bresp");
endtask


task slave_driver::drive_raddr();
$display("start of slave drive_raddr");
xtn1=axi_transaction::type_id::create("xtn1");
repeat($urandom_range(1,5))
@(sif.slv_drv_cb);
sif.slv_drv_cb.ARREADY<=1;

wait(sif.slv_drv_cb.ARVALID)
	xtn1.ARID=sif.slv_drv_cb.ARID;
	xtn1.ARLEN=sif.slv_drv_cb.ARLEN;
	xtn1.ARSIZE=sif.slv_drv_cb.ARSIZE;
	xtn1.ARBURST=sif.slv_drv_cb.ARBURST;
	
	q3.push_back(xtn1);
	repeat($urandom_range(1,5))
	@(sif.slv_drv_cb);

	sif.slv_drv_cb.ARREADY<=0;
	$display("end of slave raddr");
endtask

task slave_driver::drive_rdata(axi_transaction xtn1);
int length =xtn1.ARLEN;
$display("start of slave drive_rdata");
for(int i=0; i<length+1; i++)
   begin
	sif.slv_drv_cb.RDATA<=$urandom;
	sif.slv_drv_cb.RVALID<=1;
	sif.slv_drv_cb.RID<= xtn1.ARID;
	sif.slv_drv_cb.RRESP<= 0;
	if(i==(length))
		sif.slv_drv_cb.RLAST<=1;
	else
		sif.slv_drv_cb.RLAST<=0;
        @(sif.slv_drv_cb);
        wait(sif.slv_drv_cb.RREADY)
        sif.slv_drv_cb.RVALID<=0;
        sif.slv_drv_cb.RLAST<=0;
        sif.slv_drv_cb.RRESP<='hz;

        repeat($urandom_range(1,5))
        @(sif.slv_drv_cb);
        count=1;

   end

$display("end of slave drive_rdata");

endtask


