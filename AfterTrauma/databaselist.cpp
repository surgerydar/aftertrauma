#include "databaselist.h"
#include "systemutils.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>
#include <QUuid>

DatabaseList::DatabaseList(QObject *parent) : QAbstractListModel(parent) {
}
//
//
//
int DatabaseList::rowCount(const QModelIndex &parent) const {
    return m_objects.size();
}

QVariant DatabaseList::data(const QModelIndex &index, int role) const {
    if ( index.row() >= 0 && index.row() < m_objects.size() ) {
        return QVariant(m_objects[index.row()]);
    }
    return QVariant();
}
//
//
//
void DatabaseList::setCollection( QString collection ) {
    if ( collection != m_collection ) {
        m_collection = collection;
        load();
        emit collectionChanged();
    }
}
//
//
//
void DatabaseList::load() {
    //
    // clear existing
    //
    m_objects.clear();
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
        if ( doc.isArray() ) {
            qDebug() << "Database : read database";
            QVariantList objects = doc.array().toVariantList();
            for ( auto& object : objects ) {
                m_objects.append(object.value<QVariantMap>());
            }
        } else {
            if ( parseError.error != QJsonParseError::NoError ) {
                emit error("open",parseError.errorString());
            } else {
                emit error("open","unexpected format");
            }
        }
    } else {
        //
        // create defaults
        //
        save();
    }
}

void DatabaseList::save() {
    QString dbPath = _path();
    QFile db(dbPath);
    if (db.open(QIODevice::WriteOnly)) {
        QVariantList list;
        for ( auto& object : m_objects ) {
            list.append(QVariant(object));
        }
        QJsonDocument doc;
        doc.setArray(QJsonArray::fromVariantList(list));
        db.write(doc.toJson());
    } else {
        qDebug() << "DatabaseList::save : unable to open : " << dbPath;
        emit error("save",dbPath.prepend("unable to open file : "));
    }
}
//
//
//
QVariant DatabaseList::add(QVariant&o) {
    QVariantMap object = o.value<QVariantMap>();
    object["_id"] = QUuid::createUuid().toString();
    m_objects.append(object);
    _sort();
    emit dataChanged(createIndex(m_objects.size()-1,0),createIndex(m_objects.size()-1,0));
    QVariantMap id;
    id["_id"] = object["_id"];
    return QVariant(id);
}

QVariant DatabaseList::update(QVariant&q,QVariant&u) {
    QVariantMap query = q.value<QVariantMap>();
    QVariantMap update = u.value<QVariantMap>();
    QVariantList matches;
    int count = m_objects.size();
    for ( int i = 0; i < count; i++ ) {
        if ( _match(m_objects[i],query) ) {
            QVariantMap object = m_objects[i];
            matches.append(QVariantMap({{"_id",object["_id"]}}));
            _update(object,update);
            m_objects.replace(i,object);
        }
    }
    return QVariant(matches);
}

QVariant DatabaseList::remove(QVariant&q) {
    QVariantMap query = q.value<QVariantMap>();
    QVariantList matches;
    int count = m_objects.size();
    for ( int i = 0; i < count; ) {
        if ( _match(m_objects[i],query) ) {
            matches.append(QVariantMap({{"_id",m_objects[i]["_id"]}}));
            m_objects.removeAt(i);
        } else {
            i++;
        }
    }
    return QVariant(matches);
}

QVariant DatabaseList::find(QVariant&q) {
    QVariantMap query = q.value<QVariantMap>();
    QVariantList matches;
    int count = m_objects.size();
    for ( int i = 0; i < count; i++ ) {
        if ( _match(m_objects[i],query) ) {
            matches.append(m_objects[i]);
        }
    }
    return QVariant(matches);
}
void DatabaseList::sort(QVariant&s) {
    if ( m_sort != s ) {
        m_sort = s.value<QVariantMap>();
        _sort();
    }
}
//
//
//
void DatabaseList::_sort() {
    if ( !m_sort.empty() ) {
        QString field = m_sort.firstKey();
        int direction = m_sort.first().value<int>();
        std::sort(m_objects.begin(),m_objects.end(),[&field,&direction](QVariantMap& a, QVariantMap& b) -> bool {
            bool aHasIt = a.contains(field);
            bool bHasIt = b.contains(field);
            if ( direction > 1 ) {
                if ( aHasIt && bHasIt ) {
                    return a[field] < b[field];
                } else if ( aHasIt && !bHasIt ) {
                    return false;
                } if( !aHasIt && bHasIt ) {
                    return true;
                }
            } else {
                if ( aHasIt && bHasIt ) {
                    return a[field] > b[field];
                } else if ( !aHasIt && bHasIt ) {
                    return false;
                } if( aHasIt && !bHasIt ) {
                    return true;
                }
            }
            return false;
        });
    }
}
bool DatabaseList::_match( QVariantMap& object, QVariantMap& query ) {
    for ( QVariantMap::iterator it = query.begin(); it != query.end(); ++it ) {
        if ( !object.contains(it.key()) || object[ it.key() ] != query[ it.key() ] ) return false;
    }
    return true;
}
void DatabaseList::_update( QVariantMap& object, QVariantMap& update ) {
    for ( QVariantMap::iterator it = update.begin(); it != update.end(); ++it ) {
        object[ it.key() ] = it.value();
    }
}
QString DatabaseList::_path() {
    return SystemUtils::shared()->documentDirectory().append("/").append(m_collection).append(".json");
}
