import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import CommonItems 1.0
import design 1.0

import io.qt.MessageGenerator 1.0

Rectangle {
    width: 1340
    height: 800
    color: Design.backgroundColor
    property alias msgGen : msgGen

    MessageGenerator {
        id: msgGen
    }

    Connections {
        target: msgGen

        function onMsgReceived(message) {
            messagesBox.logNewMessage(message)
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
            msgGen.sendMeterCounterValue(meterCounterValue, meterCounterUnit, isMeterCounterLateral)
        }

        onSendInclinationClicked: {
            msgGen.sendInclinationValue(inclinationValue, inclinationUnit);
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

    VideoMessageBox {
        id: videoMessageBox

        anchors.top: informationBox.bottom
        anchors.left: controlMessageBox.right

        connectedToServer: msgGen.connected
        streamingDefaultPort: msgGen.streamingDefaultPort

        onStartVideoStreaming: {
            msgGen.sendStartVideoStreaming(port)
        }

        onPerfromVideoAction: {
            msgGen.sendPerformVideoAction()
        }

        onVideoActionChanged: {
            msgGen.updateVideoAction(videoAction)
        }
    }

    FreeTextBox {
        id: freeTextBox
        anchors.top: connectionBox.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        connectedToServer: msgGen.connected

        function createFreeTextAction(text, x, y, visibleTime, textColor, backColor) {
            msgGen.sendCreateFreeText(text, x, y, visibleTime, textColor, backColor)
        }
    }

    MessagesBox {
        id: messagesBox

        anchors.top: freeTextBox.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
