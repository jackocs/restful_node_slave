var express = require('express');
var router = express.Router();
var type,time,period,length;
var util = require('util')
var exec = require('child_process').exec;
var split = require('split-string');
var child;

router.get('', function (req, res) {
child = exec("/home/restful_node_slave/sh/count_user.sh " , function (error, stdout, stderr) {
	//let output = stdout.split('#');
	//let result = "{\"status\":\"" + output[0] + "\",\"result\":\"" + output[1] + "\"}";
        //res.send(result);
	//let result = {'status':output[0].trim(),'result':output[1]};
        //res.json(result);
	//res.send(JSON.stringify(respond)+req.query.host_id);
	let respond = stdout.trim();
        res.send(respond);
  console.log('stdout: ' + stdout);
 console.log('stderr: ' + stderr);
  if (error !== null) {
    console.log('exec error: ' + error);
  }
});
});

module.exports = router;
