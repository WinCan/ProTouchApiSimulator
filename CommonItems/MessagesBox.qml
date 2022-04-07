import QtQuick 2.10
import QtQuick.Controls 2.15

import design 1.0

Rectangle {
    id: root

    anchors.leftMargin: Design.bigMargin
    anchors.topMargin:  Design.bigMargin
    anchors.bottomMargin: Design.bigMargin
    anchors.rightMargin:  Design.bigMargin

    border.color: Design.messagesBox.borderColor
    border.width: Design.messagesBox.borderSize

    function logNewMessage(message)
    {
        textEdit.text = message + '\n' + textEdit.text
        scrollView.ScrollBar.vertical.position = 0.0
    }

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
        id: scrollView
        anchors.top: messageTitle.bottom
        anchors.topMargin: Design.smallMargin
        anchors.left: parent.left
        anchors.leftMargin: Design.smallMargin
        anchors.right: parent.right
        anchors.rightMargin: Design.smallMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Design.smallMargin

        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        clip: true

        TextArea {
            id: textEdit

            anchors.fill: parent
            wrapMode: TextEdit.WrapAnywhere
            selectByMouse: true
        }
    }

}
