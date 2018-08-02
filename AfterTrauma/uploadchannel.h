#ifndef UPLOADCHANNEL_H
#define UPLOADCHANNEL_H

#include <QObject>
#include <QWebSocket>
#include <QByteArray>
#include <QFile>

class UploadChannel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource)
    Q_PROPERTY(QString destination READ destination WRITE setDestination)
public:
    explicit UploadChannel(QObject *parent = 0);
    //
    //
    //
    QString source() const { return m_source; }
    void setSource( const QString& source ) { m_source = source; }
    QString destination() const { return m_destination; }
    void setDestination( const QString& destination ) { m_destination = destination; }
    //
    //
    //
signals:
    void done( const QString& source, const QString& destination );
    void error( const QString& source, const QString& destination, const QString& message );
    void progress( const QString& source, const QString& destination, int total, int current, const QString& message );

public slots:
    void start();

private slots:
    void connected();
    void disconnected();
    void textMessageReceived(const QString& message);
    void binaryMessageReceived(const QByteArray& message);
    void socketError(QAbstractSocket::SocketError error);

private:
    QString     m_source;
    QString     m_destination;
    //
    //
    //
    char        m_guid[ 16 ];
    QFile       m_file;
    QWebSocket* m_channel;
    //
    //
    //
    quint32     m_fileSize;
    quint32     m_bytesWritten;
    //
    //
    //
    int         m_chunkCount;
    int         m_chunksWritten;
    //
    //
    //
    void openChannel();
    void makeCommandHeader( QDataStream& command, const char* selector );
    void sendHeader();
    bool sendChunk();
    bool isChannelOpen() const { return m_channel->state() == QAbstractSocket::ConnectedState; }
    QVariantMap parseCommand( const QString& message );
};

#endif // UPLOADCHANNEL_H
