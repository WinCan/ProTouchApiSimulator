#include "PluginLoader.h"
#include <QQmlComponent>
#include <QLibrary>
#include <QDirIterator>
#include <QResource>
#include <QCoreApplication>
#include <QQmlEngine>

void PluginLoader::addPlugins(QObject* tabBar, QObject* stackLayout, QObject* msgGen)
{
    QDir pluginPath = QCoreApplication::applicationDirPath() + "/plugins";
    int apiVersion = msgGen->property("ApiVersion").toInt();
    if(not pluginPath.exists())
    {
        return;
    }
    QDirIterator pluginsIt{pluginPath};
    while(pluginsIt.hasNext())
    {
        QString plugin = pluginsIt.next();

        if(not QFile::exists(plugin + "/resources.rcc"))
        {
            continue;
        }

        QLibrary lib{plugin + "/lib"};
        lib.load();
        QResource::registerResource(plugin + "/resources.rcc");

        QString name = reinterpret_cast<const char*(*)()>(lib.resolve("getPluginName"))();
        int requiredApiVersion = reinterpret_cast<int(*)()>(lib.resolve("getRequiredApiVersion"))();

        if(requiredApiVersion > apiVersion)
        {
            qWarning() << name << " required api version: " << requiredApiVersion << " but simulator has: " << apiVersion << " - ignoring plugin";
            continue;
        }

        auto component = new QQmlComponent(::qmlEngine(stackLayout), QUrl{"qrc:/plugins/" + name + "/TabEntry.qml"}, stackLayout);

        QObject* controller = reinterpret_cast<QObject*(*)()>(lib.resolve("getPluginController"))();

        QQmlEngine::setObjectOwnership(component, QQmlEngine::JavaScriptOwnership);
        QQmlEngine::setObjectOwnership(controller, QQmlEngine::JavaScriptOwnership);

        QMetaObject::invokeMethod(stackLayout, "addEntry",
          Q_ARG(QVariant, QVariant::fromValue(component)),
          Q_ARG(QVariant, QVariant::fromValue(controller)));

        QMetaObject::invokeMethod(tabBar, "addEntry", Q_ARG(QVariant, QVariant{name}));

        connect(msgGen, SIGNAL(rawMsgReceived(const QString&)),
        controller, SLOT(handleMessage(const QString&)));

        connect(controller, SIGNAL(sendMessageSignal(const QString&)),
        msgGen, SLOT(sendMessage(const QString&)));
    }
}
