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
		
		arr.push(linearr[3]/1000);

	}).on('pipe', function() {
			var sum = 0;
			for(var i = 0; i < arr.length; ++i) {
				sum += parseInt(arr[i]);
			}
			console.log(sum/arr.length);
	});;

