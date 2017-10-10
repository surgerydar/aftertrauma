#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QDebug>
#include <QFile>

#include "imagepicker.h"
#include "systemutils.h"

class AndroidImagePicker: public QAndroidActivityResultReceiver {
private:
    static AndroidImagePicker* s_shared;
    QString cameraPath;
public:
    enum {
        SOURCE_GALLERY = 101,
        SOURCE_CAMERA = 102
    };
    AndroidImagePicker() {}
    static AndroidImagePicker* shared() {
        if ( s_shared == nullptr ) {
            s_shared = new AndroidImagePicker;
        }
        return s_shared;
    }

    QString uniquePath() {
        QString pathTemplate = SystemUtils::shared()->documentDirectory().append("/image%1.jpg");
        int i = 0;
        QString path;
        do {
            path = pathTemplate.arg(i++);
        } while( QFile::exists(path) );
        return path;
    }

    void showGallery() {
        QAndroidJniObject GET_CONTENT = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
        QAndroidJniObject intent("android/content/Intent");
        if (GET_CONTENT.isValid() && intent.isValid()) {
            intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", GET_CONTENT.object<jstring>());
            intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
            QtAndroid::startActivity(intent.object<jobject>(), SOURCE_GALLERY, this);
        }
    }

    void showCamera() {
        QAndroidJniObject IMAGE_CAPTURE = QAndroidJniObject::fromString("android.media.action.IMAGE_CAPTURE");
        QAndroidJniObject intent=QAndroidJniObject("android/content/Intent");
        if ( IMAGE_CAPTURE.isValid() && intent.isValid() ) {
            intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", IMAGE_CAPTURE.object<jstring>());
            //
            // set target file
            //
            QAndroidJniEnvironment env;
            QAndroidJniObject context = QtAndroid::androidContext();
            QAndroidJniObject EXTRA_OUTPUT = QAndroidJniObject::getStaticObjectField( "android/provider/MediaStore", "EXTRA_OUTPUT", "Ljava/lang/String;");

            //cameraPath = uniquePath();
            //QAndroidJniObject filename = QAndroidJniObject::fromString(cameraPath);
            QAndroidJniObject mediaDir = QAndroidJniObject::callStaticObjectMethod("android/os/Environment", "getExternalStorageDirectory", "()Ljava/io/File;");
            QAndroidJniObject filename = QAndroidJniObject::fromString("temp.jpg");
            QAndroidJniObject file = QAndroidJniObject("java/io/File","(Ljava/io/File;Ljava/lang/String;)V", mediaDir.object<jstring>(), filename.object<jstring>());
            QAndroidJniObject auth = QAndroidJniObject::fromString("uk.co.soda.aftertrauma");
            /*
            QAndroidJniObject uri =  QAndroidJniObject::callStaticObjectMethod(
                        "android/support/v4/content/FileProvider",
                        "getUriForFile", "(Landroid/content/Context;Ljava/lang/String;Ljava/io/File;)V",
                        context.object<jobject>(), auth.object<jstring>(), file.object<jobject>());
                        */
            QAndroidJniObject uri =  QAndroidJniObject::callStaticObjectMethod(
                        "android/net/Uri", "fromFile", "(Ljava/io/File;)Landroid/net/Uri;", file.object<jobject>());
            qDebug() << "Capturing image to : " << uri.toString();

            cameraPath = uri.toString();
            //cameraPath.remove(0,QString("file://").length());
            intent.callObjectMethod( "putExtra","(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;", EXTRA_OUTPUT.object<jstring>(), uri.object<jobject>());
            //
            // open camera
            //
            QtAndroid::startActivity(intent, SOURCE_CAMERA, this);
        }
    }

    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data) override {
        jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
        qDebug() << "AndroidImagePicker : receiverRequestCode : " << receiverRequestCode << " : resultCode : " << resultCode << " : data : " << data.toString();
        if( resultCode == RESULT_OK ) {
            if (receiverRequestCode == SOURCE_GALLERY ) {
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
                // copy file to app storage
                //
                pickFile(uri);
            } else if ( receiverRequestCode == SOURCE_CAMERA ) {
                qDebug() << "image from camera saved to : " << cameraPath;
                QAndroidJniObject path = QAndroidJniObject::fromString(cameraPath);
                QAndroidJniObject uri = QAndroidJniObject::callStaticObjectMethod("android/net/Uri", "parse", "(Ljava/lang/String;)Landroid/net/Uri;", path.object<jstring>());
                if ( uri.isValid() ) {
                    //
                    // copy file to app storage
                    //
                    pickFile(uri,true);
                } else {
                   qDebug() << "Invalid uri";
                }
            }
        } else {
            qDebug() << "error";
        }
    }

    void pickFile(QAndroidJniObject& uri,bool remove=false) {
        //
        //
        //
        QAndroidJniEnvironment env;
        //
        // open file
        //
        QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
        //
        //
        //
        if ( contentResolver.isValid() ) {
            QAndroidJniObject inputStream = contentResolver.callObjectMethod("openInputStream","(Landroid/net/Uri;)Ljava/io/InputStream;", uri.object<jobject>());
            if ( inputStream.isValid() ) {
                QString path = uniquePath();
                QFile destination(path);
                if ( destination.open(QIODevice::WriteOnly) ) {
                    qDebug() << "reading file";
                    jbyteArray buffer = env->NewByteArray(2048);
                    jint total = 0;
                    while(true) {
                        //
                        // read
                        //
                        jint read = inputStream.callMethod<jint>("read","([B)I", buffer);
                        //
                        // write
                        //
                        jbyte *bytes = env->GetByteArrayElements(buffer, false);
                        destination.write((char*)bytes,read);
                        env->ReleaseByteArrayElements(buffer, bytes, 0);
                        //
                        //
                        //
                        total += read;
                        if( read < 2048 ) {
                            break;
                        }
                    }
                    destination.close();
                    //
                    //
                    //
                    qDebug() << "written " << total << " bytes to " << path;
                    ImagePicker::shared()->imagePicked( path );
                } else {
                    qDebug() << "unable to open destination file : " << path;
                }
            } else {
                qDebug() << "unable to open source file : " << uri.toString();
            }
        } else {
            qDebug() << "unable to get contentResolver";
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
    AndroidImagePicker::shared()->showGallery();
}

void _openCamera() {
    //showPicker( UIImagePickerControllerSourceTypeCamera );
    AndroidImagePicker::shared()->showCamera();
}

