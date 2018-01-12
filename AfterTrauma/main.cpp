#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QStandardPaths>

#include "imagepicker.h"
#include "systemutils.h"
#include "jsonfile.h"
#include "database.h"
#include "databaselist.h"
#include "websocketchannel.h"
#include "guidgenerator.h"
#include "imageutils.h"
#include "flowerchart.h"
#include "androidbackkeyfilter.h"
//
// TODO: find a better way of doing this
//
void setHiDPIScaleFactor(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    double pixelRatio = app.devicePixelRatio();
    double scale = 1. / pixelRatio;
    qDebug() << "pixel ratio : " << pixelRatio << " scale : " << scale;
    if ( scale < .5 ) {
        scale *= 2.5;
        qputenv("QT_SCALE_FACTOR", QString::number(scale).toUtf8() );
    } /*else if ( scale < 1. ) {
        scale *= 1.5;
        qputenv("QT_SCALE_FACTOR", QString::number(scale).toUtf8() );
    }*/
}
//
//
//
int main(int argc, char *argv[])
{
    //
    //
    //
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    //
    //
    //
    setHiDPIScaleFactor(argc, argv);
    //
    //
    //
    QGuiApplication app(argc, argv);
#ifdef Q_OS_ANDROID
    app.installEventFilter(AndroidBackKeyFilter::shared());
#endif
    //
    //
    //
    QQmlApplicationEngine engine;
    //
    //
    //
    qDebug() << "Registering controls";
    qmlRegisterType<DatabaseList>("SodaControls", 1, 0, "DatabaseList");
    qmlRegisterType<WebSocketChannel>("SodaControls", 1, 0, "WebSocketChannel");
    qmlRegisterType<FlowerChart>("SodaControls", 1, 0, "FlowerChart");
    //
    //
    //
    qDebug() << "Registering Items";
    engine.rootContext()->setContextProperty("GuidGenerator", GuidGenerator::shared());
    engine.rootContext()->setContextProperty("Database", Database::shared());
    engine.rootContext()->setContextProperty("ImagePicker", ImagePicker::shared());
    engine.rootContext()->setContextProperty("SystemUtils", SystemUtils::shared());
    engine.rootContext()->setContextProperty("ImageUtils", ImageUtils::shared());
    engine.rootContext()->setContextProperty("JSONFile", JSONFile::shared());
#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty("BackKeyFilter", AndroidBackKeyFilter::shared());
#endif
    //
    //
    //
    qDebug() << "Standard Paths";
    qDebug() << "RuntimeLocation";
    QStringList paths = QStandardPaths::standardLocations(QStandardPaths::RuntimeLocation);
    for ( auto& path : paths ) {
        qDebug() << path;
    }
    qDebug() << "DocumentsLocation";
    paths = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);
    for ( auto& path : paths ) {
        qDebug() << path;
    }
    qDebug() << "AppDataLocation";
    paths = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation);
    for ( auto& path : paths ) {
        qDebug() << path;
    }
    //
    //
    //
    qDebug() << "Launching main";
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    //
    //
    //
    return app.exec();
}
