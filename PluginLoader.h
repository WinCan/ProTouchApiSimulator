#pragma once

#include <QObject>

struct PluginLoader : QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void addPlugins(QObject* tabBar, QObject* stackLayout, QObject* msgGen);
};
