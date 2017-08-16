#include "databaselist.h"
#include "database.h"

DatabaseList::DatabaseList(QObject *parent) : QAbstractListModel(parent) {

}

int DatabaseList::rowCount(const QModelIndex &parent) const {
    return 0;
}

QVariant DatabaseList::data(const QModelIndex &index, int role) const {
    return QVariant();
}
//
//
//
QVariant DatabaseList::add(QVariant&o) {
    return QVariant();
}

QVariant DatabaseList::update(QVariant&o) {
    return QVariant();
}

QVariant DatabaseList::remove(QVariant&q) {
    return QVariant();
}

QVariant DatabaseList::find(QVariant&q) {
    return QVariant();
}
