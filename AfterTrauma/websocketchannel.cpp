#include <QVariant>
#include <QVariantMap>
#include <QUuid>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

#include "websocketchannel.h"
//
// TODO: error handling
//
WebSocketChannel::WebSocketChannel(QObject *parent) : QObject(parent) {
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocketChannel::connected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WebSocketChannel::disconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &WebSocketChannel::textMessageReceived);
}
void WebSocketChannel::open() {
    m_webSocket.open(m_url);
}

void WebSocketChannel::close() {
    m_webSocket.close();
}

QString WebSocketChannel::send(QVariant command) {
    if ( m_webSocket.state() == QAbstractSocket::UnconnectedState ) {
        qDebug() << "WebSocketChannel:send : error : not connected to : " << m_url;
        return "";
    }
    QVariantMap object = command.value<QVariantMap>();
    //
    // generate GUID for command
    //
    QString guid = QUuid::createUuid().toString();
    object["guid"] = guid;
    //
    // convert to JSON
    //
    QJsonDocument doc;
    doc.setObject(QJsonObject::fromVariantMap(object));
    QString message = doc.toJson();
    m_webSocket.sendTextMessage(message);
    //
    //
    //
    return guid;
}

void WebSocketChannel::connected() {
    qDebug() << "WebSocketChannel:connected";
}

void WebSocketChannel::disconnected() {
    qDebug() << "WebSocketChannel:disconnected";
    if ( m_autoreconnect ) {
        open();
    }
}

void WebSocketChannel::textMessageReceived(const QString& message) {
    qDebug() << "WebSocketChannel:textMessageReceived : " << message;
    emit received(message);
}
