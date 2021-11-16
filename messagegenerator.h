#pragma once

#include <tcpclient.h>
#include <memory>
#include <QObject>
#include <QString>

using MessageId = quint64;

static constexpr int UNDEFINDED_VALUE = -1;
static constexpr MessageId MESSAGE_ID = 102;

static constexpr char MONITORING[] = "MONITORING";
static constexpr char CONTROL[] = "CONTROL";

static constexpr char CHANGE_OBJECT_VALUE_REQ[] = "CHANGE_OBJECT_VALUE_REQ";
static constexpr char CHANGE_OBJECT_VALUE_RESP[] = "CHANGE_OBJECT_VALUE_RESP";
static constexpr char MOVE_OBJECT_REQ[] = "MOVE_OBJECT_REQ";
static constexpr char MOVE_OBJECT_RESP[] = "MOVE_OBJECT_RESP";
static constexpr char ACTION_OBJECT_TRIGGER_REQ[] = "ACTION_OBJECT_TRIGGER_REQ";
static constexpr char ACTION_OBJECT_TRIGGER_RESP[] = "ACTION_OBJECT_TRIGGER_RESP";

class MessageGenerator : public QObject
{
    Q_OBJECT
public:
    explicit MessageGenerator(QObject *parent = nullptr);

    Q_PROPERTY(bool connected READ connected NOTIFY connectionChanged)
    Q_PROPERTY(bool ignoreMessage READ ignoreMessage WRITE setIgnoreMessage NOTIFY ignoreMessageChanged)

    Q_INVOKABLE void connectToHost(const QString& ip = "127.0.0.1", const QString& port = "8082");
    Q_INVOKABLE void disconnectFromHost();

    Q_INVOKABLE void sendMeterCounterValue(const QString& val);
    Q_INVOKABLE void sendObjectValue(const QString& obj, const QString& val);

    Q_INVOKABLE void updateErrorCode(int errorCode);
    Q_INVOKABLE void updateMsgStatus(bool status);
    Q_INVOKABLE void updateErrorDsc(const QString& description);

    Q_INVOKABLE void sendCreateFreeText(const QString& text,
                                        int x,
                                        int y,
                                        int visibleTime,
                                        const QString& textColor,
                                        const QString& backColor);

    inline bool connected() { return m_isConnected; }

    inline bool ignoreMessage() { return m_ignoreMessage; }
    inline void setIgnoreMessage(bool val)
    {
        if (m_ignoreMessage != val){
            m_ignoreMessage = val;
            emit ignoreMessageChanged();
        }
    }

signals:
    void connectionChanged();
    void ignoreMessageChanged();
    void msgReceived(const QString& message);

public slots:
    void onMessageReceived(const QString& message);

private:
    void sendControlMessage(const QString& msgName, MessageId msgId);

    QJsonObject createHeader(const QString& msgName, const QString& msgType, MessageId messageId);
    QJsonObject createPayload(const QString& obj, const QString& val);
    QJsonObject createPayload(const QString& val);
    QJsonObject createControlRespPayload();

    QByteArray createMessage(const QJsonObject& header, const QJsonObject& payload);

    std::unique_ptr<TcpClient> m_client;
    bool m_isConnected{false};
    bool m_ignoreMessage{false};

    bool m_messageStatus{true};
    int m_errorCode{0};
    QString m_errorDsc{""};
};


