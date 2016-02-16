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

var minval = 9000000000000;
var maxval = 0;

new lazy(fs.createReadStream('./sdata.stats'))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		linestr = linestr.substring(1, linestr.length);
		var linearr = spliter(linestr);
		console.log(linearr);

		linearr[0] = linearr[0].substring(0, linearr[0].length - 3);
		linearr[1] = linearr[1].substring(0, linearr[1].length - 3);
		linearr[3] = linearr[3].substring(0, linearr[3].length - 3);
		if(parseInt(linearr[0]) > maxval) maxval = parseInt(linearr[0]);
		if(parseInt(linearr[1]) > maxval) maxval = parseInt(linearr[1]);
		if(parseInt(linearr[0]) < minval) minval = parseInt(linearr[0]);
		if(parseInt(linearr[1]) < minval) minval = parseInt(linearr[1]);
	//	console.log(linearr);
		linearr[0] = linearr[0].substring(0, 10) + '.' + linearr[0].substring(10, 13)
		linearr[1] = linearr[1].substring(0, 10) + '.' + linearr[1].substring(10, 13)
		console.log(linearr[0] + ', ' + linearr[1] + ', ' + 'SearchInUsers' + ', ' +  (linearr[3].length == 0 ? '0':linearr[3]));

	}).on('pipe', function() {
			console.log(new Date(minval));
			console.log(new Date(maxval));
	});;

