var fs = require('fs');
var lazy = require('lazy');

var infile;

process.argv.forEach(function(val, index, array) {
			if(index == 2) infile = val;
});

new lazy(fs.createReadStream(infile))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		console.log(linestr.substring(6, linestr.length));
	}).on('pipe', function() {
	});;
