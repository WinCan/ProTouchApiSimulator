# ProTouchApiSimulator

This simple application allows simulate client side. 
1. On “Connection box” you can connect to server, by default connection is established to **localhost** (127.0.0.1) on port **8085** when clicked on “Connect to server”.
   When you click on “Disconnect from server” connection is lost.
2. Next on “Monitoring messages box” there is simulation for sending:
	- OBJECT_STATUS_IND with parameters object and value,
	- METER_COUNTER_STATUS_IND with value parameter
3. Last box “Control message’s response” is responsible for simulating response messages such as:
	- **CHANGE_OBJECT_VALUE_RESP**,
	- **MOVE_OBJECT_RESP**,
	- **ACTION_OBJECT_TRIGGER_RESP**
   You can create payload for this messages (status, errorCode and error). Also you can ignore messages by clicking “Ignore messages” for example to test error handling timeout, etc.
4. On the bottom there is text area when client can see messages, which are sent by server.
