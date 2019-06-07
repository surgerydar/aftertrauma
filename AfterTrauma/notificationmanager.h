#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QObject>
#include "databaselist.h"

class NotificationManager : public QObject
{
    Q_OBJECT
public:
    //
    // TODO: expose these to QML
    //
    enum NotificationPattern {
        HOURLY,
        FOUR_TIMES_DAILY,
        MORNING_AND_EVENING,
        DAILY,
        WEEKLY
    };
    Q_ENUM(NotificationPattern)
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
    void scheduleNotificationByPattern( int type, int subject, QString message, NotificationPattern pattern );
    void cancelNotification( int id );
    void cancelNotificationByPattern( int type, int subject );
    void cancelAllNotifications();
    void processActivationNotification();
    //
    //
    //
    int typeFromId( const int id ) { return ( id >> 28 ) & 0xF; }
    int subjectFromId( const int id ) { return ( id >> 8 ) & 0xFFFFF; }
    int hourFromId( const int id ) { return id & 0xFF; }
private:
    static NotificationManager* s_shared;
    static DatabaseList*        s_database;
    //
    //
    //
    unsigned int delayToNextHourInDay( int hour );
    int compositeId( int type, int subject, int hour );
    //
    //
    //
    void scheduleHourly( int type, int subject, QString message );
    void scheduleFourTimesDaily( int type, int subject, QString message );
    void scheduleMorningAndEvening( int type, int subject, QString message );
    void scheduleDaily( int type, int subject, QString message );
    void scheduleWeekly( int type, int subject, QString message );
    //
    //
    //
    void cancelHourly( int type, int subject );
    void cancelFourTimesDaily( int type, int subject );
    void cancelMorningAndEvening( int type, int subject );
    void cancelDaily( int type, int subject );
    void cancelWeekly( int type, int subject );
};

#endif // NOTIFICATIONMANAGER_H
