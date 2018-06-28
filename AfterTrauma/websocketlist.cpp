#include "websocketlist.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

WebSocketList::WebSocketList(QObject *parent) : QAbstractListModel(parent) {
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocketList::connected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WebSocketList::disconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &WebSocketList::textMessageReceived);
    connect(&m_webSocket, static_cast<void (QWebSocket::*)(QAbstractSocket::SocketError)>(&QWebSocket::error), this, &WebSocketList::socketError);
}

void WebSocketList::connected() {
    qDebug() << "WebSocketChannel:connected";
    emit opened();
}

void WebSocketList::disconnected() {
    qDebug() << "WebSocketChannel:disconnected";
    emit closed();
}

void WebSocketList::textMessageReceived(const QString& message) {
    qDebug() << "WebSocketList:textMessageReceived : ";// << message;
    //
    // parse
    //
    QJsonParseError parseError;
    QByteArray ba;
    ba.append(message);
    QJsonDocument doc(QJsonDocument::fromJson(ba,&parseError));
    if ( doc.isObject() ) {
        QVariantMap command = doc.object().toVariantMap();
        if ( command.contains("command") && command["command"] == m_command["command"] ) {
            qDebug() << "WebSocketList : received response";
            if ( command.contains("status") && command["status"].toString() == "OK" ) {
                QVariantList response = command[ "response" ].value<QVariantList>();
                populateList( response );
            } else {
                QString err( "WebSocketList : server error : " );
                if ( command.contains("error") ) {
                    err.append(command["error"].toString());
                }
                qDebug() << err;
                emit error(err);
            }
        } else {
            qDebug() << "WebSocketList : unknown command : " << command;
        }
    } else {
        QString err( "WebSocketList : parse error : " );
        if ( parseError.error != QJsonParseError::NoError ) {
            err.append(parseError.errorString());
        } else {
            err.append("unexpected format");
        }
        qDebug() << err;
        emit error(err);
    }
}

void WebSocketList::socketError(QAbstractSocket::SocketError err) {
    QString errorText( "socket error : ");
    switch( err ) {
    case QAbstractSocket::ConnectionRefusedError :
        errorText.append("ConnectionRefusedError");
        break;
    case QAbstractSocket::RemoteHostClosedError  :
        errorText.append("RemoteHostClosedError");
        break;
    case QAbstractSocket::HostNotFoundError :
        errorText.append("HostNotFoundError");
        break;
    case QAbstractSocket::SocketAccessError :
        errorText.append("SocketAccessError");
        break;
    case QAbstractSocket::SocketResourceError :
        errorText.append("SocketResourceError");
        break;
    case QAbstractSocket::SocketTimeoutError :
        errorText.append("SocketTimeoutError");
        break;
    case QAbstractSocket::DatagramTooLargeError :
        errorText.append("DatagramTooLargeError");
        break;
    case QAbstractSocket::NetworkError :
        errorText.append("NetworkError");
        break;
    case QAbstractSocket::AddressInUseError :
        errorText.append("AddressInUseError");
        break;
    case QAbstractSocket::SocketAddressNotAvailableError :
        errorText.append("SocketAddressNotAvailableError");
        break;
    case QAbstractSocket::UnsupportedSocketOperationError :
        errorText.append("UnsupportedSocketOperationError");
        break;
    case QAbstractSocket::UnfinishedSocketOperationError :
        errorText.append("UnfinishedSocketOperationError");
        break;
    case QAbstractSocket::ProxyAuthenticationRequiredError :
        errorText.append("ProxyAuthenticationRequiredError");
        break;
    case QAbstractSocket::SslHandshakeFailedError :
        errorText.append("SslHandshakeFailedError");
        break;
    case QAbstractSocket::ProxyConnectionRefusedError :
        errorText.append("ProxyConnectionRefusedError");
        break;
    case QAbstractSocket::ProxyConnectionClosedError :
        errorText.append("ProxyConnectionClosedError");
        break;
    case QAbstractSocket::ProxyConnectionTimeoutError :
        errorText.append("ProxyConnectionTimeoutError");
        break;
    case QAbstractSocket::ProxyNotFoundError :
        errorText.append("ProxyNotFoundError");
        break;
    case QAbstractSocket::ProxyProtocolError :
        errorText.append("ProxyProtocolError");
        break;
    case QAbstractSocket::OperationError :
        errorText.append("OperationError");
        break;
    case QAbstractSocket::SslInternalError :
        errorText.append("SslInternalError");
        break;
    case QAbstractSocket::SslInvalidUserDataError :
        errorText.append("SslInvalidUserDataError");
        break;
    case QAbstractSocket::TemporaryError :
        errorText.append("TemporaryError");
        break;
    default:
        errorText.append("Unknown error");
    }
    QString socketErrorString = m_webSocket.errorString();
    if ( socketErrorString.length() > 0 ) {
        errorText.append(" : ");
        errorText.append( socketErrorString );
    }
    emit error(errorText);
}
//
//
//
QHash<int, QByteArray> WebSocketList::roleNames() const {
    QHash<int, QByteArray> roles;
    for ( int i = 0; i < m_roles.size(); i++ ) {
        roles[ i ] = m_roles[ i ].toUtf8();
    }
    return roles;
}

int WebSocketList::rowCount(const QModelIndex& /*parent*/) const {
    return m_objects.size();
}

QVariant WebSocketList::data(const QModelIndex &index, int role) const {
    if ( index.row() >= 0 && index.row() < rowCount(index.parent()) && role < m_roles.size() ) {
        return QVariant(m_objects[index.row()][m_roles[role]]);
    }
    return QVariant();
}
//
//
//
void WebSocketList::setCommand( const QVariant command ) {
    m_command = command.value<QVariantMap>();
    //refresh();
}
//
//
//
void WebSocketList::open() {
    m_webSocket.open(m_url);
}

void WebSocketList::close() {
    m_webSocket.close();
}

QVariant WebSocketList::get(int i) {
    if ( i >= 0 && i < m_objects.size() ) {
        return QVariant(m_objects[i]);
    }
    return QVariant();
}

void WebSocketList::refresh() {
    qDebug() << "WebSocketList::refresh";
    if ( m_webSocket.state() == QAbstractSocket::UnconnectedState ) {
        qDebug() << "WebSocketList:send : error : not connected to : " << m_url;
        emit error("not connected");
    } else {
        //
        // send command
        //
        QJsonDocument doc(QJsonObject::fromVariantMap(m_command));
        QString message = doc.toJson();
        qDebug() << "WebSocketList::connected : sending message";
        m_webSocket.sendTextMessage(message);
    }
}

void WebSocketList::clear() {
    beginResetModel();
    int count = m_objects.size();
    m_objects.clear();
    endResetModel();
    emit dataChanged(createIndex(0,0),createIndex(count-1,0));
}
//
//
//
void WebSocketList::populateList(const QVariantList& data ) {
    qDebug() << "WebSocketList::populateList : " << data.size() << " objects";
    beginResetModel();
    m_objects.clear();
    for ( auto& object : data ) {
        m_objects.append(object.value<QVariantMap>());
    }
    endResetModel();
    emit dataChanged(createIndex(0,0),createIndex(m_objects.size()-1,0));
}
