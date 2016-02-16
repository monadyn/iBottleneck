var name;
var dmap = {
	CPU_User: 1, 
	CPU_Nice: 2,
	CPU_Sys: 3,
	CPU_Wait: 4,
	CPU_Irq: 5,
	CPU_Soft: 6,
	CPU_Steal: 7,
	CPU_Idle: 8,
	CPU_Totl: 9,
	CPU_Guest: 10,
	CPU_GuestN: 11,
	CPU_Intrpt_sec: 12,
	CPU_Ctx_sec: 13,
	CPU_Proc_sec: 14,
	CPU_ProcQue: 15,
	CPU_ProcRun: 16,
	CPU_L_Avg1: 17,
	CPU_L_Avg5: 18,
	CPU_L_Avg15: 19,
	CPU_RunTot: 20,
	CPU_BlkTot: 21,
	MEM_Tot: 22, 
	MEM_Used: 23,
	MEM_Free: 24,
	MEM_Shared: 25,
	MEM_Buf: 26,
	MEM_Cached: 27,
	MEM_Slab: 28,
	MEM_Map: 29,
	MEM_Anon: 30,
	MEM_Commit: 31,
	MEM_Locked: 32,
	MEM_SwapTot: 33,
	MEM_SwapUsed: 34,
	MEM_SwapFree: 35,
	MEM_SwapIn: 36,
	MEM_SwapOut: 37,
	MEM_Dirty: 38,
	MEM_Clean: 39,
	MEM_Laundary: 40,
	MEM_Inactive: 41,
	MEM_PageIn: 42,
	MEM_PageOut: 43,
	MEM_PageFaults: 44,
	MEM_PageMajFaults: 45,
	MEM_HugeTotal: 46,
	MEM_HugeFree: 47,
	MEM_HugeRsvd: 48,
	MEM_SUnreclaim: 49,
	NET_RxPktTot: 50,
	NET_TxPktTot: 51,
	NET_RxKBTot: 52,
	NET_TxKBTot: 53,
	NET_RxCmpTot: 54,
	NET_RxMltTot: 55,
	NET_TxCmpTot: 56,
	NET_RxErrsTot: 57,
	NET_TxErrsTot: 58,
	DSK_ReadTot: 59,
	DSK_WriteTot: 60,
	DSK_OpsTot: 61,
	DSK_ReadKBTot: 62,
	DSK_WriteKBTot: 63,
	DSK_KbTot: 64,
	DSK_ReadMrgTot: 65,
	DSK_WriteMrgTot: 66,
	DSK_MrgTot: 67
};
process.argv.forEach(function(val, index, array) {
			if(index == 2) name = val;
});

//calibration 
calibration = 1 

if(name == 'CPU_Totl')  console.log('set yrange [0:105]');
if(name == 'CPU_Sys')  console.log('set yrange [0:105]');
if(name == 'CPU_User')  console.log('set yrange [0:105]');

//console.log("plot 'cdata.txt' using 1:" + (dmap[name] + 1) + " w l title '" + name + "'");
y_col = dmap[name]+1



//	echo "f(x)=mean_y" >> gplot.txt
//	echo "fit f(x) 'inout.txt'  u (\$1):(\$3*20) via mean_y" >> gplot.txt
//	#echo "plot 'inout.txt' using 1:2  with linespoints title 'Send', 'inout.txt' using 1:3 with linespoints title 'Receive'" >> gplot.txt
//	#echo "plot 'inout.txt' u (\$1):(\$3*20)  with linespoints title '${srv_type} gprintf("%g", mean_y)'" >> gplot.txt

console.log("set ylabel '"+name+" [%]'");
console.log("f(x)=mean_y");
console.log("fit f(x) 'cdata.txt'  u ($1-"+calibration+"):($"+y_col + ") via mean_y");
console.log("plot 'cdata.txt' u ($1-"+calibration+"):($"+y_col + ") w l title gprintf(\""+name +" (mean = %g)\",mean_y)");
console.log("set autoscale y");
