import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import design 1.0

Rectangle {
    id: root

    property bool connectedToServer
    signal connectToServerClicked
    signal disconnectFromServerClicked

    property alias ip: ip.text
    property alias port: port.text

    anchors.leftMargin: Design.bigMargin
    anchors.topMargin: Design.bigMargin
    anchors.bottomMargin: Design.bigMargin
    anchors.rightMargin: Design.smallMargin
    width: Design.connectionBox.width
    height: Design.connectionBox.height
    color: Design.connectionBox.backgroundColor

    border.color: Design.connectionBox.borderColor
    border.width: Design.connectionBox.borderSize

    Label {
        id: connectionTitle
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Connection"
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

        Label { text: "IP:" }
        TextField {
            id: ip

        }

        Label { text: "Port:"}
        TextField {
            id: port
            validator: IntValidator{}
        }
    }

    Button {
        id: connectBtn
        anchors {
            top: connectionGrid.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        text: "Connect to server"
        enabled: !connectedToServer
        background: Rectangle {
            color: Design.acceptButtonColor
        }
        onClicked: connectToServerClicked(ip.text, port.text)
    }

    Button {
        id: disconnectBtn
        anchors {
            top: connectBtn.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        enabled: connectedToServer
        text: "Disconnect from server"
        background: Rectangle {
            color: Design.cancelButtonColor
        }
        onClicked: disconnectFromServerClicked()
    }
}

