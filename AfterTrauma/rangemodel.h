#ifndef RANGEMODEL_H
#define RANGEMODEL_H

#include <QAbstractListModel>

class RangeModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int min READ min WRITE setMin NOTIFY minChanged)
    Q_PROPERTY(int max READ max WRITE setMax NOTIFY maxChanged)
public:
    explicit RangeModel(QObject *parent = 0);
    //
    // QAbstractListModel overrides
    //
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    //
    //
    //
    int min() const { return m_min; }
    void setMin( const int min ) { m_min = min; emit minChanged(m_min); }
    int max() const { return m_max; }
    void setMax( const int max ) { m_max = max; emit maxChanged(m_max); }

signals:
    void minChanged( const int value );
    void maxChanged( const int value );

public slots:
    QVariant get(int i);

private:
    int m_min;
    int m_max;
};

#endif // RANGEMODEL_H
