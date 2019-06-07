#ifndef UPLOADTHREAD_H
#define UPLOADTHREAD_H

#include <QThread>
#include <QWebSocket>
#include <QByteArray>
#include <QFile>
#include <QWaitCondition>

class UploadThread : public QThread
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource)
    Q_PROPERTY(QString destination READ destination WRITE setDestination)
public:
    explicit UploadThread(QObject *parent = 0);
    //
    //
    //
    void run() override;
    //
    //
    //
    QString source() const { return m_source; }
    void setSource( const QString& source ) { m_source = source; }
    QString destination() const { return m_destination; }
    void setDestination( const QString& destination ) { m_destination = destination; }
signals:
    void done( const QString& source, const QString& destination );
    void error( const QString& source, const QString& destination, const QString& message );
    void progress( const QString& source, const QString& destination, int total, int current, const QString& message );

public slots:

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
    quint16     m_guid;
    QFile       m_file;
    QWebSocket* m_channel;
    //
    //
    //
    QMutex          m_mutex;
    QWaitCondition  m_ready;
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

#endif // UPLOADTHREAD_H
