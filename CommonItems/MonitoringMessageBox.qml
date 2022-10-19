import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import design 1.0

Rectangle {
    id: root

    property bool connectedToServer
    property alias object: object.text
    property alias value: value.text
    property string meterCounterUnit
    property string inclinationUnit

    signal sendObjectStatusIndClicked
    signal sendMeterCounterStatusIndClicked
    signal sendInclinationClicked
    signal sendMonitoringMessage(var messageName, var payload)

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

    Button {
        id: sendMonitoringMessageButton
        anchors.top: updateTitle.bottom
        anchors.topMargin: Design.mediumMargin
        anchors.left: parent.left
        anchors.leftMargin: Design.mediumMargin

        width: 75
        text: "SEND"

        onClicked: {
            sendMonitoringMessage(messageName.currentText, payloadLayout.currentChildren.getPayload())
        }
    }

    ComboBox
    {
        anchors.topMargin: Design.mediumMargin
        anchors.top: updateTitle.bottom
        anchors.left: sendMonitoringMessageButton.right
        anchors.leftMargin: Design.mediumMargin
        anchors.right: parent.right
        anchors.rightMargin: Design.mediumMargin

        id: messageName
        model: ["OBJECT_STATUS_IND", "METER_COUNTER_STATUS_IND", "INCLINATION_VALUE_STATUS_IND", "DYNAMIC_UI_VISIBILITY_IND", "SHOW_NOTIFICATION_IND"]
    }


    StackLayout
    {
        anchors {
            top: messageName.bottom
            topMargin: Design.mediumMargin
            left: parent.left
            leftMargin: Design.mediumMargin
            right: parent.right
            rightMargin: Design.mediumMargin
        }
        height: children[currentIndex].height
        currentIndex: messageName.currentIndex
        property var currentChildren: children[currentIndex]
        id: payloadLayout
        Item {
            GridLayout {
                id: updateGrid
                columns: 2
                rowSpacing: Design.smallMargin
                columnSpacing: Design.smallMargin
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

            function getTypedValue()
            {
                const isOneOf = (arr)=>arr.some(type=>object.text.toLowerCase().includes(type))

                if(isOneOf(["label", "text"]))
                {
                    return value.text
                }
                if(isOneOf(["spinbox", "levelindicator", "slider"]))
                {
                    return parseFloat(value.text)
                }
                if(isOneOf(["switch"]))
                {
                    return value.text === "true"
                }
                console.log("does not know how to treat value of " + object.text + ", treating as string")
                return value.text
            }

            function getPayload()
            {
                return {
                    "object": object.text,
                    "value": getTypedValue()
                }
            }
        }

        Item {
            GridLayout {
                id: meterCounterTopBox
                columns: 2
                rowSpacing: Design.smallMargin
                columnSpacing: Design.smallMargin

                TextField {
                    id: meterCounterValue
                    Layout.preferredWidth: 100
                    selectByMouse: true
                    validator: RegExpValidator {
                        regExp: /^-?[0-9]+([,.][0-9])?[0-9]*$/
                    }

                }
                ComboBox {
                    model: ListModel {
                        ListElement { text: "meter" }
                        ListElement { text: "feet" }
                    }
                    id: unitComboBox
                }
                Text {
                    text: "Is lateral:"
                }

                CheckBox {
                    id: isMeterCounterLateral
                }
            }

            function getPayload() {
                return {
                    "value": parseFloat(meterCounterValue.text),
                    "unit": unitComboBox.currentText,
                    "isLateral": isMeterCounterLateral.checked
                }
            }
        }

        Item {

            GridLayout {
                id: inclinationBox
                columns: 2
                rowSpacing: Design.smallMargin
                columnSpacing: Design.smallMargin

                TextField {
                    id:	inclinationValue
                    Layout.preferredWidth: 100
                    selectByMouse: true
                    validator: RegExpValidator {
                    regExp: /^-?[0-9]+([,.][0-9])?[0-9]*$/
                    }

                }
                ComboBox {
                    id: inclinationUnit
                    model: ["rad", "deg", "percent"]
                }
            }

            function getPayload() {
                return {
                    "value": parseFloat(inclinationValue.text),
                    "unit": inclinationUnit.currentText
                }
            }
        }

        Item {
            RowLayout {
                spacing: Design.smallMargin
                id: dynamicUiVisibilityBox

                Text {
                    text: "Is visible: "
                }

                CheckBox {
                    id: isUiVisible
                }
            }

            function getPayload() {
                return {
                    "visible": isUiVisible.checked
                }
            }
        }

        Item {
            ColumnLayout {
                spacing: Design.smallMargin
                TextField {
                    id: notificationText
                    Layout.fillWidth: true
                    selectByMouse: true
                    }

                ComboBox {
                    id: notificationType
                    model: ["success", "info", "warning", "error", "errorWithConfirm"]
                }
            }
            function getPayload() {
                return {
                    "type": notificationType.currentText,
                    "text": notificationText.text
                }
            }
        }
    }
}
