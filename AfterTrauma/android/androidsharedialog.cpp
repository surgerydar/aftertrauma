#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QDebug>
#include <QUrl>
#include "systemutils.h"

void _shareFile( QString text, QString path) {
    //
    // call native share interface
    //
    QUrl url( path );
    QAndroidJniObject _path = QAndroidJniObject::fromString( url.toString() );
    QAndroidJniObject _mime = QAndroidJniObject::fromString(SystemUtils::shared()->mimeTypeForFile(url.fileName()));
    QAndroidJniObject::callStaticMethod<void>("uk/co/soda/aftertrauma2/FileShareDialog",
                                              "share",
                                              "(Ljava/lang/String;Ljava/lang/String;)V",
                                              _path.object<jstring>(),
                                              _mime.object<jstring>());
}
