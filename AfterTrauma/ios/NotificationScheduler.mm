#include <QCoreApplication>
#include <QPointer>
#include <QtCore>
#include <QImage>
#include <QDebug>
#include <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
//
//
//
#include "notificationmanager.h"
//
//
//
static bool _notificationsEnabled = false;
//
//
//
@interface NotificationDelegate : NSObject<UNUserNotificationCenterDelegate> {
}

@end

@implementation NotificationDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    qDebug("present notification");
    //
    // TODO: this is called when the app is in the foreground so should present notification in app, possibly add to scrolling list of pending notifications
    // Possibly just rely on system alert system
    // NotificationManager::shared()->display("hello");
    if ( completionHandler ) {
        completionHandler(UNNotificationPresentationOptionAlert);
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    qDebug("receive notification");
    //
    //
    //
    QString stringId = QString::fromNSString([[[response notification] request] identifier]);
    int id = stringId.toInt(nullptr,16);
    QString message = QString::fromNSString([[[[response notification] request] content] body]);

    qDebug() << "NotificationScheduler : received response : " << stringId << " : " << id << " : " << message;
    NotificationManager::shared()->display(id,message);
    if ( completionHandler ) {
        completionHandler();
    }
}

@end
//
//
//
void _requestNotificationPermision() {
    //
    // TODO: check for active permissions
    //
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:
             (UNAuthorizationOptionAlert +
              UNAuthorizationOptionSound +
              UNAuthorizationOptionBadge)
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
          _notificationsEnabled = granted;
          qDebug("notifications enabled");
          if ( granted ) {
              NSLog(@"notifications enabled");
              //
              // attach delegate
              //
              //[center setDelegate:[[NotificationDelegate alloc]init]];
          }
    }];
    //
    // attach delegate
    //
    [center setDelegate:[[NotificationDelegate alloc]init]];
}

void _scheduleNotification( int id, QString message, unsigned int delay, unsigned int frequency ) {
    qDebug("_scheduleNotification : 1");
    /*
    if ( !_notificationsEnabled ) {
        qDebug("notifications not enabled")
        return;
    }
    */
    if ( @available(iOS 10, * ) ) {
        qDebug( "notification id=%d, message=%s", id, message.toStdString().c_str());
        qDebug("_scheduleNotification : 2.1");
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"AfterTrauma" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:message.toNSString()
                    arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        //content.badge = [NSNumber numberWithInt: 1];
        qDebug("_scheduleNotification : 2.2");
        UNTimeIntervalNotificationTrigger* trigger = ( delay > 0 || frequency > 0 ) ? [UNTimeIntervalNotificationTrigger
                    triggerWithTimeInterval:(frequency > 0 ? frequency : delay) / 1000 repeats:frequency > 0] : nil;
        qDebug("_scheduleNotification : 2.3");
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"0x%X",id]
                    content:content trigger:trigger];
        // Schedule the notification.
        qDebug("_scheduleNotification : 2.4");
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
            qDebug( "notification scheduled");
            if ( error ) {
                NSLog( @"_scheduleNotification : error scheduling notification : %@", [error localizedDescription] );
            }
        }];
    } else {
        qDebug("_scheduleNotification : 3.1");
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = nil;//[NSDate dateWithTim];
        localNotification.alertBody = message.toNSString();
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = nil;//[NSTimeZone dateWithTimeIntervalSinceNow:5];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        qDebug("_scheduleNotification : 3.2");
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

void _scheduleNotificationByPattern( int id, QString message, int pattern ) {
    qDebug("_scheduleNotificationByPattern : 1");

}

void _cancelNotification( int id ) {
    qDebug( "_cancelNotification" );
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    NSString* _id = [NSString stringWithFormat:@"0x%X",id];
    [center removePendingNotificationRequestsWithIdentifiers:[NSArray arrayWithObjects: _id, nil] ];
    int badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    if ( badgeNumber > 0 ) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badgeNumber - 1];
    }
}

void _cancelAllNotifications() {
    qDebug( "_cancelAllNotifications" );
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
}


