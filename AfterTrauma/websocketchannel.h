#ifndef WEBSOCKETCHANNEL_H
#define WEBSOCKETCHANNEL_H

#include <QObject>
#include <QWebSocket>

class WebSocketChannel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString url MEMBER m_url )
    Q_PROPERTY(bool autoreconnect MEMBER m_autoreconnect )

public:
    explicit WebSocketChannel(QObject *parent = 0);

signals:
    void received(QString message);

public slots:
    void open();
    void close();
    //
    // param : { command: 'name', guid: 'guid', param: .... }
    // returns : GUID
    //
    QString send(QVariant command);

private slots:
    void connected();
    void disconnected();
    void textMessageReceived(const QString& message);

private:
    QString     m_url;
    bool        m_autoreconnect;
    QWebSocket  m_webSocket;
};

#endif // WEBSOCKETCHANNEL_H
