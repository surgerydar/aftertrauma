#ifndef JSONFILE_H
#define JSONFILE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>

class JSONFile : public QObject
{
    Q_OBJECT
public:
    explicit JSONFile(QObject *parent = 0);
    static JSONFile* shared();
private:
    static JSONFile* s_shared;
signals:
    void objectReadFrom(QString path, QVariant object);
    void arrayReadFrom(QString path, QVariant array);
    void objectWrittenTo(QString path);
    void arrayWrittenTo(QString path);
    void errorReadingFrom(QString path, QString error);
public slots:
    void read(QString path);
    void writeObject(QVariant& object, QString path);
    void writeArray(QVariant& object, QString path);
};

#endif // JSONFILE_H
