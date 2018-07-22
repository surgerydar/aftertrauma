#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QDebug>
#include <QUrl>
#include "systemutils.h"

void _shareFile( QString text, QString path) {
    //
    //
    //
    QAndroidJniEnvironment env;
    QAndroidJniObject context = QtAndroid::androidContext();
    //
    // get required flags
    //
    auto ACTION_VIEW = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_VIEW", "Ljava/lang/String;");
    auto ACTION_SEND = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_SEND", "Ljava/lang/String;");
    auto EXTRA_EMAIL = QAndroidJniObject::getStaticObjectField("android/content/Intent", "EXTRA_EMAIL", "Ljava/lang/String;");
    auto EXTRA_TEXT = QAndroidJniObject::getStaticObjectField("android/content/Intent", "EXTRA_TEXT", "Ljava/lang/String;");
    auto EXTRA_SUBJECT = QAndroidJniObject::getStaticObjectField("android/content/Intent", "EXTRA_SUBJECT", "Ljava/lang/String;");
    auto EXTRA_STREAM = QAndroidJniObject::getStaticObjectField("android/content/Intent", "EXTRA_STREAM", "Ljava/lang/String;");
    jint FLAG_GRANT_WRITE_URI_PERMISSION = QAndroidJniObject::getStaticField<jint>("android/content/Intent", "FLAG_GRANT_WRITE_URI_PERMISSION");
    jint FLAG_GRANT_READ_URI_PERMISSION = QAndroidJniObject::getStaticField<jint>("android/content/Intent", "FLAG_GRANT_READ_URI_PERMISSION");
    jint FLAG_ACTIVITY_NEW_TASK = QAndroidJniObject::getStaticField<jint>("android/content/Intent", "FLAG_ACTIVITY_NEW_TASK");
    //
    // get mime type for file
    //
    QUrl url( path );
    //url.setScheme("file");
    auto mime = SystemUtils::shared()->mimeTypeForFile(url.fileName());
    auto content = text;
    //
    // create send intent
    //
    //auto intent = QAndroidJniObject("android/content/Intent", "(Ljava/lang/String;)V", ACTION_SEND.object());
    auto intent = QAndroidJniObject("android/content/Intent", "(Ljava/lang/String;)V", ACTION_VIEW.object());
    //
    // set subject / content
    //
    //intent.callObjectMethod("putExtra", "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;", EXTRA_EMAIL.object<jstring>(), QAndroidJniObject::fromString(text).object<jstring>());
    //intent.callObjectMethod("putExtra", "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;", EXTRA_SUBJECT.object<jstring>(), QAndroidJniObject::fromString(text).object<jstring>());
    //
    //
    //
    auto authority = QAndroidJniObject::fromString("uk.aftertrauma.fileprovider");
    auto file = QAndroidJniObject("java/io/File", "(Ljava/lang/String;)V", QAndroidJniObject::fromString(url.toString()).object<jstring>());
    //
    //
    //
    qDebug() << "getting FileProvider for " << url.toString();
    QAndroidJniObject uri = QAndroidJniObject::callStaticObjectMethod(
                "android/support/v4/content/FileProvider", "getUriForFile", "(Landroid/content/Context;Ljava/lang/String;Ljava/io/File;)Landroid/net/Uri;",
                context.object<jobject>(), authority.object<jstring>(), file.object<jobject>());
    qDebug() << "Sharing : " << uri.toString() << " mimeType:" << mime;
    //
    // add attachment
    //
    //intent.callObjectMethod("putExtra", "(Ljava/lang/String;Landroid/net/Uri;)Landroid/content/Intent;", EXTRA_STREAM.object<jstring>(), uri.object<jobject>());
    //intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString(mime).object<jstring>());
    intent.callObjectMethod("setDataAndType", "(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;", uri.object<jobject>(), QAndroidJniObject::fromString(mime).object<jstring>());
    //
    // set flags
    //
    intent.callObjectMethod("addFlags", "(I)Landroid/content/Intent;", FLAG_GRANT_READ_URI_PERMISSION);
    intent.callObjectMethod("addFlags", "(I)Landroid/content/Intent;", FLAG_GRANT_WRITE_URI_PERMISSION);
    //intent.callObjectMethod("addFlags", "(I)Landroid/content/Intent;", FLAG_ACTIVITY_NEW_TASK);
    qDebug() << intent.toString();
    //
    // create chooser
    //
    auto chooserIntent = QAndroidJniObject::callStaticObjectMethod("android/content/Intent", "createChooser", "(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;", intent.object(), QAndroidJniObject::fromString(QString("Choose destination...")).object<jstring>());
    qDebug() << chooserIntent.toString();
    //
    // display
    //
    QtAndroid::startActivity(chooserIntent, 0, nullptr);
}
