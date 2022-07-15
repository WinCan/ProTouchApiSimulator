#pragma once

#include <QObject>
#include <QQmlEngine>

struct PluginLoader : QObject
{
    Q_OBJECT
public:
    inline static QQmlEngine* qmlEngine = nullptr;
    Q_INVOKABLE void addPlugins(QObject* tabBar, QObject* stackLayout, QObject* msgGen);
};
