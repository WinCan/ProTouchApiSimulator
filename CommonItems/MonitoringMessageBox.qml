import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import design 1.0

Rectangle {
    id: root

    property bool connectedToServer
    property alias object: object.text
    property alias value: value.text
    property alias meterCounterValue: meterCounterValue.text
    property string meterCounterUnit

    signal sendObjectStatusIndClicked
    signal sendMeterCounterStatusIndClicked

    anchors.leftMargin: Design.bigMargin
    anchors.topMargin: Design.bigMargin
    anchors.bottomMargin: Design.bigMargin
    anchors.rightMargin: Design.mediumMargin
    width: Design.monitoringMessageBox.width
    height: Design.monitoringMessageBox.height
    color: Design.monitoringMessageBox.backgroundColor

    border.color: Design.monitoringMessageBox.borderColor
    border.width: Design.monitoringMessageBox.borderSize

    Label {
        id: updateTitle

        anchors.horizontalCenter: parent.horizontalCenter
        text: "Monitoring messages"
        font.bold: true
        font.pointSize: Design.fontSize
    }

    GridLayout {
        id: updateGrid
        columns: 2
        rowSpacing: Design.smallMargin
        columnSpacing: Design.smallMargin
        anchors {
            top: updateTitle.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
            right: parent.right
            rightMargin: Design.mediumMargin
        }

        Label { text: "Object:" }
        TextField {
            id: object
            selectByMouse: true
        }

        Label { text: "Value:"}
        TextField {
            id: value
            selectByMouse: true
        }
    }

    Button {
        id: updateBtn
        anchors {
            top: updateGrid.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        text: "Send OBJECT_STATUS_IND "
        enabled: connectedToServer
        background: Rectangle {
            color: Design.defaultButtonColor
        }
        onClicked: sendObjectStatusIndClicked()
    }

    GridLayout {
        id: meterCounterBox
        columns: 2
        rowSpacing: Design.smallMargin
        columnSpacing: Design.smallMargin
        anchors {
            top: updateBtn.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
            right: parent.right
            rightMargin: Design.mediumMargin
        }


        Label { text: "Meter Counter Value:"}
        TextField {
            id: meterCounterValue
            width: 10
            selectByMouse: true
            validator: RegExpValidator {
                regExp: /^[0-9]+([,.][0-9])?[0-9]*$/
            }

        }
    }

    GridLayout {
        id: meterCounterUnitBox
        columns: 2
        rowSpacing: Design.smallMargin
        columnSpacing: Design.smallMargin
        anchors {
            top: meterCounterBox.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
            right: parent.right
            rightMargin: Design.mediumMargin
        }

        Label { text: "Meter Counter Unit:"}
        ComboBox {
            model: ListModel {
                ListElement { text: "meter" }
                ListElement { text: "feet" }
            }
            onCurrentIndexChanged: {
                meterCounterUnit = (currentIndex === 0 ? "meter" : "feet")
            }
        }

    }

    Button {
        id: updateMeterCounterBtn
        anchors {
            top: meterCounterUnitBox.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        text: "Send METER_COUNTER_STATUS_IND "
        enabled: connectedToServer
        background: Rectangle {
            color: Design.defaultButtonColor
        }
        onClicked: sendMeterCounterStatusIndClicked()
    }
}
