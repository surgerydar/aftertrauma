#include "cachedimageprovider.h"

CachedImageProvider::CachedImageProvider() : QQuickImageProvider(QQmlImageProviderBase::Image,QQmlImageProviderBase::ForceAsynchronousImageLoading) {

}
//
//
//
QImage CachedImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize) {
    //
    // check cache directory
    //

    //
    // load from network
    //
    return QImage();
}
