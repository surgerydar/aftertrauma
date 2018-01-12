#include "daily.h"

Daily::Daily(QObject *parent) : QAbstractListModel(parent) {

}

int Daily::rowCount(const QModelIndex &parent) const {
    return 0;
}

QVariant Daily::data(const QModelIndex &index, int role) const {
    return QVariant();
}

