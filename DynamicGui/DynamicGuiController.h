#ifndef DYNAMICGUICONTROLLER_H
#define DYNAMICGUICONTROLLER_H

#include <QObject>
#include "zmq.hpp"

struct DynamicGuiController : QObject
{
    Q_OBJECT
public:
    explicit DynamicGuiController(QObject* = nullptr);

    Q_INVOKABLE QString defaultLeftPanelConfig() const;
    Q_INVOKABLE QString defaultRightPanelConfig() const;
    Q_INVOKABLE QString defaultBottomPanelConfig() const;
    Q_INVOKABLE void enable();
    Q_INVOKABLE void disable();
    Q_INVOKABLE void send(const QString& msg);
private:
    zmq::context_t ctx;
    zmq::socket_t push;
    zmq::socket_t pull;
};

#endif // DYNAMICGUICONTROLLER_H
