#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QIODevice>
#include <QByteArray>
#include <QJsonParseError>
#include <QJSValue>
#include <QDebug>
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

QVariant JSONFile::read(QString path) {
    //
    // assume the path is relative to documents directory
    //
    QString fullpath = SystemUtils::shared()->documentDirectory().append('/').append(path);
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
            return array;
        } else if( document.isObject() ){
            //QJsonObject object = document.object();
            //QVariantMap map = object.toVariantMap();
            QVariant object = document.toVariant();
            emit objectReadFrom(path,object);
            return object;
        } else {
            QString error = "error parsing : ";
            error.append( parseError.errorString() );
            emit errorReadingFrom(path,error);
        }
    } else {
        QString error = "Unable to open file : ";
        error.append(fullpath);
        emit errorReadingFrom(path,error);
        qDebug() << "JSONFile::read : " << error;
    }
    return QVariant();
}

bool JSONFile::write(QString path, QVariant object) {
    //
    // assume the path is relative to documents directory
    //
    QString fullpath = SystemUtils::shared()->documentDirectory().append('/').append(path);
    //
    // open
    //
    QFile jsonFile(fullpath);
    if (jsonFile.open(QIODevice::WriteOnly)) {
        QJsonDocument document;
        QVariant _object;
        if ( object.canConvert<QJSValue>() ) { // catch the JSValue case
            QJSValue value = object.value<QJSValue>();
            _object = value.toVariant();
        } else {
            _object = object;
        }
        if ( _object.canConvert<QVariantMap>() ) {
            QVariantMap map = object.value<QVariantMap>();
            document.setObject(QJsonObject::fromVariantMap(map));
        } else if ( _object.canConvert<QVariantList>() ) {
            QVariantList list = object.value<QVariantList>();
            document.setArray(QJsonArray::fromVariantList(list));
        }
        QByteArray json = document.toJson();
        jsonFile.write(json);
        return true;
    } else {
        QString error = "Unable to open file : ";
        error.append(fullpath);
        qDebug() << "JSONFile::write : " << error;
    }
    return false;
}
