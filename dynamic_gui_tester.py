import zmq
import time
import threading

def worker_routine(context):
	consumer_listener = context.socket(zmq.PULL)
	consumer_listener.bind("tcp://127.0.0.1:52944")
	
	while True:
		message = consumer_listener.recv()
		print ("Received message: ", message)

context = zmq.Context()
consumer_sender = context.socket(zmq.PUSH)
consumer_sender.connect("tcp://127.0.0.1:52943")

thread = threading.Thread(target=worker_routine, args=(context, ))
thread.start()

input_data = -1
times_button_update_called = 0

while True:
	print("Send operation type: ")
	print("0 - Init panels")
	print("1 - Show panels")
	print("2 - Update button")
	print("3 - Close")

	try:
		input_data = int(input('?'))
	except ValueError:
		continue

	request = {}
	if input_data == 0:
		request["leftPanelItems"] = [
            {
                "id": "joystick1",
                "type": "Joystick"
            },
            {
                "id": "button1",
                "type": "Button",
                "properties": {
                    "text": "Button1 text"
                }
            },
            {
                "id": "text1",
                "type": "Text",
                "properties": {
                    "text": "Left text"
                }
            },
            {
                "id": "label1",
                "type": "Label",
                "properties": {
                    "text": "Label left text"
                }
            },
            {
                "id": "spinBox1",
                "type": "Spinbox",
                "properties": {
                    "value": 5,
                    "stepSize" : 10
                }
            },
            {
                "id": "levelIndicator1",
                "type": "LevelIndicator",
                "properties": {
                    "chargeLevel": 25
                }
            },
            {
                "id": "switch1",
                "type": "Switch",
                "properties": {
                    "status": True
                }
            },
            {
                "id": "meterCounter1",
                "type": "MeterCounter"
            }  
        ]
		request["rightPanelItems"] = [
            {
                "id": "joystick2",
                "type": "Joystick"
            },
            {
                "id": "button2",
                "type": "Button",
                "properties": {
                    "text": "Button2 text"
                }
            },
            {
                "id": "text2",
                "type": "Text",
                "properties": {
                    "text": "Right text"
                }
            },
            {
                "id": "label2",
                "type": "Label",
                "properties": {
                    "text": "Label right text"
                }
            },
            {
                "id": "spinBox2",
                "type": "Spinbox",
                "properties": {
                    "value": 5
                }
            },
            {
                "id": "levelIndicator2",
                "type": "LevelIndicator",
                "properties": {
                    "chargeLevel": 25
                }
            },
            {
                "id": "switch2",
                "type": "Switch",
                "properties": {
                    "status": True
                }
            } 
        ]
		request["bottomPanelItems"] = [
            {
                "id": "button3",
                "type": "Button",
                "properties": {
                    "text": "Button3 Text"
                }
            },
            {
                "id": "button4",
                "type": "Button",
                "properties": {
                    "text": "Button4 Text"
                }
            },
            {
                "id": "button5",
                "type": "Button",
                "properties": {
                    "text": "Button5 Text"
                 }
             },
             {
                 "id": "button6",
                 "type": "Button",
                 "properties": {
                    "text": "Button6 Text"
                }
            },
            {
                "id": "button7",
                "type": "Button",
                "properties": {
                    "text": "Button7 Text"
                }
            }
        ]
	if input_data == 1:
		request["visiblePanels"] = [
			"leftPanel", "rightPanel"
		]
	if input_data == 2:
		request["updateItem"] = {
			"id": "button1",
			"properties": {
				"text": str(times_button_update_called),
				"color": "green",
				"enabled": False
			}
		}
		times_button_update_called += 1
	if input_data == 3:
		request["visiblePanels"] = []
	consumer_sender.send_json(request)
