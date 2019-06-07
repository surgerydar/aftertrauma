#include "uploadthread.h"
#include <QFile>
#include <QBuffer>
#include <QDataStream>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include "websocketchannel.h"

const char* upld = "upld";
const char* head = "head";
const char* chnk = "chnk";
const quint16 kChunkSize = 2048;

UploadThread::UploadThread(QObject *parent) : QThread(parent) {

}

void UploadThread::run() {
    QString message;
    //
    // open file
    //
    qDebug() << "UploadThread::run : openning ; " << m_source;
    m_file.setFileName(m_source);
    if ( m_file.open(QFile::ReadOnly) ) {
        //
        // open channel
        //
        openChannel();
        //
        // wait for channel to open
        //
        qDebug() << "UploadThread::run : waiting for welcome";
        m_mutex.lock();
        m_ready.wait(&m_mutex);
        m_mutex.unlock();
        //
        //
        //
        if ( isChannelOpen() ) {

            qDebug() << "UploadThread::run : writing header";
            //
            // write header
            //
            int chunkCount = m_file.size() / kChunkSize;
            int chunksWritten = 0;
            //
            //
            //
            sendHeader();
            message = "initialising upload";
            emit progress( m_source, m_destination, chunkCount, chunksWritten, message );
            //
            //
            //
            qDebug() << "UploadThread::run : writing data";
            message = "writing data";
            do {
                //
                // wait for channel
                //
                m_mutex.lock();
                m_ready.wait(&m_mutex);
                m_mutex.unlock();
                //
                //
                //
                if ( !isChannelOpen() ) {
                    message = "channel unexpectedly closed";
                    emit error( m_source, m_destination, message );
                    qDebug() << message << " : " << m_destination;
                    return;
                }
                emit progress( m_source, m_destination, chunkCount, chunksWritten++, message );
                qDebug() << "file uploaded";

            } while( sendChunk() );
            emit done( m_source, m_destination );
            qDebug() << "file uploaded";


        } else {
            message = "channel unexpectedly closed before head";
            emit error( m_source, m_destination, message );
            qDebug() << message << " : " << m_destination;
        }
    } else {
        message = "unable to open file";
        emit error( m_source, m_destination, message );
        qDebug() << message << " : " << m_source;
    }
}
void UploadThread::openChannel() {
    //
    //
    //
    qDebug() << "UploadThread::run : openning upload channel : " << m_destination;
    m_channel = new QWebSocket();
    m_channel->moveToThread(this);
    //
    //
    //
    connect(m_channel, &QWebSocket::connected,[this]() {
        qDebug() << "lambda connected";
    });
    connect(m_channel, &QWebSocket::disconnected,[this]() {
        qDebug() << "lambda disconnected";
    });
    connect(m_channel, &QWebSocket::textMessageReceived,[this](const QString& message) {
        qDebug() << "lambda textMessageReceived : " << message;
    });
    connect(m_channel, &QWebSocket::connected, this, &UploadThread::connected);
    connect(m_channel, &QWebSocket::disconnected, this, &UploadThread::disconnected);
    connect(m_channel, &QWebSocket::textMessageReceived, this, &UploadThread::textMessageReceived);
    connect(m_channel, &QWebSocket::binaryMessageReceived, this, &UploadThread::binaryMessageReceived);
    connect(m_channel, static_cast<void (QWebSocket::*)(QAbstractSocket::SocketError)>(&QWebSocket::error), this, &UploadThread::socketError);
    //
    //
    //
    m_channel->open(m_destination);
}

void UploadThread::makeCommandHeader( QDataStream& stream, const char* selector ) {
    stream.writeRawData(upld,4);
    stream.writeRawData(selector,4);
    stream << m_guid;
}

void UploadThread::sendHeader() {
    //
    // write header
    //
    QByteArray buffer;
    QDataStream stream( &buffer, QIODevice::WriteOnly );
    makeCommandHeader( stream, head );
    QByteArray filename = m_file.fileName().right(m_file.fileName().lastIndexOf('/')).toLatin1();
    stream << ( quint16 ) filename.size();
    stream.writeRawData(filename.data(),filename.size());
    stream << ( quint32 ) m_file.size();
    m_channel->sendBinaryMessage(buffer);
}

bool UploadThread::sendChunk() {
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
        stream << ( quint16 ) data.size();
        stream.writeRawData(data.data(),data.size());
        m_channel->sendBinaryMessage(buffer);
    }
    return data.size() == kChunkSize;
}

void UploadThread::connected() {
    qDebug() << "UploadThread::connected";
}

void UploadThread::disconnected() {
    //
    // should check upload has completed
    //
    qDebug() << "UploadThread::disconnected";
}

void UploadThread::textMessageReceived(const QString& message) {
    qDebug() << "UploadThread::textMessageReceived : " << message;
    QVariantMap command = parseCommand( message );
    if ( command.contains("command" ) ) {
        if ( command["command"] == "welcome" ) {
            m_mutex.lock();
            m_ready.wakeAll();
            m_mutex.unlock();
        }
    } else {
        if ( command.contains("status") ) {
            if ( command["status"] == "DONE" ) {
                m_channel->close();
                m_mutex.lock();
                m_ready.wakeAll();
                m_mutex.unlock();
            } else if ( command["status"] == "READY" ){
                m_mutex.lock();
                m_ready.wakeAll();
                m_mutex.unlock();
            }
        }
    }
}

void UploadThread::binaryMessageReceived(const QByteArray& message) {

}

void UploadThread::socketError(QAbstractSocket::SocketError error) {
    QString errorText( "UploadThread::socketError : ");
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

QVariantMap UploadThread::parseCommand( const QString& message ) {
    QByteArray json;
    json.append(message);
    QJsonDocument document = QJsonDocument::fromJson(json);
    if ( !document.isEmpty() && document.isObject() ) {
        return document.object().toVariantMap();
    }
    return QVariantMap();
}
