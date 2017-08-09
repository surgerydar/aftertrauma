#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QVariantMap>
#include <QJsonObject>
#include <QJsonArray>

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = 0);
    static Database* shared();
    QString generateObjectId();
private:
    static Database* s_shared;
signals:
    void success( QString collection, QString operation, QVariant result );
    void error( QString collection, QString operation, QString error );
public slots:
    void load();
    void save();
    QVariant insert( QString collection, QVariant object );
    QVariant update( QString collection, QVariant query, QVariant object );
    QVariant remove( QString collection, QVariant query );
    QVariant find( QString collection, QVariant query, QVariant sort );
    QVariant findOne( QString collection, QVariant query );

private:
    QVariantList& getCollection( QString& collection );
    QVariantMap m_collections;
    bool matchDocument( QVariantMap& document, QVariantMap& query );
};

#endif // DATABASE_H
