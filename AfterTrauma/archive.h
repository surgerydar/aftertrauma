#ifndef ARCHIVE_H
#define ARCHIVE_H

#include <QObject>
#include <QString>
#include <QList>

class Archive : public QObject
{
    Q_OBJECT
public:
    //
    //
    //
    static const QString ARCHIVE;
    static const QString UNARCHIVE;
    //
    //
    //
    explicit Archive(QObject *parent = 0);
    //
    //
    //
    static Archive* shared();

signals:
    void done( const QString& operation, const QString& archive, const QString& target );
    void error( const QString& operation, const QString& archive, const QString& target, const QString& error );

public slots:
    void archive( const QString& source, const QString& archive );
    void unarchive( const QString& archive, const QString& target );

private:
    static Archive* s_shared;

};

#endif // ARCHIVE_H
