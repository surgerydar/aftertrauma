#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QDebug>
#include <QMimeDatabase>
#include <QMimeType>
#include <QGuiApplication>
#include <QScreen>

#include "installer.h"
#include "systemutils.h"

SystemUtils* SystemUtils::s_shared = nullptr;

SystemUtils::SystemUtils(QObject *parent) : QObject(parent)
{

}
//
//
//
SystemUtils* SystemUtils::shared() {
    if ( !s_shared ) {
        s_shared = new SystemUtils();
    }
    return s_shared;
}
//
//
//
bool SystemUtils::isFirstRun() {
    QString dbPath = documentDirectory().append("/aftertrauma.json");
    return !QFile::exists(dbPath);
}

void SystemUtils::install() {
    Installer *installer = new Installer();
    connect(installer, &Installer::complete, this, &SystemUtils::_installComplete);
    connect(installer, &Installer::error, this, &SystemUtils::_installError);
    connect(installer, &Installer::finished, installer, &QObject::deleteLater);
    installer->start();
}
//
//
//
QString SystemUtils::applicationDirectory() {
    return QCoreApplication::applicationDirPath();
}

QString SystemUtils::documentDirectory() {
    QString documentPath;
#ifdef Q_OS_ANDROID
    documentPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
#else
    documentPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
#endif
    QDir dir(documentPath);
    if ( dir.mkpath("aftertrauma") ) { // ensure directory exists
        dir.cd("aftertrauma");
        if ( !dir.exists("media") ) { // TODO: move this somewhere more sensible
            dir.mkdir("media");
        }
    }
    return dir.canonicalPath();
}

QString SystemUtils::temporaryDirectory() {
    return QDir::tempPath();
}
//
//
//
bool SystemUtils::copyFile( QString from, QString to, bool force ) {
    if ( force ) {
        if ( QFile::exists(to) ) {
            QFile::remove(to);
        }
    }
    return QFile::copy( from, to );
}
bool SystemUtils::moveFile( QString from, QString to, bool force ) {
    if ( force ) {
        if ( QFile::exists(to) ) {
            QFile::remove(to);
        }
    }
    return QFile::rename( from, to );
}
//
//
//
QString SystemUtils::mimeTypeForFile( QString filename ) {
    QMimeDatabase mimeDb;
    QMimeType mimeType = mimeDb.mimeTypeForFile(filename);
    return mimeType.name();
}
//
//
//
//
//
//
qreal SystemUtils::pointToPixel( qreal point ) {
    qreal dpi = QGuiApplication::primaryScreen()->physicalDotsPerInch();
    return point/72*dpi;
}

qreal SystemUtils::pixelToPoint( qreal pixel ) {
    qreal dpi = QGuiApplication::primaryScreen()->physicalDotsPerInch();
    return pixel*72/dpi;
}
//
//
//
void SystemUtils::_installComplete() {
    emit installComplete();
}

void SystemUtils::_installError(QString& error) {
    emit installError(error);
}
