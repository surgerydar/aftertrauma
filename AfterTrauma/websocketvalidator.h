#ifndef WEBSOCKETVALIDATOR_H
#define WEBSOCKETVALIDATOR_H

#include <QObject>
#include <QValidator>
#include <QWebSocket>

class WebSocketValidator : public QValidator
{
    Q_OBJECT
    //
    //
    //
    Q_PROPERTY(QString endpoint MEMBER m_endpoint)
    Q_PROPERTY(QString field MEMBER m_field)
    //
    //
    //
public:
    explicit WebSocketValidator(QObject *parent = 0);
    WebSocketValidator* shared();
    //
    // QValidator implimentation
    //
    virtual void fixup(QString &input) const override;
    virtual QValidator::State validate(QString &input, int &pos) const override;
private:
    static WebSocketValidator* s_shared;
signals:

public slots:

private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(QString message);
private:
    QString     m_endpoint;
    QString     m_field;
    QWebSocket  m_websocket;
    QString     m_pending;
};

#endif // WEBSOCKETVALIDATOR_H
