import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import io.qt.UdpVideoController 1.0

Rectangle {
    id: root
    anchors.fill: parent
    property bool isRunning: false
    anchors.topMargin: Design.mediumMargin
    anchors.bottomMargin: Design.mediumMargin
    anchors.leftMargin: Design.mediumMargin
    anchors.rightMargin: Design.mediumMargin
    UdpVideoController
    {
        id: controller
    }

    Loader {
        Component {
            id: noGstreamer
            Text {
                text: "Missing GStreamer libraries. To enable creating testing UDP stream, move this .exe directory above ProTouch.exe, it's usually C:/Program Files/WinCan/ProTouch."
            }
        }
        Component {
            id: foundGstreamer
            Rectangle {
                property int margin: Design.mediumMargin
                anchors.topMargin: margin
                anchors.bottomMargin: margin
                anchors.leftMargin: margin
                anchors.rightMargin: margin
                border.width: Design.udpVideoTab.borderSize
                border.color: Design.udpVideoTab.borderColor
                color: Design.udpVideoTab.backgroundColor
                width: sourceTxt.width + ipTxt.width + portTxt.width + startButton.width + 2 * margin
                height: sourceTxt.height + videoSourceComboBox.height + 2 * margin
                id: foundGstreamerRect

                Rectangle {
                    id: sourceTxt
                    anchors.top: foundGstreamerRect.top
                    anchors.left: foundGstreamerRect.left
                    anchors.topMargin: margin
                    anchors.leftMargin: margin
                    width: 150
                    height: 50
                    color: "transparent"
                    Text {
                        text: "Source"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                ComboBox {
                    id: videoSourceComboBox
                    anchors.top: sourceTxt.bottom
                    anchors.left: sourceTxt.left
                    width: sourceTxt.width
                    height: sourceTxt.height
                    enabled: ! root.isRunning
                    model: ["videotestsrc"]
                }

                Rectangle {
                    id: ipTxt
                    anchors.top: sourceTxt.top
                    anchors.left: sourceTxt.right
                    width: 150
                    height: sourceTxt.height
                    color: "transparent"
                    Text {
                        text: "Address"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                TextField {
                    id: ipTextField
                    anchors.top: ipTxt.bottom
                    anchors.left: ipTxt.left
                    width: ipTxt.width
                    height: videoSourceComboBox.height
                    enabled: ! root.isRunning
                    background: Rectangle {
                        border.width: Design.udpVideoTab.textEditBorderSize
                        border.color: Design.udpVideoTab.borderColor
                        color: Design.udpVideoTab.textEditBackgroundColor
                    }
                    selectByMouse: true
                    text: "127.0.0.1"
                }

                Rectangle {
                    id: portTxt
                    anchors.top: ipTxt.top
                    anchors.left: ipTxt.right
                    width: 75
                    height: sourceTxt.height
                    color: "transparent"
                    Text {
                        text: "Port"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                TextField {
                    id: portTextField
                    anchors.top: portTxt.bottom
                    anchors.left: portTxt.left
                    width: portTxt.width
                    height: videoSourceComboBox.height
                    enabled: ! root.isRunning
                    background: Rectangle {
                        border.width: Design.udpVideoTab.textEditBorderSize
                        border.color: Design.udpVideoTab.borderColor
                        color: Design.udpVideoTab.textEditBackgroundColor
                    }
                    selectByMouse: true
                    text: "5000"
                }

                Button {
                    id: startButton
                    anchors.top: portTxt.top
                    anchors.left: portTxt.right
                    width: 100
                    height: sourceTxt.height
                    enabled: ! root.isRunning
                    text: "Start"
                    onClicked: {
                        controller.startPipeline(videoSourceComboBox.currentText,
                                                 ipTextField.text,
                                                 portTextField.text)
                        root.isRunning = true
                    }
                }
                Button {
                    id: stopButton
                    anchors.top: startButton.bottom
                    anchors.left: portTextField.right
                    width: startButton.width
                    height: videoSourceComboBox.height
                    enabled: root.isRunning
                    text: "Stop"
                    onClicked: {
                        controller.stop()
                        root.isRunning = false
                    }
                }
            }
        }
        sourceComponent: controller.hasGstreamer() ? foundGstreamer : noGstreamer
    }
}
