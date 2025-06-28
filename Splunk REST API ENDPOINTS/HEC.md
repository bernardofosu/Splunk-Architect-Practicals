:

📡 Splunk HEC to Cribl Stream
🔌 Splunk HEC to Stream Example
Listening Port: 10080

Auth Token: myToken42

🧪 Curl Command Examples
🔹 Single Event
```bash
Copy code
curl -k http://<myCriblHost>:10080/services/collector/event \
  -H 'Authorization: myToken42' \
  -d '{"time":"1691511620", "host":"host1", "event":"This is a sample event"}'
```
🔹 Same Event with space after -H

```bash
Copy code
curl -k http://<myCriblHost>:10080/services/collector/event \
  -H 'Authorization: myToken42' \
  -d '{"time":"1691511620", "host":"host1", "event":"This is a sample event"}'
```

🔹 Multiple Events
```bash
Copy code
curl -k http://<myCriblHost>:10080/services/collector/event \
  -H 'Authorization: myToken42' \
  -d '{"event": [ 
        {"time":"1691511620", "host":"host1", "event":"This is a sample event1"}, 
        {"time":"1691511628", "host":"host2", "event":"This is a sample event2"} 
      ]}'
```
🔹 Auth Token as Query Parameter
```bash
Copy code
curl -k http://<myCriblHost>:10080/services/collector/event2?token=myToken42 \
  -d '{"time":"1691511620", "host":"host1", "event":"This is a sample event"}'
```
