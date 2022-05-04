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
        auto msg = m_socket->readAll();
        emit messageReceived(msg);
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
