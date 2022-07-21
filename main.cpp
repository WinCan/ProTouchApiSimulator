#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <messagegenerator.h>
#include <DynamicGui/DynamicGuiController.h>
#include <UdpVideo/UdpVideoController.h>
#include "PluginLoader.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<MessageGenerator>("io.qt.MessageGenerator", 1, 0, "MessageGenerator");
    qmlRegisterType<DynamicGuiController>("io.qt.DynamicGuiController", 1, 0, "DynamicGuiController");
    qmlRegisterType<UdpVideoController>("io.qt.UdpVideoController", 1, 0, "UdpVideoController");
    qmlRegisterType<PluginLoader>("io.qt.PluginLoader", 1, 0, "PluginLoader");

    QQmlApplicationEngine engine;
    engine.addImportPath(QStringLiteral(":/qml/"));
        engine.addImportPath(QStringLiteral(":/qml/design/"));
            engine.addImportPath(QStringLiteral(":/qml/CommonItems/"));
    engine.addImportPath(QStringLiteral("qrc:/"));
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
