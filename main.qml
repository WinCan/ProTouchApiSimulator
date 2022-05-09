import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import CommonItems 1.0
import design 1.0

Window {
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

    TabBar
    {
        anchors.top: parent.top
        anchors.right: docsButton.left
        anchors.left: parent.left
        id: bar
        TabButton
        {
            text: "ProTouch API"
            width: 200
        }
        TabButton
        {
            text: "Dynamic GUI"
            width: 200
        }
        TabButton
        {
            text: "UDP Video"
            width: 200
        }
    }

    StackLayout
    {
        anchors.top: bar.bottom
        currentIndex: bar.currentIndex
        Item
        {
            PtApiTab
            {

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

    }
}
