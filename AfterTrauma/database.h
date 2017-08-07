#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QVariantMap>

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = 0);
    static Database* shared();
private:
    static Database* s_shared;
signals:
    void success( QString collection, QString operation, QVariant result );
    void error( QString collection, QString operation, QString error );
public slots:
    void load();
    void save();
    void insert( QString collection, QVariant object );
    void update( QString collection, QVariant query, QVariant object );
    void remove( QString collection, QVariant query );
    void find( QString collection, QVariant query );
    void findOne( QString collection, QVariant query );

private:
    QVariantMap m_collections;
};

#endif // DATABASE_H
