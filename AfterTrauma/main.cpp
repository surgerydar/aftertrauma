#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QStandardPaths>

#include "imagepicker.h"
#include "sharedialog.h"
#include "systemutils.h"
#include "jsonfile.h"
#include "database.h"
#include "databaselist.h"
#include "websocketchannel.h"
#include "guidgenerator.h"
#include "imageutils.h"
#include "flowerchart.h"
#include "androidbackkeyfilter.h"
#include "cachedmediasource.h"
#include "cachedimageprovider.h"
#include "pdfgenerator.h"
#include "linechartdata.h"
#include "websocketlist.h"
//
// TODO: find a better way of doing this
//
void setHiDPIScaleFactor(QGuiApplication& app) {
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
    //QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling);
    //
    //
    //
    //
    //
    //
    QGuiApplication app(argc, argv);
    setHiDPIScaleFactor(app);
    app.installEventFilter(AndroidBackKeyFilter::shared());
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
    qmlRegisterType<WebSocketList>("SodaControls", 1, 0, "WebSocketList");
    qmlRegisterType<FlowerChart>("SodaControls", 1, 0, "FlowerChart");
    qmlRegisterType<CachedMediaSource>("SodaControls", 1, 0, "CachedMediaSource");
    qmlRegisterType<LineChartData>("SodaControls", 1, 0, "LineChartData");
    //
    //
    //
    qDebug() << "Registering Items";
    engine.rootContext()->setContextProperty("GuidGenerator", GuidGenerator::shared());
    engine.rootContext()->setContextProperty("Database", Database::shared());
    engine.rootContext()->setContextProperty("ImagePicker", ImagePicker::shared());
    engine.rootContext()->setContextProperty("ShareDialog", ShareDialog::shared());
    engine.rootContext()->setContextProperty("SystemUtils", SystemUtils::shared());
    engine.rootContext()->setContextProperty("ImageUtils", ImageUtils::shared());
    engine.rootContext()->setContextProperty("JSONFile", JSONFile::shared());
    engine.rootContext()->setContextProperty("BackKeyFilter", AndroidBackKeyFilter::shared());
    engine.rootContext()->setContextProperty("PDFGenerator", PDFGenerator::shared());
    //engine.rootContext()->setContextProperty("LineChartData", LineChartData::shared());
    //
    //
    //
    engine.addImageProvider("cached",new CachedImageProvider);
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
