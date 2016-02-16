var models = require('../../models');
var MotorCarrierData = models.MotorCarrierData;
var fs = require('fs');
var lazy = require('lazy');


var spliter = function(str) {

	var ret = [];
	var sta = 0;
	var cnt = 0;
	for(var i = 0; i < str.length; ++i) {
		var ch = str.charAt(i);
		if(ch == '"') {
			cnt = cnt + 1;
		}
		
		if(ch == ',' && !(cnt&1)) {
			ret.push(str.substring(sta, i));
			sta = i + 1;
		}
	}

	ret.push(str.substring(sta, str.length));

	return ret;

}

var removeQuote = function(str) {

	if(str.charAt(0) != '"' || str.charAt(str.length - 1) != '"'){
		//console.log(str);
		//console.log("there are no pair of quote sign");
		return str;
	}
	str = str.substring(1, str.length);
	str = str.substring(0, str.length - 1);
	return str;
}

var parseDate = function(date) {
	var sta = -1;
	var end = -1;
	for(var i = 0; i < date.length; ++i) {
		var ch = date.charAt(i);
		if(ch == '-') {
			if(sta == -1) {
				sta = i + 1;
				continue;
			}
			end = i;
			return date.substring(sta, end);
		}
	}
	return null;
}

/*
var genId = function(dotNumber, date) {

	return parseInt(parseDate(date) + '2014' + dotNumber);
}
*/
var genId = function(dotNumber, prefix) {

	var ret = prefix.toString() + dotNumber.toString();
	return parseInt(ret);
}


var cnt = 0;
var cnt10000 = 0;

var bulkarr = [];
		//change needed
new lazy(fs.createReadStream('./2015Mar_SMS_C_ready.txt'))
	.lines
	.forEach(function(line) {
		var linestr = line.toString();
		linestr = linestr.substring(0, linestr.length - 1);
		var result = spliter(linestr);
		var obj = {};
		//change needed
		obj.id = genId(result[0],"201503");
		obj.dotNumber = result[0];
		//change needed
		obj.date = new Date(2015, 2, 6, 12, 20, 20, 100);
		obj.totals_inspection = result[1];
		obj.totals_driver = result[2];
		obj.totals_driverOOS = result[3];
		obj.totals_vehicle = result[4];
		obj.totals_vehicleOOS = result[5];
		obj.unsafe_inspections = null;
		obj.unsafe_measure = null;
		obj.unsafe_percent = result[8].length > 4 ? null : result[8];
		obj.unsafe_roadAlert = result[9] == 'Y' ? true : false;
		obj.unsafe_seriousViolation = result[10] == 'Y' ? true : false;
		obj.unsafe_basicAlert = result[11] == 'Y' ? true : false;
		obj.fatigue_inspections = null;
		obj.fatigue_measure = null;
		obj.fatigue_percent = result[14].length > 4 ? null : result[14];
		obj.fatigue_roadAlert = result[15] == 'Y' ? true : false;
		obj.fatigue_seriousViolation = result[16] == 'Y' ? true : false;
		obj.fatigue_basicAlert = result[17] == 'Y' ? true : false;
		obj.fitness_inspections = null;
		obj.fitness_measure = null;
		obj.fitness_percent = result[20].length > 4 ? null : result[20];
		obj.fitness_roadAlert = result[21] == 'Y' ? true : false;
		obj.fitness_seriousViolation = result[22] == 'Y' ? true : false;
		obj.fitness_basicAlert = result[23] == 'Y' ? true : false;
		obj.substances_inspections = null;
		obj.substances_measure = null;
		obj.substances_percent = result[26].length > 4 ? null : result[26];
		obj.substances_roadAlert = result[27] == 'Y' ? true : false;
		obj.substances_seriousViolation = result[28] == 'Y' ? true : false;
		obj.substances_basicAlert = result[29] == 'Y' ? true : false;
		obj.maintenance_inspections = null;
		obj.maintenance_measure = null;
		obj.maintenance_percent = result[32].length > 4 ? null : result[32];
		obj.maintenance_roadAlert = result[33] == 'Y' ? true : false;
		obj.maintenance_seriousViolation = result[34] == 'Y' ? true : false;
		obj.maintenance_basicAlert = result[35] == 'Y' ? true : false;
		bulkarr.push(obj);

		if(cnt == 10000) {
			cnt = 0;
			cnt10000 = cnt10000 + 1;
			MotorCarrierData.bulkCreate(bulkarr)
				.success(function() {
					console.log("10000 records successfully saved");
				}).error(function(err) {
					console.log("something wrong when saving 10000 records: ", err);
				});
			while(bulkarr.length > 0) {
				bulkarr.pop();
			}
			console.log(cnt10000);
		}
		cnt = cnt + 1;


	}).on('pipe', function() {
		MotorCarrierData.bulkCreate(bulkarr);
//		console.log('fizz');
//		console.log(bulkarr);
	});;

