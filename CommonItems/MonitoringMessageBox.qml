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
    property alias inclinationValue: inclinationValue.text
    property bool isMeterCounterLateral: isMeterCounterLateral.checked
    property string meterCounterUnit
    property string inclinationUnit

    signal sendObjectStatusIndClicked
    signal sendMeterCounterStatusIndClicked
    signal sendInclinationClicked

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
        id: meterCounterTopBox
        columns: 3
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


        Label { text: "Meter Counter:"}
        TextField {
            id: meterCounterValue
            Layout.fillWidth: true
            selectByMouse: true
            validator: RegExpValidator {
                regExp: /^[0-9]+([,.][0-9])?[0-9]*$/
            }

        }
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

    GridLayout {
        id: meterCounterBottomBox
        columns: 3
        anchors {
            top: meterCounterTopBox.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        Text {
            text: "Is lateral:"
        }

        CheckBox
        {
            id: isMeterCounterLateral
        }

    Button {
        id: updateMeterCounterBtn
        text: "Send METER_COUNTER_STATUS_IND "
        enabled: connectedToServer
        background: Rectangle {
            color: Design.defaultButtonColor
        }
        onClicked: sendMeterCounterStatusIndClicked()
    }
    }

    GridLayout {
        id: inclinationBox
        columns: 3
        anchors {
            top: meterCounterBottomBox.bottom
            topMargin: Design.mediuMargin
            left: parent.left
            leftMargin: Design.mediumMargin
            right: parent.right
            rightMargin: Design.mediumMargin
        }

        Text {
            text: "Inclination:"
        }
        TextField {
            id:	inclinationValue
            Layout.fillWidth: true
            selectByMouse: true
            validator: RegExpValidator {
                regExp: /^[0-9]+([,.][0-9])?[0-9]*$/
            }

        }
        ComboBox {
            model: ListModel {
                ListElement { text: "rad" }
                ListElement { text: "deg" }
            }
            onCurrentIndexChanged: {
                inclinationUnit = (currentIndex === 0 ? "rad" : "deg")
            }
        }
    }
    Button {
        id: sendInclinationBtn
        text: "Send INCLINATION_VALUE_STATUS_IND"
        anchors {
            top: inclinationBox.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
        }
        enabled: connectedToServer
        background: Rectangle {
            color: Design.defaultButtonColor
        }
        onClicked: sendInclinationClicked()
    }



}
