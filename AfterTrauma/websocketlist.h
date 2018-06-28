#ifndef WEBSOCKETLIST_H
#define WEBSOCKETLIST_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QWebSocket>
#include <QStringList>

class WebSocketList : public QAbstractListModel
{
    Q_OBJECT
    //
    //
    //
    Q_PROPERTY(QString url MEMBER m_url )
    Q_PROPERTY(QStringList roles MEMBER m_roles )
    Q_PROPERTY(QVariant command READ command WRITE setCommand)
public:
    explicit WebSocketList(QObject *parent = 0);
    //
    // QAbstractListModel overrides
    //
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    //
    //
    //
    QVariant command() { return QVariant(m_command); }
    void setCommand( const QVariant command );
signals:
    void error(QString error);
    void opened();
    void closed();

public slots:
    void open();
    void close();
    QVariant get(int i);
    void refresh();
    void clear();

private slots:
    void connected();
    void disconnected();
    void textMessageReceived(const QString& message);
    void socketError(QAbstractSocket::SocketError error);

private:
    void populateList( const QVariantList& data );
    QStringList             m_roles;
    QWebSocket              m_webSocket;
    QString                 m_url;
    QVariantMap             m_command;
    QList< QVariantMap >    m_objects;
};

#endif // WEBSOCKETLIST_H
