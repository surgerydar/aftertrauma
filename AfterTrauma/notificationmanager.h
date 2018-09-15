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
    void display( int id, QString message ) { emit notificationReceived(id, message); }
signals:
    void notificationReceived( int id, QString message );

public slots:
    void scheduleNotification( int id, QString message, unsigned int delay, unsigned int frequency );
    void cancelNotification( int id );
    void cancelAllNotifications();
    void processActivationNotification();
private:
    static NotificationManager* s_shared;
};

#endif // NOTIFICATIONMANAGER_H
