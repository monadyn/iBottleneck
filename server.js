var express = require('express');
//var multer = require('multer');
var app = express();
var exec = require('child_process').exec;

var bodyParser = require('body-parser');
var path = require('path');
var fs = require('fs');


var parseStrForJSON = function(str) {
	var sta = -1, end = -1;
	for(var i = 0; i < str.length; ++i) {
		if(str.charAt(i) == '{') sta = i;
		if(str.charAt(i) == '}') {
			end = i;
			break;
		}
	}
	if(sta  == -1) return null;
	return str.substring(sta, end + 1);
};

app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res) {
	res.sendFile(__dirname + '/show_one_report.html');
});

app.get('/demo', function(req, res) {
	res.sendFile(__dirname + '/show_one_report.html');
});
/*
app.get('/upload', function(req, res) {
	res.sendFile(__dirname + '/upload.html');
});
*/
app.get('/initial', function(req, res) {
	fs.readFile('./initial.js', function(err, data) {
		var initdata = JSON.parse(parseStrForJSON(data.toString()));
		console.log("init...");
		if(!err) {
			console.log(initdata);
			res.send('200', initdata);
		} else {
			res.send('500', err);
		}
	});
});



app.post('/showdata', function(req, res) {
	var exp = req.body;
	var ofile = './initial.js';
	fs.writeFile(ofile, "var initdata = " + JSON.stringify(exp) + "\nmodule.exports = initdata;", function(err) {
		if(err) console.log(err);
		else {
			console.log("showdata...");
			//console.log(exp);
			var cmdstr = "./plot_modules/plot_graph.sh " + exp.server + " " + exp.conc + " " + exp.ecase + " " + exp.imgHi + "," + exp.imgWi + " " + (exp.xRangeL == 'OFF' ? 'OFF' : '['+exp.xRangeL+':'+exp.xRangeR+']') + " " + exp.inout + " " + exp.multi + " " + exp.resTime + " " + exp.collectl0 +  " " + exp.collectl1 + " " + exp.collectl2 + " " + exp.longreq + " " + exp.inoutRange + " "  + exp.multiRange + " " + exp.responseRange + " -v  "; 
			console.log(cmdstr);
			var child = exec(cmdstr, function(err) {
				if(err) console.log(err);
				else {
					console.log("gnuplot exec suc..");
					res.send('200','OK');
					/*var child0 = exec("cp *_*_*png public/show.png", function(err) {
						if(err) console.log(err);
						else res.send('200', 'OK');
					});*/
				}
			});
		}
	})
});



//var png_repository_root='/home/ec2-user/node'
app.post('/statRT', function(req, res) {
	var exp = req.body;
	var ofile = './initial.js';
	fs.writeFile(ofile, "var initdata = " + JSON.stringify(exp) + "\nmodule.exports = initdata;", function(err) {
		if(err) console.log(err);
		else {
			console.log("loadplot..., copy png");
			var file = png_repository_root + "/" +exp.server + "_" + exp.ecase+ "_"+ exp.conc+".png" 
			console.log(file);
			var child0 = exec("cp "+file+" public/show.png", function(err) {
				if(err) console.log(err);
				else res.send('200', 'OK');
			});
		}
	});

});

///var png_repository_root='/home/ec2-user/node'
app.post('/statTP', function(req, res) {
	var exp = req.body;
	var ofile = './initial.js';
	fs.writeFile(ofile, "var initdata = " + JSON.stringify(exp) + "\nmodule.exports = initdata;", function(err) {
		if(err) console.log(err);
		else {
			console.log("loadplot..., copy png");
			var file = png_repository_root + "/" +exp.server + "_" + exp.ecase+ "_"+ exp.conc+".png" 
			console.log(file);
			var child0 = exec("cp "+file+" public/show.png", function(err) {
				if(err) console.log(err);
				else res.send('200', 'OK');
			});
		}
	});

});

var png_repository_root='/home/ec2-user/node'
app.post('/loadplot', function(req, res) {
	var exp = req.body;
	var ofile = './initial.js';
	fs.writeFile(ofile, "var initdata = " + JSON.stringify(exp) + "\nmodule.exports = initdata;", function(err) {
		if(err) console.log(err);
		else {
			console.log("loadplot..., copy png");
			var file = png_repository_root + "/" +exp.server + "_" + exp.ecase+ "_"+ exp.conc+".png" 
			console.log(file);
			var child0 = exec("cp "+file+" public/show.png", function(err) {
				if(err) console.log(err);
				else res.send('200', 'OK');
			});
		}
	});

});


var plot_module_root='./plot_modules'
app.post('/tuneplot', function(req, res) {
	var exp = req.body;
	var ofile = './initial.js';
	fs.writeFile(ofile, "var initdata = " + JSON.stringify(exp) + "\nmodule.exports = initdata;", function(err) {
		if(err) console.log(err);
		else {
			console.log("tuneplot...");
	var cmdstr = "./plot_modules/tune_plot.sh " + exp.server + " " + exp.conc + " " + exp.ecase + " " + exp.imgHi + "," + exp.imgWi + " " + (exp.xRangeL == 'OFF' ? 'OFF' : '['+exp.xRangeL+':'+exp.xRangeR+']') + " " + exp.inout + " " + exp.multi + " " + exp.resTime + " " + exp.collectl0 +  " " + exp.collectl1 + " " + exp.collectl2 + " " + exp.longreq + " " + exp.inoutRange + " "  + exp.multiRange + " " + exp.responseRange;
	console.log(cmdstr);
	var child = exec(cmdstr, function(err) {
		//if(err) console.log(err);
		//else
		{
			
			var file = plot_module_root + "/"+exp.server + "_" + exp.ecase+ "_"+ exp.conc+".png" 
			var child0 = exec("cp "+file+" public/show.png", function(err) {
				if(err) console.log(err);
				else res.send('200', 'OK');
			});
		}
	});
	}
	})
});

app.post('/plotmaxtp', function(req, res) {
	var exp = req.body;
	var cmdstr = "./plotMaxTP.sh " + exp.server + " " + exp.ecase; 
	var child = exec(cmdstr, function(err) {
		if(err) console.log(err);
		else {
			res.send('200', 'ok');
		}
	});
});



app.post('/starttest', function(req, res) {
	var exp = req.body;
	var cmdstr = "./client_modules/start_test.sh " + exp.server + " " + exp.ecase; 
	var child = exec(cmdstr, function(err)	{
		console.log(cmdstr);
		if(err) console.log(err);
		else {
			res.send('200', 'ok');
		}
	});
});

var server = app.listen(3000, function() {
	var host = server.address().address; 
	var port = server.address().port;
	console.log('Example app listen at http://%s:$s', host, port);
});
