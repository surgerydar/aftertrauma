#include "uploader.h"
#include "uploadchannel.h"

Uploader* Uploader::s_shared = nullptr;

Uploader::Uploader(QObject *parent) : QObject(parent) {

}

Uploader* Uploader::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new Uploader;
    }
    return s_shared;
}

void Uploader::upload( const QString& source, const QString& destination ) {
    //
    // initialise Archiver
    //
    UploadChannel*uploader = new UploadChannel(this);
    uploader->setSource(source);
    uploader->setDestination(destination);
    //
    // connect signals
    //
    connect(uploader, &UploadChannel::done, [this,uploader]( const QString& source, const QString& destination ) {
        emit done( source, destination );
        uploader->deleteLater();
    });
    connect(uploader, &UploadChannel::error, [this]( const QString& source, const QString& destination, const QString& message ){
        emit error( source, destination, message );
    });
    connect(uploader, &UploadChannel::progress, [this]( const QString& source, const QString& destination, int total, int current, const QString& message ){
        emit progress( source, destination, total, current, message );
    });
    //
    // start uploader
    //
    uploader->start();
}
