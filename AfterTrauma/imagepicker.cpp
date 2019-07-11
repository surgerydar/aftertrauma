#include "imagepicker.h"

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
extern void _openGallery();
extern void _openCamera();
#endif

#if defined(Q_OS_ANDROID)
    #include <QtAndroid>
#endif

ImagePicker* ImagePicker::s_shared = nullptr;

ImagePicker::ImagePicker(QObject *parent) : QObject(parent) {
#if defined(Q_OS_ANDROID)
    //
    //
    //
    if ( QtAndroid::androidSdkVersion() >= 23 ) {
        QAndroidJniObject::callStaticMethod<void>("uk/co/soda/aftertrauma2/Permissions",
                                                  "request",
                                                  "()V");
    }
#endif
}

ImagePicker* ImagePicker::shared() {
    if ( !s_shared ) {
        s_shared = new ImagePicker();
    }
    return s_shared;
}

void ImagePicker::openGallery() {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _openGallery();
#endif
}

void ImagePicker::openCamera() {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _openCamera();
#endif
}
