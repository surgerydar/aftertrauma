#include "imagepicker.h"

#ifdef Q_OS_IOS
extern void _openGallery();
extern void _openCamera();
#endif

ImagePicker* ImagePicker::s_shared = nullptr;

ImagePicker::ImagePicker(QObject *parent) : QObject(parent)
{

}

ImagePicker* ImagePicker::shared() {
    if ( !s_shared ) {
        s_shared = new ImagePicker();
    }
    return s_shared;
}

void ImagePicker::openGallery() {
#ifdef Q_OS_IOS
    _openGallery();
#endif
}

void ImagePicker::openCamera() {
#ifdef Q_OS_IOS
    _openCamera();
#endif
}
