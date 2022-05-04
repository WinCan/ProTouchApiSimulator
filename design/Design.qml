pragma Singleton
import QtQuick 2.0

QtObject{

    property color backgroundColor: "gainsboro"

    readonly property int smallMargin: 5
    readonly property int mediumMargin: 10
    readonly property int bigMargin: 20

    readonly property int fontSize: 12


    property color acceptButtonColor: "lightgreen"
    property color cancelButtonColor: "lightcoral"
    property color defaultButtonColor: "gold"


    property QtObject informationBox: QtObject {
        property color backgroundColor: "lightskyblue"
        property color borderColor: "grey"

        readonly property int height: 50
        readonly property int width: 500
        readonly property int borderSize: 2
    }

    property QtObject connectionBox: QtObject {
        property color backgroundColor: "lightskyblue"
        property color borderColor: "grey"

        readonly property int height: 300
        readonly property int width: 270
        readonly property int borderSize: 2
    }

    property QtObject videoMessageBox: QtObject {
        property color backgroundColor: "lightskyblue"
        property color borderColor: "grey"

        readonly property int height: 300
        readonly property int width: 270
        readonly property int borderSize: 2
    }

    property QtObject monitoringMessageBox: QtObject {
        property color backgroundColor: "lightskyblue"
        property color borderColor: "grey"

        readonly property int height: 300
        readonly property int width: 350
        readonly property int borderSize: 2
    }

    property QtObject controlMessageBox: QtObject {
        property color backgroundColor: "lightskyblue"
        property color borderColor: "grey"

        readonly property int height: 300
        readonly property int width: 350
        readonly property int borderSize: 2
    }

    property QtObject freeTextBox: QtObject {
        property color backgroundColor: "lightskyblue"
        property color borderColor: "grey"

        readonly property int height: 100
        //readonly property int width:
        readonly property int borderSize: 2
    }

    property QtObject messagesBox: QtObject {
        property color borderColor: "grey"

        readonly property int borderSize: 2
    }

    property QtObject dynamicGui: QtObject {
        property color borderColor: "black"
        readonly property int borderSize: 2
    }

    property QtObject panelEditTab: QtObject {
        property color borderColor: "black"
        property color backgroundColor: "lightskyblue"
        property color textAreaBackgroundColor: "white"
        readonly property int borderSize: 2
        readonly property int textAreaBorderSize: 1
    }

    property QtObject udpVideoTab: QtObject  {
        property color borderColor: "black"
        property color backgroundColor: "lightskyblue"
        property color textEditBackgroundColor: "white"
        readonly property int borderSize: 2
        readonly property int textEditBorderSize: 1
    }
}
