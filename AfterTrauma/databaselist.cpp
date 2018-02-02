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
    object["_id"] = QUuid::createUuid().toString();
    beginResetModel();
    m_objects.append(object);
    _sort();
    _filter();
    endResetModel();
    //emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
    //emit countChanged();
    QVariantMap id;
    id["_id"] = object["_id"];
    return QVariant(id);
}

QVariant DatabaseList::update(QVariant q,QVariant u, bool upsert) {
    QVariantMap query = q.value<QVariantMap>();
    QVariantMap update = u.value<QVariantMap>();
    QVariantList matches;
    int count = m_objects.size();
    int minIndex = std::numeric_limits<int>::max();
    int maxIndex = std::numeric_limits<int>::min();
    //beginResetModel();
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
    //endResetModel();

    if ( matches.size() > 0 ) {
        qDebug() << "updated from : " << minIndex << " : to : " << maxIndex;
        emit dataChanged(createIndex(minIndex,0),createIndex(maxIndex,0));

    } else if ( upsert ) {
        return add(u);
    }

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
    QVariantMap query = q.value<QVariantMap>();
    QVariantList matches;
    int count = _activeList().size();
    qDebug() << "finding : " << query << " : from : " << count << " entries";
    for ( int i = 0; i < count; i++ ) {
        if ( _match(_activeList()[i],query) ) {
            matches.append(_activeList()[i]);
        }
    }
    return QVariant(matches);
}

QVariant DatabaseList::findOne(QVariant q) {
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
    if ( i >= 0 && i < _activeList().size() ) {
        return QVariant(_activeList()[i]);
    }
    return QVariant();
}

void DatabaseList::setSort(QVariant s) {
    if ( m_sort != s ) {
        m_sort = s.value<QVariantMap>();
        beginResetModel();
        _sort();
        _filter();
        endResetModel();
    }
}

void DatabaseList::setFilter(QVariant f) {
    if ( m_filter != f ) {
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
    QVariantMap object = o.value<QVariantMap>();
    object["_id"] = QUuid::createUuid().toString();
    m_objects.append(object);
    QVariantMap id;
    id["_id"] = object["_id"];
    return QVariant(id);
}
void DatabaseList::endBatch() {
    _sort();
    _filter();
    endResetModel();
}
//
//
//
void DatabaseList::_sort() {
    if ( !m_sort.empty() ) {
        QString field = m_sort.firstKey();
        int direction = m_sort.first().value<int>();
        //qDebug() << "sorting " << m_objects.size() << " items by : " << field << " direction : " << direction;
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
void DatabaseList::_filter() {
    if ( !m_filter.isEmpty() ) {
        //qDebug() << "filtering " << m_objects.size() << " items by : " << m_filter;
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
        if ( it.key().contains('.') ) { // nested document query
            QStringList _keys = it.key().split('.');
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
            if ( !_current.contains(_keys.last()) || !_matchValue( _current[ _keys.last() ], query[ it.key() ] ) ) return false;
        } else if ( !object.contains(it.key()) || !_matchValue( object[ it.key() ], query[ it.key() ] ) ) return false;
    }
    return true;
}
inline bool DatabaseList::_matchValue( QVariant& value, QVariant& condition ) {
    if ( value.canConvert<QVariantList>() ) { // value is array
        // TODO: array of documents
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
        //
        QVariantMap _condition = condition.value<QVariantMap>();
        if ( _condition.contains("$in") ) {
            //qDebug() << "matching $in";
            QVariantList _values = _condition.value( "$in" ).toList();
            for ( auto& _value : _values ) {
                //qDebug() << "matching : " << value << " : " << _value;
                if ( value == _value ) return true;
            }
        } else if ( _condition.contains("$or") ) {
            //qDebug() << "matching $or";
            QVariantList _values = _condition.value( "$or" ).toList();
            for ( auto& _value : _values ) {
                //qDebug() << "matching : " << value << " : " << _value;
                if ( value == _value ) return true;
            }
        } else if ( _condition.contains("$and") ) {
            //qDebug() << "matching $and";
            QVariantList _values = _condition.value( "$and" ).toList();
            for ( auto& _value : _values ) {
                //qDebug() << "matching : " << value << " : " << _value;
                if ( value != _value ) return false;
            }
            return true;
        } else if ( _condition.contains("$startswith") ) {
            QString _comparator = _condition.value("$startswith").toString();
            QString _value = value.toString();
            if ( _comparator.length() > 0 && _value.length() > 0 ) {
                return _value.startsWith(_comparator);
            }
            return false;
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
