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
    QVariant read(QString path);
    bool write(QString path,QVariant object);
};

#endif // JSONFILE_H
