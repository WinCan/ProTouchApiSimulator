#include "DynamicGuiController.h"
#include <QStringLiteral>

constexpr static const char PUSH_ADDR[] = "tcp://127.0.0.1:52943";
constexpr static const char PULL_ADDR[] = "tcp://127.0.0.1:52944";

DynamicGuiController::DynamicGuiController(QObject* parent)
    : QObject{parent}
    , ctx{1}
    , dealer{ctx, ZMQ_DEALER}
{
}

void DynamicGuiController::enable()
{
    dealer.connect(PUSH_ADDR);
}

void DynamicGuiController::disable()
{
    dealer.disconnect(PUSH_ADDR);
}


QString DynamicGuiController::defaultLeftPanelConfig() const
{
    static auto msg = QStringLiteral(
R"AAAA([
    {
        "id": "joystick1",
        "type": "Joystick"
    },
    {
        "id": "button1",
        "type": "Button",
        "properties": {
            "text": "Button1 text"
        }
    },
    {
        "id": "text1",
        "type": "Text",
        "properties": {
            "text": "Left text"
        }
    },
    {
        "id": "label1",
        "type": "Label",
        "properties": {
            "text": "Label left text"
        }
    },
    {
        "id": "spinBox1",
        "type": "Spinbox",
        "properties": {
            "value": 5,
            "stepSize" : 10
        }
    },
    {
        "id": "levelIndicator1",
        "type": "LevelIndicator",
        "properties": {
            "chargeLevel": 25
        }
    },
    {
        "id": "switch1",
        "type": "Switch",
        "properties": {
            "status": true
        }
    },
    {
        "id": "meterCounter1",
        "type": "MeterCounter"
    }
])AAAA");
    return msg;
}

QString DynamicGuiController::defaultRightPanelConfig() const
{
    static auto msg = QStringLiteral(
R"AAAA([
    {
        "id": "joystick2",
        "type": "Joystick"
    },
    {
        "id": "button2",
        "type": "Button",
        "properties": {
            "text": "Button2 text"
        }
    },
    {
        "id": "text2",
        "type": "Text",
        "properties": {
            "text": "Right text"
        }
    },
    {
        "id": "label2",
        "type": "Label",
        "properties": {
            "text": "Label right text"
        }
    },
    {
        "id": "spinBox2",
        "type": "Spinbox",
        "properties": {
            "value": 5
        }
    },
    {
        "id": "levelIndicator2",
        "type": "LevelIndicator",
        "properties": {
            "chargeLevel": 25
        }
    },
    {
        "id": "switch2",
        "type": "Switch",
        "properties": {
            "status": true
        }
    }
])AAAA");
    return msg;
}

QString DynamicGuiController::defaultBottomPanelConfig() const
{
    static auto msg = QStringLiteral(
R"AAAA([
    {
        "id": "button3",
        "type": "Button",
        "properties": {
            "text": "Button3 Text"
        }
    },
    {
        "id": "button4",
        "type": "Button",
        "properties": {
            "text": "Button4 Text"
        }
    },
    {
        "id": "button5",
        "type": "Button",
        "properties": {
            "text": "Button5 Text"
         }
     },
     {
         "id": "button6",
         "type": "Button",
         "properties": {
            "text": "Button6 Text"
        }
    },
    {
        "id": "button7",
        "type": "Button",
        "properties": {
            "text": "Button7 Text"
        }
    }
])AAAA");
    return msg;
}

void DynamicGuiController::send(const QString& str)
{
    auto byteArray = str.toUtf8();
    zmq::message_t msg{byteArray.data(), static_cast<size_t>(byteArray.size())};
    dealer.send(msg);
}
