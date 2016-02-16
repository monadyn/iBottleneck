var dmap = {
	'Jan': '01',
	'Feb': '02',
	'Mar': '03',
	'Apr': '04',
	'May': '05',
	'Jun': '06',
	'Jul': '07',
	'Aug': '08',
	'Sep': '09',
	'Oct': '10',
	'Nov': '11',
	'Dec': '12'
};
var fs = require('fs');
var lazy = require('lazy');
var exec = require('child_process').exec;
var darr = [];

var conc;
process.argv.forEach(function(val, index, array) {
	if(index == 2) conc = val; 
});
new lazy(fs.createReadStream('./timerange.txt'))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		darr.push(linestr);
	}).on('pipe', function() {
			var year1 = darr[0].substring(11, 15); 
			var month1 = dmap[darr[0].substring(4, 7)];
			var date1 = darr[0].substring(8, 10);
			var hour1 = darr[0].substring(16, 18);
			var min1 = darr[0].substring(19, 21);
			var sec1 = darr[0].substring(22, 24);
			var min2 = darr[1].substring(19, 21);
			var sec2 = darr[1].substring(22, 24);
			console.log(darr);
			var cmdstr = 'python aggregateInOutPut_ClientTier2.py ' + year1 + month1 + date1 + hour1 + min1 + sec1 + '-' + min2 + sec2 + ' ' + year1 + month1 + date1 + hour1 + min1 + ' ' + year1 + month1 + date1 + hour1 + min2 + ' ' + conc;
			console.log(cmdstr);
			var child = exec(cmdstr, {maxBuffer:1024*1000}, function(err) {
				if(err != null) console.log(err);
			});
	});
