#ifndef CACHEDMEDIASOURCE_H
#define CACHEDMEDIASOURCE_H

#include <QQuickItem>
#include <QMediaPlayer>

class CachedMediaSource : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QVariant player READ player WRITE setPlayer)
public:
    CachedMediaSource(QQuickItem *parent = Q_NULLPTR);
    //
    //
    //
    QString url() const { return m_url; }
    void setUrl( const QString url );
    //
    //
    //
    QVariant player() const { return QVariant(); }
    void setPlayer( const QVariant player );
signals:
    void urlChanged(QString url);

public slots:
    void play();
    void pause();

private:
    void setMediaSource();
    QMediaPlayer* getPlayer();
    QString m_url;
    QVariant m_player;
};

#endif // CACHEDMEDIASOURCE_H
