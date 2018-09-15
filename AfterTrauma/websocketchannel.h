#ifndef WEBSOCKETCHANNEL_H
#define WEBSOCKETCHANNEL_H

#include <QObject>
#include <QWebSocket>
#include <QAbstractSocket>

class WebSocketChannel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString url READ url WRITE setUrl)
    Q_PROPERTY(bool autoreconnect READ autoreconnect WRITE setAutoreconnect)
    /*
    Q_PROPERTY(QString url MEMBER m_url )
    Q_PROPERTY(bool autoreconnect MEMBER m_autoreconnect )
    */
public:
    explicit WebSocketChannel(QObject *parent = 0);
    //
    //
    //
    QString url() const { return m_url; }
    void setUrl( const QString& url ) { m_url = url; }
    bool autoreconnect() const { return m_autoreconnect; }
    void setAutoreconnect( const bool autoreconnect ) { m_autoreconnect = autoreconnect; }
signals:
    void received(const QString &message);
    void error(const QString &error);
    void opened();
    void closed();

public slots:
    void open();
    void close();
    void ping();
    void pong();
    bool isConnected() { return !( m_webSocket.state() == QAbstractSocket::UnconnectedState ); }
    //
    // param : { command: 'name', guid: 'guid', param: .... }
    // returns : GUID
    //
    QString send(QVariant command);
private slots:
    void connected();
    void disconnected();
    void textMessageReceived(const QString& message);
    void socketError(QAbstractSocket::SocketError error);

private:
    QString     m_url;
    bool        m_autoreconnect;
    QWebSocket  m_webSocket;
};

#endif // WEBSOCKETCHANNEL_H
