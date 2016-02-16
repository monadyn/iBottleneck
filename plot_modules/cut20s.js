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


var arr = [];
//var resTime = [];
new lazy(fs.createReadStream('./sdata.stats'))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		linestr = linestr.substring(1, linestr.length);
		var linearr = spliter(linestr);
		arr.push(linearr);

	}).on('pipe', function() {
		var bd = parseInt(arr[0][0]) + 20000000;

		for(var i = 0; i < arr.length; ++i) {
			if(parseInt(arr[i][0]) <= bd) continue;
//			resTime.push(arr[i][3]);
			console.log(' ' + arr[i][0] + ' ' + arr[i][1] + ' ' + arr[i][2] + ' ' + arr[i][3]);
		}

//		var len = resTime.length;
//		console.log(resTime[len*95%]);
//		console.log(resTime[len*98%]);
//		console.log(resTime[len*99%]);

	});;

