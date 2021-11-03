import QtQuick 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import design 1.0

Rectangle {
    id: root

    property bool connectedToServer
    property bool ignoreMessage

    property bool messageStatus
    property int errorCode
    property string errorText

    signal messageHandlingButtonClicked

    anchors.leftMargin: Design.bigMargin
    anchors.topMargin: Design.bigMargin
    anchors.bottomMargin: Design.bigMargin
    anchors.rightMargin: Design.bigMargin
    width: Design.controlMessageBox.width
    height: Design.controlMessageBox.height
    border.color: Design.controlMessageBox.borderColor
    border.width: Design.controlMessageBox.borderSize
    color: Design.controlMessageBox.backgroundColor

    Label {
        id: title
        text: "Control message's response"
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pointSize: Design.fontSize
    }

    GridLayout {
        id: controlGrid
        columns: 2
        rowSpacing: Design.smallMargin
        columnSpacing: Design.smallMargin
        anchors {
            top: title.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
            right: parent.right
            rightMargin: Design.mediumMargin
        }

        Label {
            id: statusLabel
            text: "status"
        }
        ComboBox {
            model: ListModel {
                ListElement { text: "true" }
                ListElement { text: "false" }
            }
            onCurrentIndexChanged: {
                messageStatus = (currentIndex === 0 ? true : false)
            }
        }

        Label {
            text: "errorCode"
        }
        ComboBox {
            model: ListModel {
                ListElement { text: "0" }
                ListElement { text: "1" }
                ListElement { text: "2" }
                ListElement { text: "3" }
                ListElement { text: "4" }
            }
            onCurrentIndexChanged: {
                errorCode = currentIndex
            }
        }

        Label {
            text: "error"
        }
        TextField {
            id: errorDesc
            onTextEdited: {
                errorText = errorDesc.text
            }
        }
    }

    Button {
        id: messageHandlingBtn
        anchors {
            top: controlGrid.bottom
            topMargin: Design.bigMargin
            horizontalCenter: parent.horizontalCenter
        }
        text: (ignoreMessage ? "Handle message" : "Ignore messages")
        enabled: connectedToServer
        background: Rectangle {
            color: Design.defaultButtonColor
        }
        onClicked: {
            messageHandlingButtonClicked()
        }
    }
}
