#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QDebug>

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
#ifdef Q_OS_ANDROID
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
#else
    return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
#endif
}

QString SystemUtils::temporaryDirectory() {
    return QDir::tempPath();
}
//
//
//
void SystemUtils::moveFile( QString from, QString to, bool force ) {
    if ( force ) {
        if ( QFile::exists(to) ) {
            QFile::remove(to);
        }
    }
    QFile::rename( from, to );
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
