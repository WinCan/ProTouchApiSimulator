import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import CommonItems 1.0
import design 1.0
import io.qt.PluginLoader 1.0

Window {
    id: window
    visible: true
    width: 1340
    height: 850
    title: "Client simulator"
    minimumWidth: 1340
    minimumHeight: 800
    color: Design.backgroundColor

    Button
    {
        id: docsButton
        width: 200
        text: "Documentation"
        height: bar.height
        anchors.top: parent.top
        anchors.right: parent.right
        onClicked: {
            Qt.openUrlExternally("https://github.com/WinCan/ProTouchApiSimulator/raw/main/ProTouch%20API%20Documentation.pdf")
        }
    }

    Component
    {
        id: newTabButton
        TabButton {
            text: "dummy"
            width: 150
        }
    }

    TabBar
    {
        anchors.top: parent.top
        anchors.right: docsButton.left
        anchors.left: parent.left
        id: bar
        TabButton
        {
            text: "ProTouch API"
            width: 150
        }
        TabButton
        {
            text: "Dynamic GUI"
            width: 150
        }
        TabButton
        {
            text: "UDP Video"
            width: 150
        }

        function addEntry(name)
        {
            newTabButton.createObject(bar, {"text": name});
        }
    }

    StackLayout
    {
        id: layout
        anchors.top: bar.bottom
        currentIndex: bar.currentIndex
        Item
        {
            PtApiTab
            {
                id: ptApiTab
            }
        }
        Item
        {
            DynamicUiTab
            {

            }
        }
        Item
        {
            UdpVideoTab
            {

            }
        }

        function addEntry(entry, controller)
        {
            entry.createObject(layout, {"controller": controller});
        }
    }

    Version {
        id: gitRevision
        anchors.right: window.contentItem.right
        anchors.bottom: window.contentItem.bottom
        anchors.rightMargin: 3
    }

    PluginLoader
    {
        id: pluginLoader
    }

    Text {
        anchors.right: window.contentItem.right
        anchors.bottom: gitRevision.top
        anchors.rightMargin: 3
        text: "Api ver: 2"
    }

    Component.onCompleted: {
        pluginLoader.addPlugins(bar, layout, ptApiTab.msgGen);
    }
}
