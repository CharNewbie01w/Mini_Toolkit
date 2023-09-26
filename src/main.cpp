#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <FramelessHelper/Quick/framelesshelperquick_global.h>
#include "component/Launcher.h"
#include "component/RandintGenerator.h"
#include "component/Clicker.h"
#include "component/DataModel.h"

FRAMELESSHELPER_USE_NAMESPACE


int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
    FramelessHelper::Quick::initialize();
    QGuiApplication app(argc, argv);

    qmlRegisterType<Launcher>("Launcher", 1, 0, "Launcher");
    qmlRegisterType<RandintGenerator>("RandintGenerator", 1, 0, "RandintGenerator");
    qmlRegisterType<Clicker>("Clicker", 1, 0, "Clicker");
    qmlRegisterType<DataModel>("DataModel", 1, 0, "DataModel");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/Mini_Toolkit/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
