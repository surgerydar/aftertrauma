#ifndef NETWORKACCESS_H
#define NETWORKACCESS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QUrl>
//
// TODO: add accessability slots
//
class NetworkAccess : public QObject
{
    Q_OBJECT
public:
    explicit NetworkAccess(QObject *parent = 0);
    //
    //
    //
    static NetworkAccess* shared();
    //
    //
    //
    QNetworkReply* get( const QString& url );
    QNetworkReply* get( const QUrl& url );

signals:

public slots:

private slots:
    void replyFinished(QNetworkReply *reply);

private:
    static NetworkAccess* s_shared;
    //
    //
    //
    QNetworkAccessManager* m_manager;
};

#endif // NETWORKACCESS_H
