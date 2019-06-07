#include "rangemodel.h"

const QString kValue = "value";

RangeModel::RangeModel(QObject *parent) : QAbstractListModel(parent) {
    m_min = m_max = 0;
}
//
// QAbstractListModel overrides
//
QHash<int, QByteArray> RangeModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[ 0 ] = kValue.toUtf8();
    return roles;
}
int RangeModel::rowCount(const QModelIndex& /*parent*/) const {
    return m_max - m_min;
}
QVariant RangeModel::data(const QModelIndex& index, int /*role*/) const {
    if (index.row() >= 0 && index.row() <= m_max - m_min) {
        return QVariant(m_min + index.row());
    }
    return QVariant();
}
//
//
//
QVariant RangeModel::get(int i) {
    if ( i > 0 && i <= m_max - m_min ) {
        return QVariant(m_min + i);
    }
    return QVariant();
}
