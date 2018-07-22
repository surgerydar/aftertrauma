#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include <QPointer>
#include <QtCore>
#include <QImage>
#include <QDebug>
#import <UserNotifications/UserNotifications.h>
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
    //
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    qDebug("receive notification");
    //
    // TODO: called when user responds to
    //
}

@end
//
//
//
void _requestNotificationPermision() {
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
              [center setDelegate:[[NotificationDelegate alloc]init]];
          }
    }];
    [center setDelegate:[[NotificationDelegate alloc]init]];
}

void _scheduleNotification( QString message, int date, bool repeat ) {
    qDebug("_scheduleNotification : 1");
    /*
    if ( !_notificationsEnabled ) {
        qDebug("notifications not enabled")
        return;
    }
    */
    if ( @available(iOS 10, * ) ) {
        qDebug("_scheduleNotification : 2.1");
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"Hello!" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:message.toNSString()
                    arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        content.badge = [NSNumber numberWithInt: 1];
        // Deliver the notification in five seconds.
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                    triggerWithTimeInterval:30 repeats:repeat];
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                    content:content trigger:trigger];

        // Schedule the notification.
        qDebug("_scheduleNotification : 2.2");
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
            NSLog( @"notification scheduled");
            if ( error ) {
                NSLog( [error localizedDescription] );
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

