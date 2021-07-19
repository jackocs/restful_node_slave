var express = require("express");
var router = express.Router();
var type, time, period, length;
var util = require("util");
var exec = require("child_process").exec;
var child;

router.get("/", function (req, res) {
  child = exec(
    "/home/restful_node_slave/sh/monitor/monitor_containers.sh ",
    function (error, stdout, stderr) {
      try {
        var arr = JSON.parse(stdout);
        result = { status: "ok".trim(), result: arr };
        res.json(result);
        //console.log("stdout: " + stdout);
        console.log("stderr: " + stderr);
      } catch (error) {
        //console.error(error);
        result = { status: "fail", result: "[]" };
        return res.json(result);
      }

      if (error !== null) {
        console.log("exec error: " + error);
      }
    }
  );
});

module.exports = router;
