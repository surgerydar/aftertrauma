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
QHash<int, QByteArray> DatabaseList::roleNames() const {
    QHash<int, QByteArray> roles;
    for ( int i = 0; i < m_roles.size(); i++ ) {
        roles[ i ] = m_roles[ i ].toUtf8();
    }
    return roles;
}

int DatabaseList::rowCount(const QModelIndex &parent) const {
    return m_objects.size();
}

QVariant DatabaseList::data(const QModelIndex &index, int role) const {
    if ( index.row() >= 0 && index.row() < m_objects.size() && role < m_roles.size() ) {
        return QVariant(m_objects[index.row()][m_roles[role]]);
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
    QString dbPath = _path();
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
            qDebug() << "DatabaseList : read database";
            QVariantList objects = doc.array().toVariantList();
            beginResetModel();
            for ( auto& object : objects ) {
                m_objects.append(object.value<QVariantMap>());
            }
            endResetModel();
            //emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
            //emit countChanged();
        } else {
            if ( parseError.error != QJsonParseError::NoError ) {
                emit error("open",parseError.errorString());
            } else {
                emit error("open","unexpected format");
            }
        }
    } else {
        //
        // create default db
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
void DatabaseList::clear() {
    if ( m_objects.size() > 0 ) {
        //int objectCount = m_objects.size();
        beginResetModel();
        m_objects.clear();
        endResetModel();
        //emit dataChanged(createIndex(0,0),createIndex(objectCount-1,0));
        //emit countChanged();
    }
}

QVariant DatabaseList::add(QVariant o) {
    QVariantMap object = o.value<QVariantMap>();
    object["_id"] = QUuid::createUuid().toString();
    //beginResetModel();
    m_objects.append(object);
    _sort();
    //endResetModel();
    //emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
    //emit countChanged();
    QVariantMap id;
    id["_id"] = object["_id"];
    return QVariant(id);
}

QVariant DatabaseList::update(QVariant q,QVariant u) {
    QVariantMap query = q.value<QVariantMap>();
    QVariantMap update = u.value<QVariantMap>();
    QVariantList matches;
    int count = m_objects.size();
    int minIndex = std::numeric_limits<int>::max();
    int maxIndex = std::numeric_limits<int>::min();
    beginResetModel();
    for ( int i = 0; i < count; i++ ) {
        if ( _match(m_objects[i],query) ) {
            if ( i < minIndex ) minIndex = i;
            if ( i > maxIndex ) maxIndex = i;
            QVariantMap object = m_objects[i];
            matches.append(QVariantMap({{"_id",object["_id"]}}));
            _update(object,update);
            m_objects.replace(i,object);
        }
    }
    endResetModel();
    /*
    if ( matches.size() > 0 ) {
        qDebug() << "updated from : " << minIndex << " : to : " << maxIndex;
        emit dataChanged(createIndex(minIndex,0),createIndex(maxIndex,0));
    }
    */
    return QVariant(matches);
}

QVariant DatabaseList::remove(QVariant q) {
    QVariantMap query = q.value<QVariantMap>();
    QVariantList matches;
    beginResetModel();
    for ( int i = 0; i < m_objects.size(); ) {
        if ( _match(m_objects[i],query) ) {
            matches.append(QVariantMap({{"_id",m_objects[i]["_id"]}}));
            m_objects.removeAt(i);
        } else {
            i++;
        }
    }
    endResetModel();
    /*
    if ( matches.size() > 0 ) {
        emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
        emit countChanged();
    }
    */
    return QVariant(matches);
}

QVariant DatabaseList::find(QVariant q) {
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

QVariant DatabaseList::get(int i) {
    if ( i >= 0 && i < m_objects.size() ) {
        return QVariant(m_objects[i]);
    }
    return QVariant();
}

void DatabaseList::sort(QVariant s) {
    if ( m_sort != s ) {
        m_sort = s.value<QVariantMap>();
        beginResetModel();
        _sort();
        endResetModel();
        //emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
    }
}
//
//
//
void DatabaseList::_sort() {
    if ( !m_sort.empty() ) {
        QString field = m_sort.firstKey();
        int direction = m_sort.first().value<int>();
        qDebug() << "sorting by : " << field << " direction : " << direction;
        std::sort(m_objects.begin(),m_objects.end(),[&field,&direction](const QVariantMap& a, const QVariantMap& b) -> bool {
            bool aHasIt = a.contains(field);
            bool bHasIt = b.contains(field);
            if ( direction > 0 ) {
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
        //
        // TODO: handle array updates
        //
        object[ it.key() ] = it.value();
    }
}
QString DatabaseList::_path() {
    return SystemUtils::shared()->documentDirectory().append("/").append(m_collection).append(".json");
}
