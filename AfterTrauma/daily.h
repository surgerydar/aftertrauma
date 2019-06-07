#ifndef DAILY_H
#define DAILY_H

#include <QObject>
#include <QAbstractListModel>

class Daily : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit Daily(QObject *parent = 0);
    //
    //
    //
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
signals:

public slots:
};

#endif // DAILY_H
