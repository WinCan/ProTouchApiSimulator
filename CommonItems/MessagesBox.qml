import QtQuick 2.10
import QtQuick.Controls 2.15

import design 1.0

Rectangle {
    id: root

    property alias textArea: textEdit

    anchors.leftMargin: Design.bigMargin
    anchors.topMargin:  Design.bigMargin
    anchors.bottomMargin: Design.bigMargin
    anchors.rightMargin:  Design.bigMargin

    border.color: Design.messagesBox.borderColor
    border.width: Design.messagesBox.borderSize

    Label {
        id: messageTitle
        text: "Messages received:"
        font.bold: true
        font.pointSize: Design.fontSize
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin:  Design.smallMargin
        anchors.topMargin: Design.smallMargin
    }

    ScrollView {
        anchors.top: messageTitle.bottom
        anchors.topMargin: Design.smallMargin
        anchors.left: parent.left
        anchors.leftMargin: Design.smallMargin
        anchors.right: parent.right
        anchors.rightMargin: Design.smallMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Design.smallMargin

        clip: true

        TextEdit {
            id: textEdit

            anchors.fill: parent
            wrapMode: TextEdit.WrapAnywhere
            selectByMouse: true
        }
    }
}
