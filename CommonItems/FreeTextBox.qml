import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import design 1.0

Rectangle {
    id: root
    property bool connectedToServer

    anchors.leftMargin: Design.bigMargin
    anchors.topMargin: Design.bigMargin
    anchors.bottomMargin: Design.bigMargin
    anchors.rightMargin: Design.bigMargin
    height: Design.freeTextBox.height
    border.color: Design.controlMessageBox.borderColor
    border.width: Design.controlMessageBox.borderSize
    color: Design.controlMessageBox.backgroundColor

    function createFreeTextAction(text, x, y, visibleTime, textColor, backColor)
    {}

    readonly property var availableColors: ["Black",
                                            "DarkBlue",
                                            "DarkGreen",
                                            "DarkCyan",
                                            "DarkRed",
                                            "DarkMagenta",
                                            "Brown",
                                            "Gray",
                                            "DarkGray",
                                            "Blue",
                                            "Green",
                                            "Cyan",
                                            "Red",
                                            "Magenta",
                                            "Yellow",
                                            "White"]

    Label {
        id: title
        text: "Create free text"
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pointSize: Design.fontSize
    }

    GridLayout
    {
            anchors.top: title.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 7
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Text"
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "X"
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Y"
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Visible [s]"
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Text Color"
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Back Color"
            }
            Label {

            }

            TextField {
                id: textFieldInput
                selectByMouse: true
                Layout.preferredWidth:  200
            }
            SpinBox {
                id: xInput
                editable: true
                value: 1
                from: 0
                to: 100000
            }
            SpinBox {
                id: yInput
                editable: true
                value: 1
                from: 0
                to: 100000
            }
            SpinBox {
                id: timeInput
                editable: true
                value: 1
                from: 1
                to: 100
            }
            ComboBox {
                id: textColorInput
                model: availableColors
            }
            ComboBox {
                id: backColorInput
                model: availableColors
            }

            Button {
                text: "Send"
                enabled: connectedToServer
                onClicked: {
                    root.createFreeTextAction(textFieldInput.text,
                                              xInput.value,
                                              yInput.value,
                                              timeInput.value,
                                              availableColors[textColorInput.currentIndex],
                                              availableColors[backColorInput.currentIndex])
                }

            }

    }
}
