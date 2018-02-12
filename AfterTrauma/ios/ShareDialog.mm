#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include <QPointer>
#include <QtCore>
#include <QImage>
#include <QDebug>
#include <QStandardPaths>
#include <QFile>
#include "../sharedialog.h"
//
//
//
void showShareDialog( NSString* text, NSString* filePath );

void _shareFile( QString text, QString path) {
    showShareDialog( text.toNSString(), path.toNSString() );
}

//static UIImagePickerController* imagePickerController = 0;

void showShareDialog( NSString* text, NSString* filePath ) {
    //
    // get root view controller
    //
    UIViewController* controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    //
    //
    //
    NSArray* items = [NSArray arrayWithObjects:text,[NSURL fileURLWithPath:filePath],nil];
    //
    //
    //
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems: items applicationActivities:nil];
    //
    //
    //
    activityViewController.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {

    };
    //
    // show dialog
    //
    [controller presentViewController:activityViewController animated:true completion:NULL];
    return true;
}


