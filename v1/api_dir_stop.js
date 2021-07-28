var express = require("express");
var router = express.Router();
var type, time, period, length;
var util = require("util");
var exec = require("child_process").exec;
var split = require("split-string");
var child;

router.get("/:hostsID/:dtypeID/:ipaddress", function (req, res) {
  var hostsID = req.params.hostsID.trim();
  var dtypeID = req.params.dtypeID.trim();
  var ipaddress = req.params.ipaddress.trim();

  child = exec(
    "/home/restful_node_slave/sh/dir_stop.sh " +
      hostsID +
      " " +
      dtypeID +
      " " +
      ipaddress,
    function (error, stdout, stderr) {
      try {
        let respond = stdout.trim();
        res.send(respond);
      } catch (error) {
        result = { status: "fail", result: "[]" };
        return res.json(result);
      }
      //console.log('stdout: ' + stdout);
      //console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log("exec error: " + error);
      }
    }
  );
});

module.exports = router;
