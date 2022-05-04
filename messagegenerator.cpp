#include "messagegenerator.h"
#include <memory>

#include <QDebug>
#include <QByteArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QHostAddress>

MessageGenerator::MessageGenerator(QObject *parent) :
    QObject(parent),
    m_client(std::make_unique<TcpClient>("localhost", 8095))
{
    QObject::connect(m_client.get(), &TcpClient::connected, this, [this]()
    {   m_isConnected = true;
        emit connectionChanged();
    });
    QObject::connect(m_client.get(), &TcpClient::disconnected, this, [this]()
    {   m_isConnected = false;
        emit connectionChanged();
    });
    QObject::connect(m_client.get(), &TcpClient::messageReceived, this, &MessageGenerator::onMessageReceived);

}

void MessageGenerator::onMessageReceived(const QString& message)
{
    QString formattedMessage = QString("[%1][%2:%3]: %4").arg(QDateTime::currentDateTime().time().toString()).arg(m_client->host()).arg(m_client->port()).arg(message);
    msgReceived(formattedMessage);
    if (m_ignoreMessage)
    {
        qDebug() << "message will be ignored.";
        return;
    }
    QJsonDocument jsonDoc = QJsonDocument::fromJson(message.toUtf8());
    QJsonObject jsonHeader = jsonDoc.object().value("header").toObject();
    QJsonObject jsonPayload = jsonDoc.object().value("payload").toObject();
    auto msgName = jsonHeader.value("messageName").toString();
    auto msgType = jsonHeader.value("messageType").toString();
    auto msgId = jsonHeader.value("messageId").toInt();

    if (msgType == CONTROL)
    {
        auto object = jsonPayload.value("object").toString();
        if (msgName == CHANGE_OBJECT_VALUE_REQ)
        {
            sendControlMessage(CHANGE_OBJECT_VALUE_RESP, msgId);
        }
        else if (msgName == MOVE_OBJECT_REQ)
        {
            sendControlMessage(MOVE_OBJECT_RESP, msgId);
        }
        else if (msgName == ACTION_OBJECT_TRIGGER_REQ)
        {
            sendControlMessage(ACTION_OBJECT_TRIGGER_RESP, msgId);
        }
        else if (msgName == CHANGE_METER_COUNTER_VALUE_REQ)
        {
            sendControlMessage(CHANGE_METER_COUNTER_VALUE_RESP, msgId);
        }
        else
        {
            qDebug() << "undefinded message name: " << msgName;
        }
    }
    else if (msgType == VIDEO)
    {
        //TODO handle ip from ProTouchApi if needed
    }
    else
    {
        qDebug() << "undefinded message type: " << msgType;
    }
}

void MessageGenerator::updateErrorCode(int errorCode)
{
    m_errorCode = errorCode;
}

void MessageGenerator::updateMsgStatus(bool status)
{
    m_messageStatus = status;
}

void MessageGenerator::updateErrorDsc(const QString& description)
{
    m_errorDsc = description;
}

void MessageGenerator::updateVideoAction(int videoAction)
{
    m_videoAction = videoAction;
}

void MessageGenerator::connectToHost(const QString& ip, const QString& port)
{
    QHostAddress host(ip);
    if (host.setAddress(ip))
        m_client->setIpAddr(host.toString());
    else
        qDebug() << "Wrong IP addr: " << ip;

    bool isParseOk;
    quint32 hostPort = port.toInt(&isParseOk);
    if (isParseOk)
        m_client->setPort(hostPort);
    else
        qDebug() << "Wrong port: " << port;

    m_client->connect();
}

void MessageGenerator::disconnectFromHost()
{
    m_client->disconnect();
}

void MessageGenerator::sendControlMessage(const QString& msgName, MessageId msgId)
{
    m_client->sendMessage(createMessage(createHeader(msgName, CONTROL, msgId), createControlRespPayload()));
}

void MessageGenerator::sendMeterCounterValue(const QString& val, const QString& unit)
{
    static const QString METER_COUNTER_STATUS_IND = "METER_COUNTER_STATUS_IND";

    m_client->sendMessage(createMessage(createHeader(METER_COUNTER_STATUS_IND, MONITORING, MESSAGE_ID),
                                        createMeterCounterStatusIndPayload(val, unit)));
}

