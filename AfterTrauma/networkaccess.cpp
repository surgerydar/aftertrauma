#include "networkaccess.h"
#include <QNetworkRequest>
#include <QNetworkReply>

NetworkAccess* NetworkAccess::s_shared = nullptr;

NetworkAccess::NetworkAccess(QObject *parent) : QObject(parent) {
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &NetworkAccess::replyFinished);
    connect(m_manager, &QNetworkAccessManager::sslErrors,[=](QNetworkReply *reply, const QList<QSslError> &errors) {

    });
}
//
//
//
NetworkAccess* NetworkAccess::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new NetworkAccess;
    }
    return s_shared;
}
//
//
//
QNetworkReply* NetworkAccess::get( const QString& url ) {
    return get( QUrl( url ) );
}

QNetworkReply* NetworkAccess::get( const QUrl& url ) {
    return m_manager->get(QNetworkRequest(url));
}
//
//
//
void NetworkAccess::replyFinished(QNetworkReply *reply) {
    if ( reply->error() == QNetworkReply::NoError ) {
        qDebug() << "NetworkAccess::replyFinished : ok";
        //reply->close(); //????
    } else {
        qDebug() << "NetworkAccess::replyFinished : error : " << reply->errorString();
    }
}

