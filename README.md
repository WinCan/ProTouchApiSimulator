# ProTouchApiSimulator
Download the newest release: https://wincan.com/protouch-api-windows

This simple application allows simulate client side. 
1. On “Connection box” you can connect to server, by default connection is established to **localhost** (127.0.0.1) on port **8095** when clicked on “Connect to server”.
   When you click on “Disconnect from server” connection is lost.
2. Next on “Monitoring messages box” there is simulation for sending:
	- **OBJECT_STATUS_IND** with parameters object and value,
	- **METER_COUNTER_STATUS_IND** with value and unit parameters
3. Next box “Control message’s response” is responsible for simulating response messages such as:
	- **CHANGE_OBJECT_VALUE_RESP**,
	- **MOVE_OBJECT_RESP**,
	- **ACTION_OBJECT_TRIGGER_RESP**
	- **CHANGE_METER_COUNTER_VALUE_RESP**
   You can create payload for this messages (status, errorCode and error). Also you can ignore messages by clicking “Ignore messages” for example to test error handling timeout, etc.
4. Last box is "Video Message" for simulating **START_VIDEO_STREAMING_REQ** with port as parameter and **PERFORM_VIDEO_ACTION_REQ** with video action such as pause, resume or stop.
5. There is a box "Create free text" where you can send **CREATE_FREE_TEXT** message to OSD on server.
6. On the bottom there is text area when client can see messages, which are sent by server.


~~To enable panels on ProTouch app, please use dynamic_gui_tester.py script.~~
~~1. Make sure that in ProTouch -> Settings -> Device Control -> ProTouch Api Panels you select Dynamic UI Panels~~
~~2. Next run script and first you need to initialize panels by typping 0 ("Init panels").~~
~~3. Then enter 1 ("Show panels") to show panels.~~
~~4. Remeber that always you need to do these steps 2 and 3 to enable panels.~~

To enable panels in ProTouch, you can use Dynamic GUI tab in Simulator. Fastest way to enable default panels is just Enable -> Send configuration -> Send visibility.
To use panels you need to enable them in ProTouch (Settings -> Device Control -> Dynamic UI Panels).

To test if video streaming by UDP is correct you can call gstreamer command, where ip should be the same as in **START_VIDEO_STREAMING_RESP** and port from **START_VIDEO_STREAMING_REQ**
gst-launch-1.0 autovideosrc is-live=true do-timestamp=true ! autovideoconvert ! queue leaky=downstream ! x264enc tune=zerolatency ! h264parse ! rtph264pay pt=96 ! udpsink host=127.0.0.1 port=5000
