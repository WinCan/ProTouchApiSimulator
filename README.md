# ProTouchApiSimulator

This simple application allows simulate client side. 
1. On “Connection box” you can connect to server, by default connection is established to **localhost** (127.0.0.1) on port **8095** when clicked on “Connect to server”.
   When you click on “Disconnect from server” connection is lost.
2. Next on “Monitoring messages box” there is simulation for sending:
	- **OBJECT_STATUS_IND** with parameters object and value,
	- **METER_COUNTER_STATUS_IND** with value and unit parameters
3. Last box “Control message’s response” is responsible for simulating response messages such as:
	- **CHANGE_OBJECT_VALUE_RESP**,
	- **MOVE_OBJECT_RESP**,
	- **ACTION_OBJECT_TRIGGER_RESP**
   You can create payload for this messages (status, errorCode and error). Also you can ignore messages by clicking “Ignore messages” for example to test error handling timeout, etc.
4. There is a box "Create free text" where you can send **CREATE_FREE_TEXT** message to OSD on server.
5. On the bottom there is text area when client can see messages, which are sent by server.


To enable panels on ProTouch app, please use dynamic_gui_tester.py script.
1. Make sure that in ProTouch -> Settings -> Device Control -> ProTouch Api Panels you select Dynamic UI Panels
2. Next run script and first you need to initialize panels by typping 0 ("Init panels").
3. Then enter 1 ("Show panels") to show panels.
4. Remeber that always you need to do these steps 2 and 3 to enable panels.
