#include "uploadchannel.h"
#include <QFile>
#include <QBuffer>
#include <QDataStream>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

const char* upld = "upld";
const char* head = "head";
const char* chnk = "chnk";
const quint16 kChunkSize = 2048;

UploadChannel::UploadChannel(QObject *parent) : QObject(parent) {

}

void UploadChannel::start() {
    QString message;
    //
    // open file
    //
    qDebug() << "UploadChannel::run : openning ; " << m_source;
    m_file.setFileName(m_source);
    if ( m_file.open(QFile::ReadOnly) ) {
        //
        //
        //
        m_chunkCount = m_file.size() / kChunkSize;
        m_chunksWritten = 0;
        //
        // open channel
        //
        openChannel();
    } else {
        message = "unable to open file";
        emit error( m_source, m_destination, message );
        qDebug() << message << " : " << m_source;
    }
}

void UploadChannel::openChannel() {
    //
    //
    //
    qDebug() << "UploadChannel::run : openning upload channel : " << m_destination;
    m_channel = new QWebSocket();
    //
    //
    //
    /*
    connect(m_channel, &QWebSocket::connected,[this]() {
        qDebug() << "lambda connected";
    });
    connect(m_channel, &QWebSocket::disconnected,[this]() {
        qDebug() << "lambda disconnected";
    });
    connect(m_channel, &QWebSocket::textMessageReceived,[this](const QString& message) {
        qDebug() << "lambda textMessageReceived : " << message;
    });
    */
    connect(m_channel, &QWebSocket::connected, this, &UploadChannel::connected);
    connect(m_channel, &QWebSocket::disconnected, this, &UploadChannel::disconnected);
    connect(m_channel, &QWebSocket::textMessageReceived, this, &UploadChannel::textMessageReceived);
    connect(m_channel, &QWebSocket::binaryMessageReceived, this, &UploadChannel::binaryMessageReceived);
    connect(m_channel, static_cast<void (QWebSocket::*)(QAbstractSocket::SocketError)>(&QWebSocket::error), this, &UploadChannel::socketError);
    //
    //
    //
    m_channel->open(m_destination);
}

void UploadChannel::makeCommandHeader( QDataStream& stream, const char* selector ) {
    stream.writeRawData(upld,4);
    stream.writeRawData(m_guid,16);
    stream.writeRawData(selector,4);

}

void UploadChannel::sendHeader() {
    //
    //
    //
    m_fileSize = ( quint32 ) m_file.size();
    m_bytesWritten = 0;
    for ( int i = 0; i < 16; i++ ) {
        m_guid[ i ] = qrand() % 128;
    }
    //
    // write header
    //
    QByteArray buffer;
    QDataStream stream( &buffer, QIODevice::WriteOnly );
    stream.setByteOrder(QDataStream::BigEndian);
    makeCommandHeader( stream, head );
    QString filepath = m_file.fileName();
    QByteArray filename = filepath.right((filepath.length()-filepath.lastIndexOf('/'))-1).toLatin1(); // TODO: need a better way of achieving this
    stream << ( quint16 ) filename.size();
    stream.writeRawData(filename.data(),filename.size());
    stream << m_fileSize;
    qDebug() << "UploadChannel::sendHeader : filename " << filename;
    m_channel->sendBinaryMessage(buffer);
}

bool UploadChannel::sendChunk() {
    //
    //
    //
    QByteArray data = m_file.read(kChunkSize);
    if ( data.size() > 0 ) {
        //
        // write chunk
        //
        QByteArray buffer;
        QDataStream stream( &buffer, QIODevice::WriteOnly );
        makeCommandHeader( stream, chnk );
        //stream << ( quint16 ) data.size();
        stream.writeRawData(data.data(),data.size());
        m_channel->sendBinaryMessage(buffer);
        //
        //
        //
        m_bytesWritten += data.size();
    }
    qDebug() << "UploadChannel::sendChunk : written " << m_bytesWritten << " of " << m_fileSize;
    return data.size() == kChunkSize;
}

void UploadChannel::connected() {
    qDebug() << "UploadChannel::connected";
}

void UploadChannel::disconnected() {
    //
    // should check upload has completed
    //
    qDebug() << "UploadChannel::disconnected";
}

void UploadChannel::textMessageReceived(const QString& message) {
    QString prompt;
    qDebug() << "UploadChannel::textMessageReceived : " << message;
    QVariantMap command = parseCommand( message );
    if ( command.contains("command" ) ) {
        if ( command["command"] == "welcome" ) {
            sendHeader();
            prompt = "initialising upload";
            emit progress( m_source, m_destination, m_chunkCount, m_chunksWritten, prompt );
        }
    } else {
        if ( command.contains("status") ) {
            if ( command["status"] == "DONE" ) {
                prompt = "data uploaded";
                //emit progress( m_source, m_destination, m_chunkCount, m_chunksWritten++, prompt );
                emit done(m_source, m_destination);
                m_channel->close();
                this->deleteLater();
            } else if ( command["status"] == "READY" ){
                sendChunk();
                QString prompt = "uploading data";
                emit progress( m_source, m_destination, m_chunkCount, m_chunksWritten++, prompt );
            }
        }
    }
}

void UploadChannel::binaryMessageReceived(const QByteArray& message) {

}

void UploadChannel::socketError(QAbstractSocket::SocketError error) {
    QString errorText( "UploadChannel::socketError : ");
    switch( error ) {
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
    QString socketErrorString = m_channel->errorString();
    if ( socketErrorString.length() > 0 ) {
        errorText.append(" : ");
        errorText.append( socketErrorString );
    }
    qDebug() << errorText;
}

QVariantMap UploadChannel::parseCommand( const QString& message ) {
    QByteArray json;
    json.append(message);
    QJsonDocument document = QJsonDocument::fromJson(json);
    if ( !document.isEmpty() && document.isObject() ) {
        return document.object().toVariantMap();
    }
    return QVariantMap();
}