void MessageGenerator::sendPerformVideoAction()
{
    static const QString PERFORM_VIDEO_ACTION_REQ = "PERFORM_VIDEO_ACTION_REQ";

    m_client->sendMessage(createMessage(createHeader(PERFORM_VIDEO_ACTION_REQ, VIDEO, MESSAGE_ID),
                                        createPerformVideoActionRespPayload()));
}

void MessageGenerator::sendStartVideoStreaming(const QString& port)
{
    static const QString START_VIDEO_STREAMING = "START_VIDEO_STREAMING_REQ";

    m_client->sendMessage(createMessage(createHeader(START_VIDEO_STREAMING, VIDEO, MESSAGE_ID),
                                        createStartVideoStreamingPayload(port.toInt())));
}

void MessageGenerator::sendObjectValue(const QString& obj, const QString& val)
{
    static const QString OBJECT_STATUS_IND = "OBJECT_STATUS_IND";

    m_client->sendMessage(createMessage(createHeader(OBJECT_STATUS_IND, MONITORING, MESSAGE_ID),
                                        createObjectStatusIndPayload(obj, val)));
}
void MessageGenerator::sendCreateFreeText(const QString& text,
                                        int x,
                                        int y,
                                        int visibleTime,
                                        const QString& textColor,
                                        const QString& backColor)
{
    QVariantMap payload{{
        {"text", text},
        {"x", x},
            {"y", y},
            {"visible", visibleTime},
            {"textColor", textColor},
            {"backColor", backColor}
    }};
    m_client->sendMessage(createMessage(createHeader("CREATE_FREE_TEXT", "OSD", MESSAGE_ID), QJsonObject::fromVariantMap(payload)));
}

QByteArray MessageGenerator::createMessage(const QJsonObject& header, const QJsonObject& payload)
{
    QJsonObject msg;
    msg.insert("header", header);
    msg.insert("payload", payload);

    QJsonDocument doc(msg);

    return doc.toJson(QJsonDocument::Compact);
}

QJsonObject MessageGenerator::createHeader(const QString& msgName, const QString& msgType, MessageId messageId)
{
    QJsonObject header;

    header.insert("messageId", QJsonValue::fromVariant(messageId));
    header.insert("messageType", QJsonValue::fromVariant(msgType));
    header.insert("messageName", QJsonValue::fromVariant(msgName));

    return header;
}

QJsonObject MessageGenerator::createMeterCounterStatusIndPayload(QString val, const QString& unit)
{
    QJsonObject payload;
    payload.insert("value", val.replace(",", ".").toDouble());
    payload.insert("unit", unit);
    return payload;
}

QJsonObject MessageGenerator::createStartVideoStreamingPayload(int port) const
{
    return QJsonObject{
        {"port", port}
    };
}

QJsonObject MessageGenerator::createObjectStatusIndPayload(const QString& obj, const QString& val)
{
    QJsonObject payload;
    payload.insert("value", QJsonValue::fromVariant(getValueForObject(obj.simplified(), val)));
    payload.insert("object", QJsonValue::fromVariant(obj.simplified()));
    return payload;
}

QVariant MessageGenerator::getValueForObject(const QString& obj, const QString& val)
{
    if (obj.contains("spinbox", Qt::CaseInsensitive) ||
        obj.contains("levelIndicator", Qt::CaseInsensitive))
        return val.toInt();
    else if (obj.contains("switch", Qt::CaseInsensitive))
        return (val == "true" ? true : false);
    return  val;
}

QJsonObject MessageGenerator::createControlRespPayload()
{
    QJsonObject payload;
    payload.insert("status", QJsonValue::fromVariant(m_messageStatus));
    payload.insert("errorCode", QJsonValue::fromVariant(m_errorCode));
    payload.insert("error", QJsonValue::fromVariant(m_errorDsc));
    return payload;
}

QJsonObject MessageGenerator::createPerformVideoActionRespPayload()
{
    return QJsonObject{
        {"videoAction", m_videoAction}
    };
}
