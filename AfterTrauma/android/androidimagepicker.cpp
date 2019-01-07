#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QDebug>
#include <QDateTime>
#include <QFile>
#include <QCoreApplication>

#include "imagepicker.h"
#include "systemutils.h"

QString selectedFileName;

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL
Java_uk_co_soda_ImagePicker_fileSelected(JNIEnv */*env*/, jobject /*obj*/, jstring results)
{
    selectedFileName = QAndroidJniObject(results).toString();
}

#ifdef __cplusplus
}
#endif

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
        return SystemUtils::shared()->documentDirectory().append("/image-%1.jpg").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd-HH-mm-ss"));
    }

    void showGallery() {
        QAndroidJniObject intent = QAndroidJniObject::callStaticObjectMethod("uk/co/soda/aftertrauma/ImagePicker",
                                                  "openGallery",
                                                  "()Landroid/content/Intent;");
        if ( intent.isValid() ) {
            QtAndroid::startActivity(intent, SOURCE_GALLERY, this);
        }

    }

    void showCamera() {
        qDebug() << "AndroidImagePicker::showCamera : creating intent";
        QAndroidJniObject intent = QAndroidJniObject::callStaticObjectMethod("uk/co/soda/aftertrauma/ImagePicker",
                                                  "openCamera",
                                                  "()Landroid/content/Intent;");
        if ( intent.isValid() ) {
            qDebug() << "AndroidImagePicker::showCamera : starting intent";
            QAndroidJniObject imageUri = QAndroidJniObject::getStaticObjectField( "uk/co/soda/aftertrauma/ImagePicker", "mCurrentPhotoPath", "Ljava/lang/String;" );
            cameraPath = imageUri.toString();
            qDebug() << "AndroidImagePicker::showCamera : Capturing image to : " << cameraPath;
            QtAndroid::startActivity(intent, SOURCE_CAMERA, this);
        } else {
            qDebug() << "AndroidImagePicker::showCamera : invalid intent";
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
                //qDebug() << "image from camera saved to : " << cameraPath;
                QAndroidJniObject path = QAndroidJniObject::fromString(cameraPath);
                QAndroidJniObject uri = QAndroidJniObject::callStaticObjectMethod("android/net/Uri", "parse", "(Ljava/lang/String;)Landroid/net/Uri;", path.object<jstring>());
                //QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
                if ( uri.isValid() ) {
                    qDebug() << "AndroidImagePicker : camera : uri : " << uri.toString();
                    //
                    // copy file to app storage
                    //
                    pickFile(uri,true);
                } else {
                   qDebug() << "AndroidImagePicker : camera : Invalid uri";
                }
            }
        } else {
            qDebug() << "AndroidImagePicker : error : " << resultCode;
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
        // get real path
        //
        QAndroidJniObject realPath = QAndroidJniObject::callStaticObjectMethod("uk/co/soda/ImagePicker",
                                                                               "getRealPathFromURI",
                                                                               "(Landroid/content/ContentResolver;Landroid/net/Uri;)Ljava/lang/String",
                                                                               contentResolver.object<jobject>(),uri.object<jobject>());
        qDebug() << "real path : " << realPath.toString();
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
                        jboolean iscopy = false;
                        jbyte *bytes = env->GetByteArrayElements(buffer, &iscopy);
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
                    //
                    // delete source file
                    //
                    // TODO: get this to work, may be a permissions thing
                    QAndroidJniObject removed = contentResolver.callObjectMethod("delete","(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I;", uri.object<jobject>(),NULL,NULL);
                    qDebug() << "AndroidImagePicker::pickFile : deleted files : " << removed.toString();
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
    AndroidImagePicker::shared()->showGallery();
}

void _openCamera() {
    AndroidImagePicker::shared()->showCamera();
}

