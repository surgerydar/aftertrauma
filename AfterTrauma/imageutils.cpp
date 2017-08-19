#include "imageutils.h"
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QFile>
#include <QDebug>

ImageUtils* ImageUtils::s_shared = nullptr;

ImageUtils::ImageUtils(QObject *parent) : QObject(parent) {

}

ImageUtils* ImageUtils::shared() {
    if ( !s_shared ) {
        s_shared = new ImageUtils();
    }
    return s_shared;
}

QString ImageUtils::urlEncode( QString path, int width, int height ) {
    QImage sourceImage;
    if( sourceImage.load(path) ) {
        //
        // scale image
        //
        QImage destinationImage = sourceImage.scaled(QSize(width,height),Qt::KeepAspectRatio);
        //
        // write to byte array as png
        //
        QByteArray ba;
        QBuffer buffer(&ba);
        buffer.open(QIODevice::WriteOnly);
        if ( destinationImage.save(&buffer, "PNG") ) {
            //
            // encode buffer
            //
            QByteArray encoded = ba.toBase64().prepend("data:image/png;base64,");
            qDebug() << encoded;
            //
            //
            //
            return QString::fromLatin1(encoded.data());
        }
    }
    return "";
}
