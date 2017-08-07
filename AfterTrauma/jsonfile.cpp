#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QIODevice>
#include <QByteArray>
#include <QJsonParseError>
#include "systemutils.h"
#include "jsonfile.h"

JSONFile* JSONFile::s_shared = nullptr;


JSONFile::JSONFile(QObject *parent) : QObject(parent)
{

}
JSONFile* JSONFile::shared() {
    if ( !s_shared ) {
        s_shared = new JSONFile();
    }
    return s_shared;
}

void JSONFile::read(QString path) {
    //
    // assume the path is relative to documents directory
    //
    QString fullpath = SystemUtils::shared()->documentDirectory().append(path);
    //
    // open
    //
    QFile jsonFile(fullpath);
    if (jsonFile.open(QIODevice::ReadOnly)) {
        //
        // read
        //
        QByteArray data = jsonFile.readAll();
        //
        // parse
        //
        QJsonParseError parseError;
        QJsonDocument document( QJsonDocument::fromJson(data,&parseError) );
        //
        // interpret
        //
        if ( document.isArray() ) {
            //QJsonArray array = document.array();
            //VariantList list = array.toVariantList();
            QVariant array = document.toVariant();
            emit arrayReadFrom(path,array);
        } else if( document.isObject() ){
            //QJsonObject object = document.object();
            //QVariantMap map = object.toVariantMap();
            QVariant object = document.toVariant();
            emit objectReadFrom(path,object);
        } else {
            QString error = "error parsing : ";
            error.append( parseError.errorString() );
            emit errorReadingFrom(path,error);
        }
    } else {
        QString error = "Unable to open file : ";
        error.append(fullpath);
        emit errorReadingFrom(path,error);
    }
}

void JSONFile::writeObject(QVariant& object, QString path) {

}

void JSONFile::writeArray(QVariant& object, QString path) {

}
