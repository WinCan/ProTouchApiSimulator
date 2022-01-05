import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import design 1.0

Rectangle {
    id: root

    property bool connectedToServer
    property string streamingDefaultPort

    property int videoAction

    signal startVideoStreaming
    signal perfromVideoAction

    property alias port: port.text

    anchors.leftMargin: Design.bigMargin
    anchors.topMargin: Design.bigMargin
    anchors.bottomMargin: Design.bigMargin
    anchors.rightMargin: Design.smallMargin
    width: Design.videoMessageBox.width
    height: Design.videoMessageBox.height
    color: Design.videoMessageBox.backgroundColor

    border.color: Design.videoMessageBox.borderColor
    border.width: Design.videoMessageBox.borderSize

    Label {
        id: connectionTitle
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Video Message"
        font.bold: true
        font.pointSize: Design.fontSize
    }

    GridLayout {
        id: connectionGrid
        columns: 2
        rowSpacing: Design.smallMargin
        columnSpacing: Design.smallMargin
        anchors {
            top: connectionTitle.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }

        Label { text: "Port:"}
        TextField {
            id: port
            selectByMouse: true
            text: streamingDefaultPort
            validator: IntValidator{}
        }
    }

    Button {
        id: startVideoBtn
        anchors {
            top: connectionGrid.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        text: "Start UDP video streaming"
        enabled: connectedToServer
        background: Rectangle {
            color: Design.defaultButtonColor
        }
        onClicked: startVideoStreaming()
    }

    GridLayout {
        id: performVideoAction
        columns: 2
        rowSpacing: Design.smallMargin
        columnSpacing: Design.smallMargin
        anchors {
            top: startVideoBtn.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        Label {
            id: statusLabel
            text: "videoAction"
        }
        ComboBox {
            model: ListModel {
                ListElement { text: "Stop" }
                ListElement { text: "Pause" }
                ListElement { text: "Resume" }
            }
            onCurrentIndexChanged: {
                videoAction = currentIndex
            }
        }
    }

    Button {
        id: stopVideoBtn
        anchors {
            top: performVideoAction.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        text: "Perform Video Action"
        enabled: connectedToServer
        background: Rectangle {
            color: Design.defaultButtonColor
        }
        onClicked: perfromVideoAction()
    }
}

