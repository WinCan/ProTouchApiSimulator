#include "tcpclient.h"

#include <memory>
#include <QTcpSocket>
#include <QDebug>
#include <QObject>
#include <QHostAddress>

TcpClient::TcpClient(const QString& host, quint32 port)
    : m_socket(std::make_unique<QTcpSocket>()),
      m_host(host),
      m_port(port)
{
    QObject::connect(m_socket.get(), &QTcpSocket::connected, this, &TcpClient::connected);
    QObject::connect(m_socket.get(), &QTcpSocket::disconnected, this, &TcpClient::disconnected);
    QObject::connect(m_socket.get(), &QTcpSocket::readyRead, this, [this]() {
        m_buffer.append(m_socket->readAll());
        auto messages = m_buffer.split("\n");
        if(not messages.empty())
        {
            m_buffer = messages.back();
            messages.pop_back();
            for(auto& message : messages)
            {
                emit messageReceived(message);
            }
        }
    });
}

TcpClient::~TcpClient()
{
    disconnect();
}

void TcpClient::connect()
{
    m_socket->connectToHost(m_host, m_port);
}

void TcpClient::disconnect()
{
    m_socket->disconnectFromHost();
    m_socket->abort();
}

void TcpClient::setPort(quint32 port)
{
    m_port = port;
}

void TcpClient::setIpAddr(const QString& ip)
{
    m_host = ip;
}

void TcpClient::sendMessage(const QByteArray& msg)
{
    if (m_socket && m_socket->state() == QAbstractSocket::ConnectedState)
    {
        m_socket->write(msg );
    }
}
