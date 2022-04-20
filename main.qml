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

    TabBar
    {
        anchors.top: parent.top
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

    }
}
