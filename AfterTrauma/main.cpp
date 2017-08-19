#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "imagepicker.h"
#include "systemutils.h"
#include "jsonfile.h"
#include "database.h"
#include "databaselist.h"
#include "websocketchannel.h"
#include "guidgenerator.h"

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
    qmlRegisterType<DatabaseList>("SodaControls", 1, 0, "DatabaseList");
    qmlRegisterType<WebSocketChannel>("SodaControls", 1, 0, "WebSocketChannel");
    //
    //
    //
    engine.rootContext()->setContextProperty("GuidGenerator", GuidGenerator::shared());
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
