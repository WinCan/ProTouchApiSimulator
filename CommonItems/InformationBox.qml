import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import design 1.0

Rectangle {
    id: root

    property bool ignoreMessage
    property bool connectedServer

    border.color: Design.informationBox.borderColor
    border.width: Design.informationBox.borderSize

    anchors.topMargin: Design.smallMargin
    anchors.bottomMargin: Design.mediumMargin
    anchors.horizontalCenter: parent.horizontalCenter
    height: Design.informationBox.height
    width: Design.informationBox.width
    color: Design.informationBox.backgroundColor

    Label {
        id: statusTitle
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Status information"
        font.bold: true
        font.pointSize: Design.fontSize
    }

    Label {
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: Design.smallMargin
        anchors.top:  statusTitle.bottom
        text: "STATUS: " + (connectedServer ? "CONNECTED" : "DISCONNECTED")
        background: Rectangle {
            color: (connectedServer? "green" : "red")
        }
    }

    Label {
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: Design.smallMargin
        anchors.top:  statusTitle.bottom
        text: "MESSAGE WILL BE " + (ignoreMessage ? "IGNORED" : "HANDLED")
        background: Rectangle {
            color: (ignoreMessage ? "red" : "green")
        }
    }
}
