#pragma once

#include <memory>

#include <QObject>
#include <QTcpSocket>
#include <QDataStream>
#include <QTimer>

class TcpClient : public QObject
{
    Q_OBJECT
public:
    explicit TcpClient(const QString& host, quint32 port);
    ~TcpClient();

    void connect();
    void disconnect();
    void sendMessage(const QByteArray& msg);
    void setPort(quint32 port);
    void setIpAddr(const QString& ip);
    inline QString host() { return m_host; }
    inline quint32 port() { return m_port; }

signals:
    void connected();
    void disconnected();
    void messageReceived(const QString& msg);
private:
    std::unique_ptr<QTcpSocket> m_socket;
    QString m_host;
    quint32 m_port;
    QString m_buffer;
};

