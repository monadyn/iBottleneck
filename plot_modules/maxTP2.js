var fs = require('fs');
var lazy = require('lazy');

var spliter = function(str) {
	var ret = [];
	var sta = 0;
	for(var i = 0; i < str.length; ++i) {
		var ch = str.charAt(i);	
		if(ch == ' ') {
			ret.push(str.substring(sta, i));
			sta = i + 1;
		}
	}

	ret.push(str.substring(sta, str.length));

	return ret;
}

var alg1 = function(outarr) {
	var outfreq = {};

	var omax = 0;
	var oik = 0;
	for(var i = 0; i < outarr.length; ++i) {
		if(outfreq[outarr[i]]) outfreq[outarr[i]] = outfreq[outarr[i]] + 1;
		else outfreq[outarr[i]] = 1;
	}
	delete outfreq['0'];

	for(ik in outfreq) {
		if(outfreq[ik] > omax) {
			omax = outfreq[ik];
			oik = ik;
		}
	}

	return oik;

}

var alg2 = function(outarr, num) {
	var outfreq = {};

	var omax = 0;
	var oik = 0;
	for(var i = 0; i < outarr.length; ++i) {
		if(outfreq[outarr[i]]) outfreq[outarr[i]] = outfreq[outarr[i]] + 1;
		else outfreq[outarr[i]] = 1;
	}
	delete outfreq['0'];

	var freqarr = [];
	for(var key in outfreq) {
		freqarr.push([key, outfreq[key]]);
	}
	freqarr.sort(function(a, b) {return b[1] - a[1]});

	var dn = 0;
	var dr = 0;
	if(!num) num = freqarr.length;
	for(var i = 0; i < num; ++i) {
		dn = dn + freqarr[i][0]*freqarr[i][1];
		dr = dr + freqarr[i][1];
	}

	return dn/dr;

}


var inarr = [];
var outarr = [];

new lazy(fs.createReadStream('../java10_cal1/t1/java10_file_2000/inout.txt'))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		linestr = linestr.substring(1, linestr.length);
		var linearr = spliter(linestr);
		inarr.push(linearr[23]);
		outarr.push(linearr[24]);

	}).on('pipe', function() {
			var oik = alg2(outarr, 0);
			
	});;
