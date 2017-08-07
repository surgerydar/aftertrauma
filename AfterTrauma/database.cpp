#include <QVariant>
#include <QVariantMap>
#include <QVariantList>
#include <QVariantList>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

#include "systemutils.h"
#include "database.h"

Database* Database::s_shared = nullptr;

Database::Database(QObject *parent) : QObject(parent) {

}

Database* Database::shared() {
    if ( !s_shared ) {
        s_shared = new Database();
    }
    return s_shared;
}

void Database::load() {
    //
    // clear existing
    //
    m_collections.clear();
    QString dbPath = SystemUtils::shared()->documentDirectory().append("/aftertrauma.json");
    QFile db(dbPath);
    if (db.open(QIODevice::ReadOnly)) {
        //
        // read
        //
        QByteArray data = db.readAll();
        //
        // parse
        //
        QJsonParseError parseError;
        QJsonDocument doc(QJsonDocument::fromJson(data,&parseError));
        //
        //
        //
        if ( doc.isObject() ) {
            qDebug() << "Database : read database";
            m_collections = doc.object().toVariantMap();
        } else {
            if ( parseError.error != QJsonParseError::NoError ) {
                emit error("db","open",parseError.errorString());
            } else {
                emit error("db","open", "unexpected format");
            }
        }
    } else {
        //
        // create defaults
        //
        qDebug() << "Database : creating defaults";
        m_collections["daily"] = QVariantList();
        m_collections["settings"] = QVariantList();
        save();
    }
}

void Database::save() {
    QString dbPath = SystemUtils::shared()->documentDirectory().append("/aftertrauma.json");
    QFile db(dbPath);
    if (db.open(QIODevice::WriteOnly)) {
        QJsonObject object( QJsonObject::fromVariantMap(m_collections) );
        QJsonDocument doc;
        doc.setObject(object);
        db.write(doc.toJson());
    }
}

void Database::insert( QString collection, QVariant object ) {

}

void Database::update( QString collection, QVariant query, QVariant object ) {

}

void Database::remove( QString collection, QVariant query ) {

}

void Database::find( QString collection, QVariant query ) {

}

void Database::findOne( QString collection, QVariant query ) {

}
