#include <QFile>
#include <QDir>
#include <QDebug>
#include <QFileInfoList>
#include <QFileInfo>

#include "systemutils.h"
#include "installer.h"

void Installer::run() {
    //
    // copy factsheets
    //
    installDirectory("factsheets");
    //
    // copy media
    //
    //
    installDirectory("media");
    //
    //
    emit complete();
}

void Installer::installDirectory( QString directory ) {
    //
    //
    //
    QString documentPath = SystemUtils::shared()->documentDirectory();
#ifdef Q_OS_ANDROID
    QString assetPath("assets:");
#else
    QString assetPath = SystemUtils::shared()->applicationDirectory();
#endif
    QDir documentDirectory(documentPath);
    //
    // copy files
    //
    QDir sourceDirectory( assetPath.append("/").append(directory) );
    qDebug() << "installer source: " << sourceDirectory;
    if ( !documentDirectory.exists(directory) ) {
        documentDirectory.mkdir(directory);
    }
    /* TODO: reinstate
    QDir destinationDirectory( documentPath.append("/").append(directory) );
    QFileInfoList fileList = sourceDirectory.entryInfoList();
    for (int i = 0; i < fileList.size(); ++i) {
        QFileInfo fileInfo = fileList.at(i);
        qDebug() << "installing filename:" << fileInfo.fileName();
        qDebug() << "filepath:" << fileInfo.filePath();
        if ( !QFile::copy(fileInfo.filePath(),destinationDirectory.absoluteFilePath(fileInfo.fileName())) ) {
            qDebug() << "Unable to copy to : " << destinationDirectory.absoluteFilePath(fileInfo.fileName());
        }
        QThread::yieldCurrentThread();
    }
    */
}
