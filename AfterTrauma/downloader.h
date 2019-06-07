#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QNetworkAccessManager>

class Downloader : public QObject
{
    Q_OBJECT
public:
    explicit Downloader(QObject *parent = 0);
    //
    //
    //
    static Downloader* shared();

signals:
    void done( const QString& source, const QString& destination );
    void error( const QString& source, const QString& destination, const QString& message );
    void progress( const QString& source, const QString& destination, quint64 total, quint64 current, const QString& message );

public slots:
    void download( const QString& url, const QString& filename );

private slots:

private:
    static Downloader* s_shared;

    QNetworkAccessManager m_manager;
};

#endif // DOWNLOADER_H
