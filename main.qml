import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import CommonItems 1.0
import design 1.0

import io.qt.MessageGenerator 1.0

Window {
    visible: true
    width: 1130
    height: 700
    title: "Client simulator"
    minimumWidth: 1130
    minimumHeight: 700
    color: Design.backgroundColor

    MessageGenerator {
        id: msgGen
    }

    Connections {
        target: msgGen

        function onMsgReceived(message) {
            messagesBox.textArea.append(message)
        }
    }

    InformationBox {
        id: informationBox

        anchors.top: parent.top

        ignoreMessage: msgGen.ignoreMessage
        connectedServer: msgGen.connected
    }

    ConnectionBox {
        id: connectionBox

        anchors.top: informationBox.bottom
        anchors.left: parent.left

        connectedToServer: msgGen.connected

        onConnectToServerClicked: {
            msgGen.connectToHost(ip, port)
        }

        onDisconnectFromServerClicked: {
            msgGen.disconnectFromHost()
        }
    }

    MonitoringMessageBox {
        id: monitoringMessageBox

        anchors.top: informationBox.bottom
        anchors.left: connectionBox.right

        connectedToServer: msgGen.connected

        onSendObjectStatusIndClicked: {
            msgGen.sendObjectValue(object, value)
        }

        onSendMeterCounterStatusIndClicked: {
            msgGen.sendMeterCounterValue(meterCounterValue)
        }
    }

    ControlMessageBox {
        id: controlMessageBox

        anchors.top: informationBox.bottom
        anchors.left: monitoringMessageBox.right

        connectedToServer: msgGen.connected
        ignoreMessage: msgGen.ignoreMessage

        onErrorCodeChanged: {
            msgGen.updateErrorCode(errorCode)
        }

        onMessageStatusChanged: {
            msgGen.updateMsgStatus(messageStatus)
        }

        onErrorTextChanged: {
            msgGen.updateErrorDsc(errorText)
        }

        onMessageHandlingButtonClicked: {
            msgGen.ignoreMessage = !msgGen.ignoreMessage
        }
    }

    MessagesBox {
        id: messagesBox

        anchors.top: connectionBox.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }





}
