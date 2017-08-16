#ifndef DATABASELIST_H
#define DATABASELIST_H

#include <QAbstractListModel>

class DatabaseList : public QAbstractListModel
{
    Q_OBJECT
    //
    //
    //
    Q_PROPERTY(QString collection MEMBER m_collection NOTIFY collectionChanged)
    //
    //
    //
public:
    explicit DatabaseList(QObject *parent = 0);
    //
    //
    //
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    //
    //
    //
    QVariant add(QVariant&o);
    QVariant update(QVariant&o);
    QVariant remove(QVariant&q);
    QVariant find(QVariant&q);
    //
    //
    //
signals:
    void collectionChanged();

public slots:

private:
    QString             m_collection;
    QList<QVariantMap>  m_objects;
};

#endif // DATABASELIST_H
