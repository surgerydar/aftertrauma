#include <QFile>
#include <QDir>
#include <QDebug>
#include <QFileInfoList>
#include <QFileInfo>

#include "systemutils.h"
#include "installer.h"

void Installer::run() {
    //
    //
    //
    QString documentPath = SystemUtils::shared()->documentDirectory();
    QString applicationPath = SystemUtils::shared()->applicationDirectory();
    QDir documentDirectory(documentPath);
    //
    // copy factsheets
    //
    QDir factsheetSourceDirectory( applicationPath.append("/factsheets") );
    if ( !documentDirectory.exists("factsheets") ) {
        documentDirectory.mkdir("factsheets");
    }
    QDir factsheetDestinationDirectory( documentPath.append("/factsheets") );
    QFileInfoList factsheetList = factsheetSourceDirectory.entryInfoList();
    for (int i = 0; i < factsheetList.size(); ++i) {
        QFileInfo fileInfo = factsheetList.at(i);
        qDebug() << "filename:" << fileInfo.fileName();
        qDebug() << "filepath:" << fileInfo.filePath();
        if ( !QFile::copy(fileInfo.filePath(),factsheetDestinationDirectory.absoluteFilePath(fileInfo.fileName())) ) {
            qDebug() << "Unable to copy to : " << factsheetDestinationDirectory.absoluteFilePath(fileInfo.fileName());
        }
    }
    emit complete();
}
