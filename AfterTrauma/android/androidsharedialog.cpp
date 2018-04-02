#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QDebug>
#include <QUrl>
#include "systemutils.h"

void _shareFile( QString text, QString path) {

    QUrl url( path );
    url.setScheme("file");
    auto mime = SystemUtils::shared()->mimeTypeForFile(url.fileName());
    //auto content = text.length() > 0 ? QString( "%1 %2" ).arg( text ).arg( url.toString() ) : url.toString();
    auto content = text;
    auto ACTION_SEND = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_SEND", "Ljava/lang/String;");
    auto EXTRA_TEXT = QAndroidJniObject::getStaticObjectField("android/content/Intent", "EXTRA_TEXT", "Ljava/lang/String;");
    auto EXTRA_STREAM = QAndroidJniObject::getStaticObjectField("android/content/Intent", "EXTRA_STREAM", "Ljava/lang/String;");
    //auto FLAG_GRANT_WRITE_URI_PERMISSION = QAndroidJniObject::getStaticObjectField("android/content/Intent", "FLAG_GRANT_WRITE_URI_PERMISSION", "Ljava/lang/String;");
    //auto FLAG_GRANT_READ_URI_PERMISSION = QAndroidJniObject::getStaticObjectField("android/content/Intent", "FLAG_GRANT_READ_URI_PERMISSION", "Ljava/lang/String;");
    jint FLAG_GRANT_WRITE_URI_PERMISSION = QAndroidJniObject::getStaticField<jint>("android/content/Intent", "FLAG_GRANT_WRITE_URI_PERMISSION");
    jint FLAG_GRANT_READ_URI_PERMISSION = QAndroidJniObject::getStaticField<jint>("android/content/Intent", "FLAG_GRANT_READ_URI_PERMISSION");
    auto intent = QAndroidJniObject("android/content/Intent", "(Ljava/lang/String;)V", ACTION_SEND.object());

    // Intent  Intent.putExtra(String name, String value)
    intent.callObjectMethod("putExtra", "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;", EXTRA_TEXT.object(), QAndroidJniObject::fromString(content).object());

    QAndroidJniObject uri =  QAndroidJniObject::callStaticObjectMethod(
                "android/net/Uri", "parse", "(Ljava/lang/String;)Landroid/net/Uri;", QAndroidJniObject::fromString(url.toString()).object());
    qDebug() << "Sharing : " << uri.toString();
    // shareIntent.putExtra(Intent.EXTRA_STREAM, Uri);
    intent.callObjectMethod("putExtra", "(Ljava/lang/String;Landroid/net/Uri;)Landroid/content/Intent;", EXTRA_STREAM.object(), uri.object<jobject>());

    // Intent  Intent.setType(String type)
    intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString(mime).object());
    //intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("plain/text").object());
    qDebug() << intent.toString();
    /*
    // Intent.addFlags(int flag)
    qDebug() << "flags=" << FLAG_GRANT_READ_URI_PERMISSION << "|" << FLAG_GRANT_WRITE_URI_PERMISSION;
    intent.callObjectMethod("setType", "(I)Landroid/content/Intent;", FLAG_GRANT_READ_URI_PERMISSION);
    intent.callObjectMethod("setType", "(I)Landroid/content/Intent;", FLAG_GRANT_WRITE_URI_PERMISSION);
    qDebug() << intent.toString();
    */
    // static Intent Intent.createChooser(Intent target, CharSequence title)
    auto chooserIntent = QAndroidJniObject::callStaticObjectMethod("android/content/Intent", "createChooser", "(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;", intent.object(), QAndroidJniObject::fromString(QString("Choose destination...")).object());
    qDebug() << chooserIntent.toString();

    QtAndroid::startActivity(chooserIntent, 0, nullptr);
}
