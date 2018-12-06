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

int DatabaseList::rowCount(const QModelIndex& /*parent*/) const {
    return _activeList().size();
}

QVariant DatabaseList::data(const QModelIndex &index, int role) const {
    if ( index.row() >= 0 && index.row() < rowCount(index.parent()) && role < m_roles.size() ) {
        /*
        if ( m_collection == "daily" ) {
            qDebug() << "DatabaseList::data : " << m_roles[role] << " : " << _activeList()[index.row()][m_roles[role]];
        }
        */
        return QVariant(_activeList()[index.row()][m_roles[role]]);
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
            QMutexLocker locker(&m_objectGuard);
            qDebug() << "DatabaseList : read database";
            QVariantList objects = doc.array().toVariantList();
            beginResetModel();
            for ( auto& object : objects ) {
                m_objects.append(object.value<QVariantMap>());
            }
            _sort();
            _filter();
            endResetModel();
            emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
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
        QMutexLocker locker(&m_objectGuard);
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
        m_filtered.clear();
        endResetModel();
        //emit dataChanged(createIndex(0,0),createIndex(objectCount-1,0));
        //emit countChanged();
    }
}

QVariant DatabaseList::add(QVariant o) {
    QVariantMap object = o.value<QVariantMap>();
    if ( !object.contains("_id") ) {
        object["_id"] = QUuid::createUuid().toString();
    }
    beginResetModel();
    m_objectGuard.lock();
    m_objects.append(object);
    _sort();
    _filter();
    m_objectGuard.unlock();
    endResetModel();
    //emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
    //emit countChanged();
    QVariantMap id;
    id["_id"] = object["_id"];
    return QVariant(id);
}

QVariant DatabaseList::update(QVariant q,QVariant u, bool upsert) {
    m_objectGuard.lock();
    QVariantMap query = q.value<QVariantMap>();
    QVariantMap update = u.value<QVariantMap>();
    QVariantList matches;
    //QStringList ids;
    int count = m_objects.size();
    int minIndex = std::numeric_limits<int>::max();
    int maxIndex = std::numeric_limits<int>::min();

    for ( int i = 0; i < count; ++i ) {
        if ( _match(m_objects[i],query) ) {
            if ( i < minIndex ) minIndex = i;
            if ( i > maxIndex ) maxIndex = i;
            QVariantMap object = m_objects[i];
            matches.append(QVariantMap({{"_id",object["_id"]}}));
            //ids.append(object["_id"].toString());
            _update(object,update);
            m_objects.replace(i,object);
        }
    }
    _sort();
    _filter();
    if ( matches.size() > 0 ) {
        qDebug() << "updated from : " << minIndex << " : to : " << maxIndex;
        m_objectGuard.unlock();
        /*
        count = matches.size();
        for ( int i = 0; i < count; ++i ) {
            int objectIndex = _indexOfItem(ids[i]);
            if ( objectIndex >= 0 ) {
                emit dataChanged(createIndex(minIndex,objectIndex),createIndex(maxIndex,objectIndex));
            }
        }
        */
        //emit dataChanged(createIndex(minIndex,0),createIndex(maxIndex,0));
        emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0)); // JONS: I suspect sort is causing refresh issues so update entire list
    } else if ( upsert ) {
        m_objectGuard.unlock();
        return add(u);
    }

    return QVariant(matches);
}

QVariant DatabaseList::remove(QVariant q) {
    QMutexLocker locker(&m_objectGuard);
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
    _filter();
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
    QMutexLocker locker(&m_objectGuard);
    QVariantMap query = q.value<QVariantMap>();
    QVariantList matches;
    int count = _activeList().size();
    //qDebug() << "finding : " << query << " : from : " << count << " entries";
    for ( int i = 0; i < count; i++ ) {
        if ( _match(_activeList()[i],query) ) {
            matches.append(_activeList()[i]);
        }
    }
    return QVariant(matches);
}

QVariant DatabaseList::findOne(QVariant q) {
    QMutexLocker locker(&m_objectGuard);
    QVariantMap query = q.value<QVariantMap>();
    QVariantList matches;
    int count = _activeList().size();
    for ( int i = 0; i < count; i++ ) {
        if ( _match(_activeList()[i],query) ) {
            return QVariant(_activeList()[i]);
        }
    }
    return QVariant();
}

QVariant DatabaseList::get(int i) {
    QMutexLocker locker(&m_objectGuard);
    if ( i >= 0 && i < _activeList().size() ) {
        return QVariant(_activeList()[i]);
    }
    return QVariant();
}

void DatabaseList::setSort(QVariant s) {
    if ( m_sort != s ) {
        QMutexLocker locker(&m_objectGuard);
        m_sort = s.value<QVariantMap>();
        beginResetModel();
        _sort();
        _filter();
        endResetModel();
    }
}

