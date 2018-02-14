#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QDebug>
#include <QUrl>
#include "systemutils.h"

void _shareFile( QString text, QString path) {

    QUrl url( path );
    auto mime = SystemUtils::shared()->mimeTypeForFile(url.fileName());
    auto content = text.length() > 0 ? QString( "%1 %2" ).arg( text ).arg( path ) : path;
    auto ACTION_SEND = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_SEND", "Ljava/lang/String;");
    auto EXTRA_TEXT = QAndroidJniObject::getStaticObjectField("android/content/Intent", "EXTRA_TEXT", "Ljava/lang/String;");
    auto intent = QAndroidJniObject("android/content/Intent", "(Ljava/lang/String;)V", ACTION_SEND.object());

    // Intent  Intent.putExtra(String name, String value)
    intent.callObjectMethod("putExtra", "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;", EXTRA_TEXT.object(), QAndroidJniObject::fromString(content).object());

    // Intent  Intent.setType(String type)
    intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString(mime).object());
    qDebug() << intent.toString();

    // static Intent Intent.createChooser(Intent target, CharSequence title)
    auto chooserIntent = QAndroidJniObject::callStaticObjectMethod("android/content/Intent", "createChooser", "(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;", intent.object(), QAndroidJniObject::fromString(QString("It's Time To Choose...")).object());
    qDebug() << chooserIntent.toString();

    QtAndroid::startActivity(chooserIntent, 0, nullptr);
}
