#!/bin/bash

docker=(ldap)
map=(directory)
count=$(echo ${#docker[@]})
date=$(TZ=GMT date '+%Y-%m-%dT%H:%M:%SZ')
#echo $date

if (($(ps -ef | grep -v grep | grep "docker" | wc -l) == 0)); then
    echo "docker is not running!!!"
    exit
fi

jsonfile="/tmp/report.json"
echo "" >$jsonfile
/bin/cp /dev/null $jsonfile
j=0
k=1
echo "[" >$jsonfile
for i in "${docker[@]}"; do
    st=$(docker inspect --format '{{json .State.Running}}' $i)
    #raw=$(docker stats --no-stream $i --format "{\"netio\":\"{{ .NetIO }}\",\"blockio\":\"{{ .BlockIO }}\",\"mem\":{\"raw\":\"{{ .MemUsage }}\",\"percent\":\"{{ .MemPerc }}\"},\"cpu\":\"{{ .CPUPerc }}\"}")
    raw=$(docker stats --no-stream $i --format "{\"netio\":\"{{ .NetIO }}\",\"blockio\":\"{{ .BlockIO }}\",\"mem\":\"{{ .MemPerc }}\",\"cpu\":\"{{ .CPUPerc }}\"}")

    if [ $k == ${#docker[@]} ]; then
        echo "{\"datetime\": \"$date\", \"container\": \"${map[$j]}\" , \"status\": \"$st\", \"data\": $raw}" >>$jsonfile
    else
        echo "{\"datetime\": \"$date\", \"container\": \"${map[$j]}\" , \"status\": \"$st\", \"data\": $raw}," >>$jsonfile
    fi
    j=$(expr $j + 1)
    k=$(expr $k + 1)
done

#sleep 3

echo "]" >>$jsonfile
cat $jsonfile

#/home/xIDM-SSO-Cent8/report/containers.py