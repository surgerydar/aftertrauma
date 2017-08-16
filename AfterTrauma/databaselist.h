#ifndef DATABASELIST_H
#define DATABASELIST_H

#include <QAbstractListModel>
#include <QList>
#include <QVariant>
#include <QVariantMap>

class DatabaseList : public QAbstractListModel
{
    Q_OBJECT
    //
    //
    //
    Q_PROPERTY(QString collection WRITE setCollection MEMBER m_collection NOTIFY collectionChanged)
    //
    //
    //
public:
    explicit DatabaseList(QObject *parent = 0);
    //
    // QAbstractListModel overrides
    //
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    //
    //
    //
    void setCollection( QString collection );
signals:
    //
    //
    //
    void collectionChanged();
    void sortChanged();
    void error(QString operation,QString error);
    //
    //
    //
public slots:
    //
    //
    //
    void load();
    void save();
    //
    //
    //
    QVariant add(QVariant&o);
    QVariant update(QVariant&q,QVariant&u);
    QVariant remove(QVariant&q);
    QVariant find(QVariant&q);
    void sort(QVariant&s);
    //
    //
    //
private slots:
    //
    //
    //
private:
    QString             m_collection;
    QVariantMap         m_sort;
    QList<QVariantMap>  m_objects;
    //
    //
    //
    void _sort();
    bool _match( QVariantMap& object, QVariantMap& query );
    void _update( QVariantMap& object, QVariantMap& update );
    QString _path();
};

#endif // DATABASELIST_H
