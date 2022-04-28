#pragma once

#include <QObject>
#include <memory>

struct UdpVideoController : QObject
{
    Q_OBJECT
public:
    explicit UdpVideoController(QObject* = nullptr);
    ~UdpVideoController();

    Q_INVOKABLE void startPipeline(const QString& beginning, const QString& address, const QString& port);
    Q_INVOKABLE void stop();
    Q_INVOKABLE bool hasGstreamer();
private:
    struct Pimpl;
    std::unique_ptr<Pimpl> pimpl;
};
