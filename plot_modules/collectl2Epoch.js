var fs = require('fs');
var lazy = require('lazy');
var moment = require('moment');

var date2epoch = function(str) {
/*	var tstr = str.substring(0, 4) + "-" + str.substring(4, 6) + "-" + str.substring(6, 8) + "T" + str.substring(9, 21);
	var epoch  = new Date(tstr).getTime();
	epoch = epoch + 18000000;*/

	var estr = moment(str,'YYYYMMDD HH:mm:ss.SSS').valueOf().toString();
return estr.substring(0, 10) + '.' + estr.substring(10, 13);
		//return moment(str,'YYYYMMDD HH:mm:ss').valueOf()
		//return moment(str,'YYYYMMDD HH:mm:ss.SSS').valueOf();
//return estr.substring(6, 10) + '.' + estr.substring(10, 13);
}

new lazy(fs.createReadStream('./cdata.tab'))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		console.log(date2epoch(linestr.substring(0, 21)) + linestr.substring(21, linestr.length));
		//console.log(date2epoch(linestr.substring(0, 21)) + linestr.substring(21, linestr.length));
	}).on('pipe', function() {
	});;
