var express = require("express");
var router = express.Router();
var type, time, period, length;
var util = require("util");
var exec = require("child_process").exec;
var split = require("split-string");
var child;

//router.get('/:hostsID/:dtypeID/:ipaddress/:domain/:passwd', function (req, res) {
router.get("/:dtypeID", function (req, res) {
  var dtypeID = req.params.dtypeID.trim();
  //var hostsID = req.params.hostsID.trim();
  //var ipaddress = req.params.ipaddress.trim();
  //var domain=req.params.domain.trim().toLowerCase();
  //var passwd=req.params.passwd.trim();

  child = exec(
    "/home/restful_node_slave/sh/dir_del.sh " + dtypeID ,
    function (error, stdout, stderr) {
      let respond = stdout.trim();
      res.send(respond);
      console.log("stdout: " + stdout);
      console.log("stderr: " + stderr);
      if (error !== null) {
        console.log("exec error: " + error);
      }
    }
  );
});

module.exports = router;
