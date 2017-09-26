#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QDebug>

#include "imagepicker.h"

class AndroidImagePicker: public QAndroidActivityResultReceiver {
private:
    static AndroidImagePicker* s_shared;
public:
    AndroidImagePicker() {}
    static AndroidImagePicker* shared() {
        if ( s_shared == nullptr ) {
            s_shared = new AndroidImagePicker;
        }
        return s_shared;
    }
    void show() {
        QAndroidJniObject ACTION_PICK = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
        QAndroidJniObject intent("android/content/Intent");
        if (ACTION_PICK.isValid() && intent.isValid()) {
            intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", ACTION_PICK.object<jstring>());
            intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
            QtAndroid::startActivity(intent.object<jobject>(), 101, this);
        }
    }

    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data) override {
        jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
        qDebug() << "AndroidImagePicker : receiverRequestCode : " << receiverRequestCode << " : resultCode : " << resultCode << " : data : " << data.toString();
        if (receiverRequestCode == 101 && resultCode == RESULT_OK) {
            //
            // get path
            //
            QAndroidJniEnvironment env;
            //
            //
            //
            QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
            qDebug() << "uri : " << uri.toString();
            //
            // open file
            //
            QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
            if (env->ExceptionCheck()) {
                env->ExceptionDescribe();
                env->ExceptionClear();
            }
            QAndroidJniObject inputStream = contentResolver.callObjectMethod("openInputStream","(Landroid/net/Uri)Ljava/io/InputStream;", uri.object<jobject>());
            if (env->ExceptionCheck()) {
                env->ExceptionDescribe();
                env->ExceptionClear();
            }
            if ( true ) {//inputStream.isValid() ) {
                qDebug() << "reading file";
                jbyteArray buffer = env->NewByteArray(2048);
                while(true) {
                    //
                    // read
                    //
                    jint read = inputStream.callMethod<jint>("read","([B)I",buffer);
                    qDebug() << "read " << read << " bytes";
                    //
                    // write
                    //
                    if( read <= 2048 ) {
                        break;
                    }
                }
            } else {
                qDebug() << "unable to open file";
            }
            /*
            //
            // extract id
            //
            QStringList id = getMediaId(path);
            //
            //
            //

            QAndroidJniObject dataKey = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
            qDebug() << "dataKey : " << dataKey.toString();
            QAndroidJniObject externalMediaURI = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore/Images/Media", "EXTERNAL_CONTENT_URI", "Ljava/lang/String;");
            qDebug() << "externalMediaURI : " << externalMediaURI.toString();
            QAndroidJniObject internalMediaURI = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore/Images/Media", "INTERNAL_CONTENT_URI", "Ljava/lang/String;");
            qDebug() << "internalMediaURI : " << internalMediaURI.toString();

            qDebug() << "building projection";
            jobjectArray projection = (jobjectArray)env->NewObjectArray(1, env->FindClass("java/lang/String"), NULL);
            jstring dataString = env->NewStringUTF(dataKey.toString().toStdString().c_str());
            env->SetObjectArrayElement(projection, 0, dataString );

            qDebug() << "building selection";
            jstring selection = env->NewStringUTF("_id=?");
            jobjectArray selectionArgs = (jobjectArray)env->NewObjectArray(1, env->FindClass("java/lang/String"), NULL);
            env->SetObjectArrayElement(projection, 0, env->NewStringUTF(id[1].toStdString().c_str()));

            qDebug() << "query content resolver";
            QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
            QAndroidJniObject cursor = contentResolver.callObjectMethod("query", "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;", uri.object<jobject>(), NULL, NULL, NULL, NULL );//selection, selectionArgs, NULL);
            cursor.callMethod<jboolean>("moveToFirst", "()Z");

            jint rowCount = cursor.callMethod<jint>("getCount", "()I");
            qDebug() << "rowCount : " << rowCount;
            jint columnCount = cursor.callMethod<jint>("getColumnCount", "()I");
            qDebug() << "columnCount : " << columnCount;
            for ( int col =  0; col < columnCount; col++ ) {
                QAndroidJniObject colName = cursor.callObjectMethod("getColumnName", "(I)Ljava/lang/String;", col);
                QAndroidJniObject colValue = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", col);
                qDebug() << colName.toString() << " : " << colValue.toString();
            }

            jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Ljava/lang/String;)I", dataKey.object<jstring>());
            qDebug() << "column index : " << columnIndex;
            QAndroidJniObject result = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
            QString url = result.toString();
            qDebug() << "url : " << url;
            ImagePicker::shared()->imagePicked( url );
            */
        }
    }

    QStringList getMediaId( QString& path ) {
        QString id = path.right(path.lastIndexOf("/")+1);
        if ( id.length() > 0 ) {
            QStringList components = id.split(':');
            if ( components.size() == 2 ) return components;
        }
        return QStringList();
    }
};

AndroidImagePicker* AndroidImagePicker::s_shared = nullptr;

void _openGallery() {
    //showPicker( UIImagePickerControllerSourceTypePhotoLibrary );
    AndroidImagePicker::shared()->show();
}

void _openCamera() {
    //showPicker( UIImagePickerControllerSourceTypeCamera );
}

