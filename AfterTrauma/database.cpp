#include <QVariant>
#include <QVariantMap>
#include <QVariantList>
#include <QVariantList>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QUuid>

#include "systemutils.h"
#include "database.h"
//
// TODO: move this into general utilities
//
template <typename T>
inline T& getStoredValueRef(QVariant &v)
{
    const auto type = qMetaTypeId<T>(static_cast<T*>(nullptr));
    auto& d = v.data_ptr();
    if (type == d.type)
    {
        auto data = reinterpret_cast<T*>(d.is_shared ? d.data.shared->ptr : &d.data.ptr);
        return *data;
    }
    throw std::runtime_error("Bad type");
}

Database* Database::s_shared = nullptr;

Database::Database(QObject *parent) : QObject(parent) {

}

Database* Database::shared() {
    if ( !s_shared ) {
        s_shared = new Database();
    }
    return s_shared;
}

QString Database::generateObjectId() {
    return QUuid::createUuid().toString();
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
        QStringList collections = {
            "daily", "challenges", "settings"
        };
        for ( auto& collection : collections ) {
            m_collections[ collection ] = QVariantList();
        }
        save();
    }
}

void Database::save() {
    QString dbPath = SystemUtils::shared()->documentDirectory().append("/aftertrauma.json");
    QFile db(dbPath);
    if (db.open(QIODevice::WriteOnly)) {
        QJsonDocument doc;
        doc.setObject(QJsonObject::fromVariantMap(m_collections));
        db.write(doc.toJson());
    }
}

QVariant Database::insert( QString collection, QVariant object ) {
    QVariantMap document = object.toMap();
    if ( document.find("_id") != document.end() ) {
        //
        // promote to update
        //
        QVariantMap query;
        query["_id"] = document["_id"];
        return update( collection, query, document );
    } else {
        //
        //
        //
        document["_id"] = generateObjectId();
        QVariantList& _collection = getCollection(collection);
        _collection.append(document);
        QVariant results(document);
        emit success(collection,"insert",results);
        return results;
    }
}

QVariant Database::update( QString collection, QVariant query, QVariant object ) {
    QVariantMap _query = query.toMap();
    QVariantMap _update = object.toMap();
    QVariantList& _collection = getCollection(collection);
    QVariantList matches;
    for ( int i = 0; i< _collection.size(); i++ ) {
        QVariantMap& document = getStoredValueRef<QVariantMap>(_collection[i]);
        if ( _query.size() == 0 || matchDocument(document,_query ) ) {
            for ( QVariantMap::iterator it = _update.begin(); it != _update.end(); ++it ) {
                document[ it.key() ] = _update[ it.key() ];
                matches.append(document["_id"]);
            }
        }
    }
    QVariant results(matches);
    emit success(collection,"update",results);
    return results;
}

QVariant Database::remove( QString collection, QVariant query ) {
    QVariantMap _query = query.toMap();
    QVariantList& _collection = getCollection(collection);
    QVariantList matches;
    for ( int i = 0; i< _collection.size(); ) {
        QVariantMap& document = getStoredValueRef<QVariantMap>(_collection[i]);
        if ( matchDocument(document,_query ) ) {
            matches.append(document["_id"]);
            _collection.erase(_collection.begin()+i);
        } else {
            i++;
        }
    }
    QVariant results( matches );
    emit success(collection,"remove",results);
    return results;
}

QVariant Database::find( QString collection, QVariant query ) {
    //
    // TODO: sort and full query
    //
    QVariantMap _query = query.toMap();
    QVariantList& _collection = getCollection(collection);
    QVariantList matches;
    for ( int i = 0; i< _collection.size(); i++ ) {
        QVariantMap& document = getStoredValueRef<QVariantMap>(_collection[i]);
        if ( _query.size() == 0 || matchDocument(document,_query ) ) {
            matches.append(_collection[i]);
        }
    }
    QVariant results(matches);
    emit success(collection,"find",results);
    return results;

}

QVariant Database::findOne( QString collection, QVariant query ) {
    QVariantMap _query = query.toMap();
    QVariantList& _collection = getCollection(collection);
    for ( int i = 0; i< _collection.size(); i++ ) {
        QVariantMap& document = getStoredValueRef<QVariantMap>(_collection[i]);
        if ( _query.size() == 0 || matchDocument(document,_query ) ) {
            QVariant results(_collection[i]);
            emit success(collection,"findOne",results);
            return results;
        }
    }
    return QVariant();
}
//
//
//
QVariantList& Database::getCollection( QString& collection ) {
    if ( m_collections.find(collection) == m_collections.end() ) {
        m_collections[collection] = QVariantList();
    }
    return getStoredValueRef<QVariantList>(m_collections[collection]);
}
bool Database::matchDocument( QVariantMap& document, QVariantMap& query ) {
    //
    // TODO: mongo style queries
    //
    for ( QVariantMap::iterator it = query.begin(); it != query.end(); ++it ) {
        if ( !document.contains(it.key()) || document[ it.key() ] != query[ it.key() ] ) return false;
    }
    return true;
}
