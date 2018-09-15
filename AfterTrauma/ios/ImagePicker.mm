#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include <QPointer>
#include <QtCore>
#include <QImage>
#include <QDebug>
#include <QStandardPaths>
#include <QFile>
#include "../imagepicker.h"

@interface ImagePickerDelegate : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {

    @public

    void (^ imagePickerControllerDidFinishPickingMediaWithInfo)(UIImagePickerController* picker,NSDictionary* info);
    void (^ imagePickerControllerDidCancel)(UIImagePickerController* picker);
}

@end

@implementation ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (imagePickerControllerDidFinishPickingMediaWithInfo) {
        imagePickerControllerDidFinishPickingMediaWithInfo(picker,info);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (imagePickerControllerDidCancel) {
        imagePickerControllerDidCancel(picker);
    }
}

@end
//
//
//
bool showPicker( UIImagePickerControllerSourceType source );
UIViewController* rootViewController();
QImage fromUIImage(UIImage* image);
QString fromNSUrl(NSURL* url);

void _openGallery() {
    showPicker( UIImagePickerControllerSourceTypePhotoLibrary );
}

void _openCamera() {
    showPicker( UIImagePickerControllerSourceTypeCamera );
}

//static UIImagePickerController* imagePickerController = 0;

bool showPicker( UIImagePickerControllerSourceType source ) {
    //
    // get root view controller
    //
    UIViewController* controller = rootViewController();
    //
    //
    //
    if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceType) source]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
            message:@"The operation is not supported in this device"
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [alertView show];
        return false;
    }
    //
    // initialise picker
    //
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = source;
    //
    // create delegate
    //
    static ImagePickerDelegate *delegate = 0;
    delegate = [ImagePickerDelegate alloc];
    delegate->imagePickerControllerDidFinishPickingMediaWithInfo = ^(UIImagePickerController *picker,
                                                                     NSDictionary* info) {
            //
            //
            //
            QString url = fromNSUrl(info[UIImagePickerControllerReferenceURL]);
            qDebug() << "picked image : " << url;
            UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
            if (!chosenImage) {
                chosenImage = info[UIImagePickerControllerOriginalImage];
            }
            if (!chosenImage) {
                qWarning() << "Image Picker: Failed to take image";
            } else {
                QImage chosenQImage = fromUIImage(chosenImage);
                qDebug() << "Picked image width:" << chosenQImage.width() << " height:" << chosenQImage.height();
                //data["image"] = QVariant::fromValue<QImage>(chosenQImage);


                QString pathTemplate = QStandardPaths::writableLocation(QStandardPaths::HomeLocation).append("/Documents/aftertrauma/image%1.jpg");
                int i = 0;
                QString path;
                do {
                    path = pathTemplate.arg(i++);
                    qDebug() << "attempting to save image to : " << path;
                } while( QFile::exists(path) );
                qDebug() << "saving image to : " << path;
                chosenQImage.save(path);
                qDebug() << "image saved to to : " << path;
                ImagePicker::shared()->imagePicked(path);
            }
            [picker dismissViewControllerAnimated:true completion:NULL];
            delegate = nil;
    };
    delegate->imagePickerControllerDidCancel = ^(UIImagePickerController *picker) {
            [picker dismissViewControllerAnimated:true completion:NULL];
            delegate = nil;
    };
    picker.delegate = delegate;
    //
    // show picker
    //
    [controller presentViewController:picker animated:true completion:NULL];
    return true;
}

UIViewController* rootViewController() {
    UIApplication* app = [UIApplication sharedApplication];
    return app.keyWindow.rootViewController;
}


QImage fromUIImage(UIImage* image) {
    QImage::Format format = QImage::Format_RGB32;

    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;

    int orientation = [image imageOrientation];
    int degree = 0;

    switch (orientation) {
    case UIImageOrientationLeft:
        degree = -90;
        break;
    case UIImageOrientationDown: // Down
        degree = 180;
        break;
    case UIImageOrientationRight:
        degree = 90;
        break;
    }

    if (degree == 90 || degree == -90)  {
        CGFloat tmp = width;
        width = height;
        height = tmp;
    }

    QSize size(width,height);

    QImage result = QImage(size,format);

    CGContextRef contextRef = CGBitmapContextCreate(result.bits(),                 // Pointer to  data
                                                    width,                       // Width of bitmap
                                                    height,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    result.bytesPerLine(),              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipFirst |
                                                    kCGBitmapByteOrder32Little); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
    CGContextRelease(contextRef);

    if (degree != 0) {
        QTransform myTransform;
        myTransform.rotate(degree);
        result = result.transformed(myTransform,Qt::SmoothTransformation);
    }

    return result;
}

QString fromNSUrl(NSURL* url) {
    QString result = QString::fromNSString([url absoluteString]);

    return result;
}

