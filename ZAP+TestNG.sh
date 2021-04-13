## https://www.coveros.com/running-selenium-tests-zap/

Start ZAP, specifying a new session in the current workspace, as a background process
/opt/zap/zap.sh -daemon -config api.disablekey=true -newsession ${WORKSPACE}/webui -port 9092 &amp;amp;amp;
 
# Save ZAP's PID to use later
ZAP_PID=$!
 
# While ZAP is still starting up, sleep one second
while [ ! netstat -anp | grep 9092 | grep LISTEN ];
do
    if [ $counter = 300 ];
    then 
        exit 1;
    fi;
    echo "sleeping $counter";
    counter=$((counter+1));
    sleep 1s;
done
echo "done sleeping";
 
javac  -cp "lib/*:src/test/java/seleniumTest/workflows/*" -d bin src/test/java/seleniumTest/workflows/*.java src/test/java/seleniumTest/*.java
 
# Run your selenium tests, providing the host and port of ZAP 
java -cp "bin:lib/*" -Dworkspace=${WORKSPACE} -DappURL=http://${PRIVATE_IP}/ -DproxyHost=localhost -DproxyPort=9092 -Dbrowser=Firefox org.testng.TestNG selenium.xml
 
# While ZAP is still running, download the html report using the ZAP API
wget -O zapresult.html http://localhost:9092/OTHER/core/other/htmlreport/?
 
# Finally, kill the ZAP process
kill $ZAP_PID
