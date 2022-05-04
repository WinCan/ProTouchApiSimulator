import QtQuick 2.0
import QtQuick.Controls 2.15

Rectangle {
    id: panelRoot
    property string panelName
    property string internalPanelName
    property string defaultValue
    property alias config: textArea.text

    border.color: Design.panelEditTab.borderColor
    border.width: Design.panelEditTab.borderSize
    anchors.topMargin: Design.smallMargin
    anchors.bottomMargin: Design.smallMargin
    anchors.leftMargin: Design.smallMargin
    anchors.rightMargin: Design.smallMargin
    color: Design.panelEditTab.backgroundColor

    Rectangle
    {
        id: titleRect

        anchors.top: panelRoot.top
        anchors.left: panelRoot.left
        anchors.right: panelRoot.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        height: 50
        color: "transparent"

        Text {
            id: title
            text: panelName
            font.bold: true
            anchors.top: titleRect.top
            anchors.bottom: titleRect.bottom
            anchors.left: titleRect.left
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            id: clearButton
            anchors.bottom: titleRect.bottom
            anchors.top: titleRect.top
            anchors.right: titleRect.right
            anchors.topMargin: Design.smallMargin
            anchors.bottomMargin: Design.smallMargin
            anchors.leftMargin: Design.smallMargin
            anchors.rightMargin: Design.smallMargin
            text: "Clear"
            onClicked: {
                textArea.text = "[]"
            }
        }

        Button {
            id: defaultButton
            anchors.bottom: titleRect.bottom
            anchors.top: titleRect.top
            anchors.right: clearButton.left
            anchors.topMargin: Design.smallMargin
            anchors.bottomMargin: Design.smallMargin
            anchors.leftMargin: Design.smallMargin
            anchors.rightMargin: Design.smallMargin
            text: "Default"
            onClicked: {
                textArea.text = defaultValue
            }
        }
    }

    ScrollView
    {
        id: scrollView
        anchors.top: titleRect.bottom
        anchors.bottom: panelRoot.bottom
        anchors.left: panelRoot.left
        anchors.right: panelRoot.right
        anchors.leftMargin: Design.mediumMargin
        anchors.bottomMargin: Design.mediumMargin
        anchors.rightMargin: Design.mediumMargin
        background: Rectangle {
            color: Design.panelEditTab.textAreaBackgroundColor
            border.color: Design.panelEditTab.borderColor
            border.width: Design.panelEditTab.textAreaBorderSize
        }

        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        TextArea
        {
            id: textArea
            text: defaultValue
            width: scrollView.width
            selectByMouse: true
        }
    }
}
