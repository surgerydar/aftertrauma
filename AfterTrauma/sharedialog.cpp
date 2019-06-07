#include "sharedialog.h"
#include "systemutils.h"
#include <QDebug>
#include <QStandardPaths>
#include <QFile>

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
extern void _shareFile( QString text, QString filePath );
#endif

ShareDialog* ShareDialog::s_shared = nullptr;

ShareDialog::ShareDialog(QObject *parent) : QObject(parent) {

}

ShareDialog* ShareDialog::shared() {
    if ( !s_shared ) {
        s_shared = new ShareDialog;
    }
    return s_shared;
}

void ShareDialog::shareFile( QString text, QString filePath ) {
#if defined(Q_OS_IOS)
    _shareFile( text, filePath );
#endif
#if defined(Q_OS_ANDROID)
    /*
    QString documentPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString targetPath = documentPath.append("/share.pdf");
    qDebug() << "ShareDialog::shareFile : filePath:" << filePath;
    qDebug() << "ShareDialog::shareFile : targetPath:" << targetPath;

    if ( SystemUtils::shared()->copyFile(filePath,targetPath,true) ) {
        _shareFile( text, targetPath );
    } else {
        qDebug() << "ShareDialog::shareFile : unable to move file";
        _shareFile( text, filePath );
    }
    */
    if ( QFile::exists( filePath ) ) {
        _shareFile( text, filePath );
    } else {
        qDebug() << "ShareDialog::shareFile : file does not exist : " << filePath;
    }
#endif
}

