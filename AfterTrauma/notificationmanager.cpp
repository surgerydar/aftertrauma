#include "notificationmanager.h"
#include <QTime>
#include <QDebug>

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
extern void _requestNotificationPermision();
extern void _scheduleNotification( int id, QString message, unsigned int delay, unsigned int frequency );
extern void _scheduleNotificationByPattern( int id, QString message, int pattern );
extern void _cancelNotification( int id );
extern void _cancelAllNotifications();
#if defined(Q_OS_ANDROID)
extern int _getActivationNotificationId();
#endif
#endif


NotificationManager* NotificationManager::s_shared = nullptr;
DatabaseList* NotificationManager::s_database = nullptr;

NotificationManager::NotificationManager(QObject *parent) : QObject(parent) {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _requestNotificationPermision();
#endif
}

NotificationManager* NotificationManager::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new NotificationManager;
        //
        // load database
        //
        s_database = new DatabaseList;
        s_database->setCollection("pending-notifications");
    }
    return s_shared;
}

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
void NotificationManager::scheduleNotification( int id, QString message, unsigned int delay, unsigned int frequency ) {
    _scheduleNotification( id, message, delay, frequency );
}
#else
void NotificationManager::scheduleNotification( int /*id*/, QString /*message*/, unsigned int /*delay*/, unsigned int /*frequency*/ ) {
}
#endif

void NotificationManager::scheduleNotificationByPattern( int type, int subject, QString message, NotificationPattern pattern ) {
    //
    // cancel existing
    //
    cancelNotificationByPattern( type, subject );
    //
    // schedule notification
    //
    switch( pattern ) {
    case HOURLY :
        scheduleHourly(type,subject,message);
        break;
    case FOUR_TIMES_DAILY :
        scheduleFourTimesDaily(type,subject,message);
        break;
    case MORNING_AND_EVENING :
        scheduleMorningAndEvening(type,subject,message);
        break;
    case DAILY :
        scheduleDaily(type,subject,message);
        break;
    case WEEKLY :
        scheduleWeekly(type,subject,message);
        break;
    default:
        scheduleNotification(compositeId( type, subject, 0),message,0,0);
        return; // don't persist oneshot
    }
    //
    // update database
    //
    QVariantMap query;
    query["type"]       = QVariant(type);
    query["subject"]    = QVariant(subject);
    QVariantMap entry;
    entry["type"]       = QVariant(type);
    entry["subject"]    = QVariant(subject);
    entry["pattern"]    = QVariant((int)pattern);
    s_database->update(query,entry,true);
    s_database->save();
}

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
void NotificationManager::cancelNotification( int id ) {
    _cancelNotification(id);
}
#else
void NotificationManager::cancelNotification( int /*id*/ ) {
}
#endif

void NotificationManager::cancelNotificationByPattern( int type, int subject ) {
    //
    //
    //
    QVariantMap query;
    query["type"]       = QVariant(type);
    query["subject"]    = QVariant(subject);
    QVariantMap notification = s_database->findOne(QVariant(query)).value<QVariantMap>();
    if ( !notification.isEmpty() ) {
        int pattern = notification["pattern"].toInt();
        switch( pattern ) {
        case HOURLY :
            cancelHourly(type,subject);
            break;
        case FOUR_TIMES_DAILY :
            cancelFourTimesDaily(type,subject);
            break;
        case MORNING_AND_EVENING :
            cancelMorningAndEvening(type,subject);
            break;
        case DAILY :
            cancelDaily(type,subject);
            break;
        case WEEKLY :
            cancelWeekly(type,subject);
            break;
        }
        //
        // update database
        //
        s_database->remove(query);
        s_database->save();
    } else {
        // oneshot not persisted but can still be cancelled
        cancelNotification(compositeId(type,subject,0));
    }
}

void NotificationManager::cancelAllNotifications() {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _cancelAllNotifications();
#endif
}