void DatabaseList::setFilter(QVariant f) {
    if ( m_filter != f ) {
        QMutexLocker locker(&m_objectGuard);
        m_filter = f.value<QVariantMap>();
        beginResetModel();
        _sort();
        _filter();
        endResetModel();
    }
}
//
//
//
void DatabaseList::beginBatch() {
    beginResetModel();
}
QVariant DatabaseList::batchAdd(QVariant o) {
    QMutexLocker locker(&m_objectGuard);
    QVariantMap object = o.value<QVariantMap>();
    if ( !object.contains("_id") ) {
        object["_id"] = QUuid::createUuid().toString();
    }
    m_objects.append(object);
    QVariantMap id;
    id["_id"] = object["_id"];
    return QVariant(id);
}

QVariant DatabaseList::batchUpdate(QVariant q,QVariant u, bool upsert) {
    QVariantMap query = q.value<QVariantMap>();
    QVariantMap update = u.value<QVariantMap>();
    QVariantList matches;
    //QStringList ids;
    int count = m_objects.size();
    int minIndex = std::numeric_limits<int>::max();
    int maxIndex = std::numeric_limits<int>::min();

    for ( int i = 0; i < count; ++i ) {
        if ( _match(m_objects[i],query) ) {
            if ( i < minIndex ) minIndex = i;
            if ( i > maxIndex ) maxIndex = i;
            QVariantMap object = m_objects[i];
            matches.append(QVariantMap({{"_id",object["_id"]}}));
            //ids.append(object["_id"].toString());
            _update(object,update);
            m_objects.replace(i,object);
        }
    }
    if ( matches.length() > 0 ) {
        return QVariant(matches);
    } else if ( upsert ) {
        qDebug() << "DatabaseList::batchUpdate : upserting : " << update;
        return batchAdd(u);
    }
    return QVariant();
}

