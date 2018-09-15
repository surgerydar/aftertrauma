#include "notificationmanager.h"
#include <QDebug>

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
extern void _requestNotificationPermision();
extern void _scheduleNotification( int id, QString message, unsigned int delay, unsigned int frequency );
extern void _cancelNotification( int id );
extern void _cancelAllNotifications();
#if defined(Q_OS_ANDROID)
extern int _getActivationNotificationId();
#endif
#endif

NotificationManager* NotificationManager::s_shared = nullptr;

NotificationManager::NotificationManager(QObject *parent) : QObject(parent) {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _requestNotificationPermision();
#endif
}

NotificationManager* NotificationManager::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new NotificationManager;
    }
    return s_shared;
}

void NotificationManager::scheduleNotification( int id, QString message, unsigned int delay, unsigned int frequency ) {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _scheduleNotification( id, message, delay, frequency );
#endif
}

void NotificationManager::cancelNotification( int id ) {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _cancelNotification(id);
#endif
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
