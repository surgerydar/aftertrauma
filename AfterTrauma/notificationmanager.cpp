#include "notificationmanager.h"

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
extern void _requestNotificationPermision();
extern void _scheduleNotification( QString message, int date, bool repeat );
#endif

NotificationManager* NotificationManager::s_shared = nullptr;

NotificationManager::NotificationManager(QObject *parent) : QObject(parent) {
    _requestNotificationPermision();
}

NotificationManager* NotificationManager::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new NotificationManager;
    }
    return s_shared;
}

void NotificationManager::schedule( QString message, int date, bool repeat ) {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _scheduleNotification( message, date, repeat );
#endif
}
