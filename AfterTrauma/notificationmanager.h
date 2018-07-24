#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QObject>

class NotificationManager : public QObject
{
    Q_OBJECT
public:
    explicit NotificationManager(QObject *parent = nullptr);
    //
    //
    //
    static NotificationManager* shared();
    //
    //
    //
    void display( QString message ) { emit notificationReceived(message); }
signals:
    void notificationReceived( QString message );

public slots:
    void scheduleNotification( int id, QString message, unsigned int delay, unsigned int frequency );
    void cancelNotification( int id );
    void cancelAllNotifications();
private:
    static NotificationManager* s_shared;
};

#endif // NOTIFICATIONMANAGER_H
