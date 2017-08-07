#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "imagepicker.h"
#include "systemutils.h"
#include "jsonfile.h"
#include "database.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    //
    //
    //
    QQmlApplicationEngine engine;
    //
    //
    //

    //
    //
    //
    engine.rootContext()->setContextProperty("Database", Database::shared());
    engine.rootContext()->setContextProperty("ImagePicker", ImagePicker::shared());
    engine.rootContext()->setContextProperty("SystemUtils", SystemUtils::shared());
    engine.rootContext()->setContextProperty("JSONFile", JSONFile::shared());
    //
    //
    //
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
