#include "archive.h"
#include "archiver.h"
#include "unarchiver.h"

const QString Archive::ARCHIVE = "archive";
const QString Archive::UNARCHIVE = "unarchive";
Archive* Archive::s_shared = nullptr;

Archive::Archive(QObject *parent) : QObject(parent)
{

}

Archive* Archive::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new Archive;
    }
    return s_shared;
}

void Archive::archive( const QString& source, const QString& archive, bool recursive ) {
    //
    // initialise Archiver
    //
    Archiver *archiver = new Archiver(this);
    archiver->setSource(source);
    archiver->setArchive(archive);
    archiver->setRecursive(recursive);
    //
    // connect signals
    //
    connect(archiver, &Archiver::done, [this]( const QString& source, const QString& archive ) {
        emit done( ARCHIVE, source, archive );
    });
    connect(archiver, &Archiver::progress, [this]( const QString& source, const QString& archive, quint64 total, quint64 current, const QString& message ) {
        emit progress( ARCHIVE, source, archive, total, current, message );
    });
    connect(archiver, &Archiver::error, [this]( const QString& source, const QString& archive, const QString& message ){
        emit error( ARCHIVE, source, archive, message );
    });
    connect(archiver,&Archiver::finished, archiver, &QObject::deleteLater);
    //
    // start thread
    //
    archiver->start();
}

void Archive::unarchive( const QString& archive, const QString& target ) {
    //
    // initialise UnArchiver
    //
    UnArchiver *unarchiver = new UnArchiver(this);
    unarchiver->setArchive(archive);
    unarchiver->setTarget(target);
    //
    // connect signals
    //
    connect(unarchiver, &UnArchiver::done, [this]( const QString& archive, const QString& target ) {
        emit done( UNARCHIVE, target, archive );
    });
    connect(unarchiver, &UnArchiver::progress, [this]( const QString& source, const QString& archive, quint64 total, quint64 current, const QString& message ) {
        emit progress( ARCHIVE, source, archive, total, current, message );
    });
    connect(unarchiver, &UnArchiver::error, [this]( const QString& archive, const QString& target, const QString& message ){
        emit error( UNARCHIVE, target, archive, message );
    });
    connect(unarchiver,&UnArchiver::finished, unarchiver, &QObject::deleteLater);
    //
    // start thread
    //
    unarchiver->start();
}