void DatabaseList::endBatch() {
    _sort();
    _filter();
    endResetModel();
}
//
//
//
inline bool compare( const QVariantMap& a, const QVariantMap& b, const QString& field, const int direction ) {
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
}
//
//
//
void DatabaseList::_sort() {
    if ( !m_sort.empty() ) {
        std::stable_sort(m_objects.begin(),m_objects.end(),[this](const QVariantMap& a, const QVariantMap& b) -> bool {
            //std::sort(m_objects.begin(),m_objects.end(),[this](const QVariantMap& a, const QVariantMap& b) -> bool {
            QVariantMap::const_iterator it = this->m_sort.constBegin();
            while (it != this->m_sort.constEnd()) {
                if ( !compare(a,b,it.key(),it.value().toInt() ) ) return false;
                ++it;
            }
            return true;
        });
    }
}
void DatabaseList::_filter() {
    if ( !m_filter.isEmpty() ) {
        qDebug() << "filtering " << m_objects.size() << " items by : " << m_filter;
        m_filtered.clear();
        int count = m_objects.size();
        for ( int i = 0; i < count; i++ ) {
            if ( _match(m_objects[i],m_filter) ) {
                m_filtered.append(m_objects[i]);
            }
        }
    } else {
        m_filtered.clear();
    }
}
bool DatabaseList::_match( QVariantMap& object, QVariantMap& query ) {
    for ( QVariantMap::iterator it = query.begin(); it != query.end(); ++it ) {
        QString key = it.key();
        if ( key.contains('.') ) { // nested document query
            QStringList _keys = key.split('.');
            QVariantMap _current = object;
            for ( int i = 0; i < _keys.size() - 1; ++i ) {
                auto& _key = _keys[ i ];
                if ( _current.contains(_key) ) {
                    if ( _current[_key].canConvert<QVariantMap>() ) {
                        _current = _current[_key].value<QVariantMap>();
                    }
                } else {
                    return false;
                }
            }
            if ( !_current.contains(_keys.last()) || !_matchValue( _current[ _keys.last() ], query[ key ] ) ) return false;
        } else if ( key.startsWith('$') ) { // complex ( aggregate ) condition TODO: rethink this
            if ( key == "$or" || key == "$in") {
                QVariantList _conditions = query[key].toList();
                for ( auto& _condition : _conditions ) {
                    QVariantMap _conditionMap = _condition.toMap();
                    QString conditionKey = _conditionMap.firstKey();
                    if ( object.contains(conditionKey) && _matchValue(object[conditionKey],_conditionMap[conditionKey])) return true;
                }
                return false;
            } else if ( key == "$and" ) {
                //qDebug() << "matching $and " << query[key];
                QVariantList _conditions = query[key].toList();
                for ( auto& _condition : _conditions ) {
                    QVariantMap _conditionMap = _condition.toMap();
                    QString conditionKey = _conditionMap.firstKey();
                    if ( !object.contains(conditionKey) || !_matchValue(object[conditionKey],_conditionMap[conditionKey]) ) return false;
                }
                return true;
            } else if ( key == "$nin" ) {
                QVariantList _conditions = query[key].toList();
                for ( auto& _condition : _conditions ) {
                    QVariantMap _conditionMap = _condition.toMap();
                    QString conditionKey = _conditionMap.firstKey();
                    if ( object.contains(conditionKey) && _matchValue(object[conditionKey],_conditionMap[conditionKey])) return false;
                }
                return true;
           }
           qDebug() << "DatabaseList::_match : unsupported operation : " << key;
           return false;
        } else { // simple condiion
            if ( !object.contains(key) || !_matchValue( object[ key ], query[ key ] ) ) return false;
        }
    }
    return true;
}
inline bool DatabaseList::_matchValue( QVariant& value, QVariant& condition ) {
    if ( value.canConvert<QVariantList>() ) { // value is array
        // TODO: array of documents
        qDebug() << "DatabaseList::_matchValue : matching array";
        QVariantList _value = value.value<QVariantList>();
        for ( auto& _current : _value ) {
            if ( _matchValue( _current, condition ) ) {
                return true;
            }
        }
        return false;
    } else if ( condition.canConvert<QVariantMap>() ) { // condition is complex
        //
        // complex comparison
        // TODO: possibly shift this to function table
        // QMap<QString, std::function<??> m_operators;
        //
        QVariantMap _condition = condition.value<QVariantMap>();
        if ( _condition.contains("$in") ) { // TODO: combine $in and $or ????
            //qDebug() << "matching $in";
            QVariantList _values = _condition.value( "$in" ).toList();
            for ( auto& _value : _values ) {
                //qDebug() << "matching : " << value << " : " << _value;
                //if ( value == _value ) return true;
                if ( _matchValue(value, _value) ) return true; // allow complex conditions
            }
            return false;
        } else if ( _condition.contains("$nin") ) {
            //qDebug() << "matching $nin";
            QVariantList _values = _condition.value( "$in" ).toList();
            for ( auto& _value : _values ) {
                //qDebug() << "matching : " << value << " : " << _value;
                //if ( value == _value ) return true;
                if ( _matchValue(value, _value) ) return false; // allow complex conditions
            }
            return true;
        } else if ( _condition.contains("$or") ) {
            //qDebug() << "matching $or";
            QVariantList _values = _condition.value( "$or" ).toList();
            for ( auto& _value : _values ) {
                //qDebug() << "matching : " << value << " : " << _value;
                //if ( value == _value ) return true;
                if ( _matchValue(value, _value) ) return true; // allow complex conditions
            }
        } else if ( _condition.contains("$and") ) {
            //qDebug() << "matching $and";
            QVariantList _values = _condition.value( "$and" ).toList();
            for ( auto& _value : _values ) {
                //qDebug() << "matching : " << value << " : " << _value;
                //if ( value != _value ) return false;
                if ( !_matchValue(value, _value) ) return false; // allow complex conditions
            }
            return true;
        } else if ( _condition.contains("$startswith") ) {
            QString _comparator = _condition.value("$startswith").toString();
            QString _value = value.toString();
            if ( _comparator.length() > 0 && _value.length() > 0 ) {
                return _value.startsWith(_comparator);
            }
            return false;
        } else if ( _condition.contains("$lt") ) {
            return value < _condition.value("$lt");
        } else if ( _condition.contains("$lte") ) {
            //qDebug() << "matching : $lte : " << value << " <= " << _condition.value("$lte");
            return value <= _condition.value("$lte");
        } else if ( _condition.contains("$gt") ) {
            return value > _condition.value("$gt");
        } else if ( _condition.contains("$gte") ) {
            return value >= _condition.value("$gte");
        } else if ( _condition.contains("$ne") ) {
            return value != _condition.value("$ne");
        }
        return false;
    } else if ( condition.canConvert<QRegExp>() ) {
        qDebug() << "matching regexp : " << condition;
        QRegExp _condition = condition.toRegExp();
        QString _value = value.toString();
        return _condition.exactMatch(_value);
    }
    //
    // simple comparison
    //
    return value == condition;
}

void DatabaseList::_update( QVariantMap& object, QVariantMap& update ) {
    for ( QVariantMap::iterator it = update.begin(); it != update.end(); ++it ) {
        //
        // TODO: handle nested array / document updates
        //
        object[ it.key() ] = it.value();
    }
}
QString DatabaseList::_path() {
    return SystemUtils::shared()->documentDirectory().append("/").append(m_collection).append(".json");
}
int DatabaseList::_indexOfItem( const QString& _id ) {
    int count = _activeList().size();
    for ( int i = 0; i < count; ++i ) {
        if ( _activeList()[i].contains("_id") ) {
            if ( _activeList()[i][ "_id" ].toString() == _id ) {
                return i;
            }
        }
    }
    return -1;
}
