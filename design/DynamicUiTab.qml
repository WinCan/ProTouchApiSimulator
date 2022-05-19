import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import io.qt.DynamicGuiController 1.0

Rectangle {
    id: dynamicUi
    width: 1340
    height: 800
    color: Design.backgroundColor


    DynamicGuiController
    {
        id: controller
    }

    Rectangle
    {
        id: topBar
        width: dynamicUi.width
        height: 50

        TextField
        {
            id: dynamicUiIp
            text: "127.0.0.1"
            anchors.left: topBar.left
            anchors.leftMargin: 20
            anchors.top: topBar.top
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.bottom: topBar.bottom
            verticalAlignment: Text.AlignVCenter
            width: 120
            enabled: ! isEnabledSwitch.checked
        }

        Switch
        {
            id: isEnabledSwitch
            anchors.left: dynamicUiIp.right
            anchors.top: dynamicUiIp.top
            anchors.bottom: dynamicUiIp.bottom
            checked: false
            onCheckedChanged: {
                if(checked)
                {
                    controller.enable(dynamicUiIp.text)
                }
                else
                {
                    controller.disable(dynamicUiIp.text)
                }
            }
        }

        Text
        {
            id: enableTxt
            text: "Enable"
            anchors.left: isEnabledSwitch.right
            anchors.top: topBar.top
            anchors.bottom: topBar.bottom
            verticalAlignment: Text.AlignVCenter
        }
        Button
        {
            id: sendConfigButtion
            text: "Send Configuration"
            anchors.right: topBar.right
            anchors.top: topBar.top
            anchors.bottom: topBar.bottom
            anchors.topMargin: Design.smallMargin
            anchors.bottomMargin: Design.smallMargin
            anchors.leftMargin: Design.smallMargin
            anchors.rightMargin: Design.smallMargin
            enabled: isEnabledSwitch.checked
            onClicked: {
                let msg = {};
                for(const panel of [leftPanel, rightPanel, bottomPanel])
                {
                    try {
                        msg[panel.internalPanelName] = JSON.parse(panel.config)
                    } catch(e) {
                        console.error("unabled to parse config for " + panel.panelName + ", aborting sending")
                        return
                    }
                }
                controller.send(JSON.stringify(msg))
            }
        }
    }
    Rectangle
    {
        anchors.top: topBar.bottom
        anchors.bottom: dynamicUi.bottom
        width: dynamicUi.width
        id: editPanelsRect
        PanelEditTab
        {
            id: leftPanel
            anchors.left: editPanelsRect.left
            anchors.top: editPanelsRect.top
            anchors.bottom: editPanelsRect.bottom
            width: editPanelsRect.width / 3
            panelName: "Left Panel"
            internalPanelName: "leftPanel"
            defaultValue: controller.defaultLeftPanelConfig()
        }
        PanelEditTab
        {
            id: bottomPanel
            anchors.left: leftPanel.right
            anchors.top: editPanelsRect.top
            anchors.bottom: editPanelsRect.bottom
            width: editPanelsRect.width / 3
            panelName: "Bottom Panel"
            internalPanelName: "bottomPanel"
            defaultValue: controller.defaultBottomPanelConfig()
        }
        PanelEditTab
        {
            id: rightPanel
            anchors.top: editPanelsRect.top
            anchors.left: bottomPanel.right
            anchors.right: editPanelsRect.right
            width: editPanelsRect.width / 3
            anchors.bottom: editPanelsRect.bottom
            panelName: "Right Panel"
            internalPanelName: "rightPanel"
            defaultValue: controller.defaultRightPanelConfig()
        }
    }
}
