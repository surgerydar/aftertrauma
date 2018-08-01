#ifndef UPLOADER_H
#define UPLOADER_H

#include <QObject>

class Uploader : public QObject
{
    Q_OBJECT
public:
    explicit Uploader(QObject *parent = 0);
    //
    //
    //
    static Uploader* shared();

signals:
    void done( const QString& source, const QString& destination );
    void error( const QString& source, const QString& destination, const QString& message );
    void progress( const QString& source, const QString& destination, int total, int current, const QString& message );

public slots:
    void upload( const QString& source, const QString& destination );

private:
    static Uploader* s_shared;
};

#endif // UPLOADER_H
