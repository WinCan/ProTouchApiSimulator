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

        onSendMonitoringMessage: {
            msgGen.sendMonitoringMessage(messageName, payload)
        }
    }

    StackLayout
    {
        id: restOfMessagesBox
        anchors.top: informationBox.bottom
        anchors.left: monitoringMessageBox.right
        width: Design.controlMessageBox.width
        height: Design.controlMessageBox.height
        anchors.leftMargin: Design.bigMargin
        anchors.topMargin: Design.bigMargin
        anchors.bottomMargin: Design.bigMargin
        anchors.rightMargin: Design.bigMargin
        currentIndex: restBar.currentIndex

        ControlMessageBox {
            id: controlMessageBox

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

        Rectangle
        {
            id: settingsBox
            border.color: Design.controlMessageBox.borderColor
            border.width: Design.controlMessageBox.borderSize
            color: Design.controlMessageBox.backgroundColor

            Label {
                id: settingsTitle
                text: "Ask for setting"
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pointSize: Design.fontSize
            }
            ComboBox {
                id: settingComboBox
                anchors.top: settingsTitle.bottom
                anchors.left: parent.left
                anchors.topMargin: Design.mediumMargin
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
                model: ["language", "cameraResolution"]
            }
            Button {
                anchors.top: settingComboBox.bottom
                anchors.left: parent.left
                anchors.topMargin: Design.mediumMargin
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
                text: "Send"
                onClicked: {
                    msgGen.sendSettingInfoReq(settingComboBox.currentText)
                }
            }
        }
        Rectangle
        {
            id: setupBox
            border.color: Design.controlMessageBox.borderColor
            border.width: Design.controlMessageBox.borderSize
            color: Design.controlMessageBox.backgroundColor

            Label {
                id: setupTitle
                text: "Setup messages"
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pointSize: Design.fontSize
            }

            Label {
                id: pingSubtitle
                text: "Ping"
                font.bold: true
                anchors.top: setupTitle.bottom
                anchors.left: parent.left
                anchors.topMargin: Design.mediumMargin
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
            }

            Button {
                id: pingButton
                anchors.top: pingSubtitle.bottom
                anchors.left: parent.left
                anchors.topMargin: Design.mediumMargin
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
                text: "Send PING"
                onClicked: {
                    msgGen.sendSetupMessage("PING", {});
                }
            }

            Label {
                id: forceUnitSubtitle
                text: "Force unit"
                font.bold: true
                anchors.top: pingButton.bottom
                anchors.left: parent.left
                anchors.topMargin: Design.mediumMargin
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
            }

            ComboBox {
                id: forceUnitMeasureCombobox
                width: 100
                anchors.top: forceUnitSubtitle.bottom
                anchors.left: parent.left
                anchors.topMargin: Design.mediumMargin
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
                textRole: "measure"
                valueRole: "units"
                model: [
                    { measure: "distance", units: ["meters", "feet"] }
                ]
            }

            ComboBox {
                id: forceUnitUnitCombobox
                width: 100
                anchors.top: forceUnitMeasureCombobox.top
                anchors.left: forceUnitMeasureCombobox.right
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
                model: [...forceUnitMeasureCombobox.currentValue, "null"]
            }

            Button {
                width: 50
                anchors.top: forceUnitUnitCombobox.top
                anchors.left: forceUnitUnitCombobox.right
                anchors.leftMargin: Design.mediumMargin
                anchors.rightMargin: Design.mediumMargin
                text: "Send"
                onClicked: {
                    msgGen.sendSetupMessage("FORCE_CHOOSING_UNIT",
                                            {
                                               "measure": forceUnitMeasureCombobox.currentText,
                                               "unit": forceUnitUnitCombobox.currentValue === "null" ? null
                                                                                                     : forceUnitUnitCombobox.currentValue
                                            })
                }
            }
        }
    }

    TabBar {
        id: restBar
        anchors.bottom: restOfMessagesBox.bottom
        anchors.left: restOfMessagesBox.left
        readonly property int tabWidth: restOfMessagesBox.width / 3
        TabButton {
            text: "Control"
            width: restBar.tabWidth
        }
        TabButton {
            text: "Settings"
            width: restBar.tabWidth
        }
        TabButton {
            text: "Setup"
            width: restBar.tabWidth
        }
    }


    VideoMessageBox {
        id: videoMessageBox

        anchors.top: informationBox.bottom
        anchors.left: restOfMessagesBox.right

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
