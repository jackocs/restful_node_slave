var express = require('express');
var router = express.Router();
var type,time,period,length;
var util = require('util');
var exec = require('child_process').exec;
var split = require('split-string');
var child;

router.get('/:domain/:passwd/:ip/:desc/:dtype_id/:ipmaster/:owner', function (req, res) {
var domain=req.params.domain.trim().toLowerCase();
var passwd=req.params.passwd.trim();
var ip=req.params.ip.trim();
var desc=req.params.desc.trim();
var dtype_id=req.params.dtype_id.trim();
var ipmaster=req.params.ipmaster.trim();
var owner=req.params.owner.trim();

function getBaseDomain(domain){
        var split_domain = split(domain);
        var base_domain;
                for (var id in split_domain){
                        if (id == 0) {
                                base_domain = 'dc=' + split_domain[id];
                        }else{
                                base_domain = base_domain + ',dc=' + split_domain[id];
                        }
                }
        return base_domain;
}
var base_domain = getBaseDomain(domain);

child = exec("/home/restful_node_slave/sh/dir_install.sh "+ domain +" "+passwd +" "+ip +" "+desc +" "+dtype_id +" "+ipmaster +" "+owner +" "+base_domain , function (error, stdout, stderr) {
	//let output = stdout.split('#');
	//let respond = {'status':output[0].trim(),'result':output[1].trim()};
	//let result = "{\"status\":\"" + output[0] + "\",\"result\":\"" + output[1] + "\"}";
	//let result = {'status':output[0].trim(),'result':output[1]};
	//res.json(result);
	//res.send(JSON.stringify(respond)+req.query.host_id);
	//let respond = stdout.trim();
        //res.send(JSON.stringify(respond));
	res.send(stdout);
  console.log('stdout: ' + stdout);
  console.log('stderr: ' + stderr);
  if (error !== null) {
    console.log('exec error: ' + error);
  }
});
});

module.exports = router;
