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

new lazy(fs.createReadStream('./tobe.dat'))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		linestr = linestr.substring(1, linestr.length);
		var linearr = spliter(linestr);
		linearr[0] = linearr[0].substring(0, linearr[0].length - 3);
		linearr[1] = linearr[1].substring(0, linearr[1].length - 3);
		linearr[3] = linearr[3].substring(0, linearr[3].length - 3);
	//	console.log(linearr);
		linearr[0] = linearr[0].substring(0, 10) + '.' + linearr[0].substring(10, 13)
		linearr[1] = linearr[1].substring(0, 10) + '.' + linearr[1].substring(10, 13)
		console.log(linearr[0] + ', ' + linearr[1] + ', ' + linearr[2] + ', ' +  linearr[3]);

	}).on('pipe', function() {
	});;