void NotificationManager::processActivationNotification() {
#if defined(Q_OS_ANDROID)
    qDebug() << "NotificationManager::processActivationNotification";
    int notificationId = _getActivationNotificationId();
    if ( notificationId > 0 ) {
        qDebug() << "NotificationManager::processActivationNotification : notificationId : " << notificationId;
        QString message = "activation notification received";
        emit notificationReceived(notificationId, message );
    }
#endif
}

const int kBaseHour = 8;
const unsigned int kSecondDelay = 1000;
const unsigned int kMinuteDelay = kSecondDelay * 60;
const unsigned int kHourDelay = kMinuteDelay * 60;
const unsigned int kDayDelay = kHourDelay * 24;
const unsigned int kWeekDelay = kDayDelay * 7;

unsigned int NotificationManager::delayToNextHourInDay( int hour ) {
    int currentHour = QTime::currentTime().hour();
    if ( hour <= currentHour ) {
        return ( 24 - ( currentHour - hour ) ) * kHourDelay;
    }
    return ( hour - currentHour ) * kHourDelay;
}

int NotificationManager::compositeId( int type, int subject, int hour ) {
    return ( ( ( type << 28 ) & 0xF0000000 ) | ( ( subject << 8 ) & 0x0FFFFF00 ) | ( hour & 0xFF ) );
}

void NotificationManager::scheduleHourly( int type, int subject, QString message ) {
    qDebug() << "NotificationManager::scheduleHourly : type=" << type << " subject=" << subject << " message=" << message;
    for ( int i = 0; i < 12; i++ ) {
        unsigned int delay = delayToNextHourInDay(kBaseHour+i);
        int notificationId = compositeId( type, subject, i );
        scheduleNotification(notificationId,message,delay,kDayDelay);
        qDebug() << "NotificationManager::scheduleHourly : encoded type=" << typeFromId(notificationId) << " encodedsubject=" << subjectFromId(notificationId);
    }
}

void NotificationManager::scheduleFourTimesDaily( int type, int subject, QString message ) {
    for ( int i = 0; i < 12; i += 3) {
        unsigned int delay = delayToNextHourInDay(kBaseHour+i);
        int notificationId = compositeId( type, subject, i );
        scheduleNotification(notificationId,message,delay,kDayDelay);
    }
}

void NotificationManager::scheduleMorningAndEvening( int type, int subject, QString message ) {
    for ( int i = 0; i < 12; i += 12) {
        unsigned int delay = delayToNextHourInDay(kBaseHour+i);
        int notificationId = compositeId( type, subject, i );
        scheduleNotification(notificationId,message,delay,kDayDelay);
    }
}

void NotificationManager::scheduleDaily( int type, int subject, QString message ) {
    unsigned int delay = delayToNextHourInDay(kBaseHour);
    int notificationId = compositeId( type, subject, 0);
    scheduleNotification(notificationId,message,delay,kDayDelay);
}

void NotificationManager::scheduleWeekly( int type, int subject, QString message ) {
    unsigned int delay = delayToNextHourInDay(kBaseHour) + kWeekDelay; // one week ahead
    int notificationId = compositeId( type, subject, 0);
    scheduleNotification(notificationId,message,delay,kWeekDelay);
}

void NotificationManager::cancelHourly( int type, int subject ) {
    for ( int i = 0; i < 12; i++ ) {
        int notificationId = compositeId( type, subject, i );
        cancelNotification(notificationId);
    }
}

void NotificationManager::cancelFourTimesDaily( int type, int subject ) {
    for ( int i = 0; i < 12; i += 3 ) {
        int notificationId = compositeId( type, subject, i );
        cancelNotification(notificationId);
    }
}

void NotificationManager::cancelMorningAndEvening( int type, int subject ) {
    for ( int i = 0; i < 12; i += 12 ) {
        int notificationId = compositeId( type, subject, i );
        cancelNotification(notificationId);
    }
}

void NotificationManager::cancelDaily( int type, int subject ) {
    int notificationId = compositeId( type, subject, 0);
    cancelNotification(notificationId);
}

void NotificationManager::cancelWeekly( int type, int subject ) {
    int notificationId = compositeId( type, subject, 0);
    cancelNotification(notificationId);
}
