#include "imagepicker.h"

extern void _openGallery();
extern void _openCamera();

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
    _openGallery();
}

void ImagePicker::openCamera() {
    _openCamera();
}
