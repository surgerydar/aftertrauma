QT += qml quick multimedia websockets gui

CONFIG += c++11

SOURCES += main.cpp \
    imagepicker.cpp \
    systemutils.cpp \
    installer.cpp \
    jsonfile.cpp \
    database.cpp \
    databaselist.cpp \
    websocketvalidator.cpp \
    websocketchannel.cpp \
    guidgenerator.cpp \
    imageutils.cpp \
    databasesync.cpp \
    cachedimageprovider.cpp \
    androidbackkeyfilter.cpp \
    flowerchart.cpp \
    daily.cpp \
    cachedmediasource.cpp \
    cachedtee.cpp \
    networkaccess.cpp \
    sharedialog.cpp \
    pdfgenerator.cpp \
    linechartdata.cpp \
    websocketlist.cpp \
    notificationmanager.cpp \
    archive.cpp

HEADERS += \
    imagepicker.h \
    systemutils.h \
    installer.h \
    jsonfile.h \
    database.h \
    databaselist.h \
    websocketvalidator.h \
    websocketchannel.h \
    guidgenerator.h \
    imageutils.h \
    databasesync.h \
    cachedimageprovider.h \
    androidbackkeyfilter.h \
    flowerchart.h \
    daily.h \
    cachedmediasource.h \
    cachedtee.h \
    networkaccess.h \
    sharedialog.h \
    pdfgenerator.h \
    linechartdata.h \
    paintable.h \
    websocketlist.h \
    notificationmanager.h \
    archive.h \
    archiver.h \
    unarchiver.h


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/src/uk/co/soda/NotificationScheduler.java \
    android/src/uk/co/soda/FileShareDialog.java \
    android/src/uk/co/soda/NotificationPublisher.java

ios {
    OBJECTIVE_SOURCES += ios/ImagePicker.mm
    OBJECTIVE_SOURCES += ios/ShareDialog.mm
    OBJECTIVE_SOURCES += ios/NotificationScheduler.mm

    QMAKE_INFO_PLIST = ios/Info.plist

    LIBS += -framework UserNotifications

    # factsheet.files = ./factsheets
    # factsheet.path =
    # QMAKE_BUNDLE_DATA += factsheet

    # factsheetmedia.files = ./media
    # factsheetmedia.path =
    # QMAKE_BUNDLE_DATA += factsheetmedia

    # launch_images.files = $$files($$PWD/ios/launchimages/LaunchImage*.png)
    # QMAKE_BUNDLE_DATA += launch_images

    ios_icon.files = $$files($$PWD/ios/icons/AppIcon*.png)
    QMAKE_BUNDLE_DATA += ios_icon

    ios_launch.files = $$PWD/ios/Launch.storyboard $$PWD/ios/LaunchBackground.png $$PWD/ios/LaunchLogo.png
    QMAKE_BUNDLE_DATA += ios_launch

}

osx {
    QMAKE_MAC_SDK.macosx.version = 10.13
    INCLUDEPATH += /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include
    # QMAKE_MAC_SDK = macosx10.13
    # factsheet.files = ./factsheets
    # factsheet.path = Contents/MacOS/
    # QMAKE_BUNDLE_DATA += factsheet

    # factsheetmedia.files = ./media
    # factsheetmedia.path = Contents/MacOS/
    # QMAKE_BUNDLE_DATA += factsheetmedia
}

android {
    QT += androidextras

    SOURCES += ./android/androidimagepicker.cpp
    SOURCES += ./android/androidsharedialog.cpp
    SOURCES += ./android/androidnotificationscheduler.cpp

    ANDROID_EXTRA_LIBS += $$PWD/android/OpenSSL/armeabi-v7a/libcrypto.so
    ANDROID_EXTRA_LIBS += $$PWD/android/OpenSSL/armeabi-v7a/libssl.so
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    # factsheet.files = ./factsheets
    # factsheet.path = /assets
    # INSTALLS += factsheet

    # factsheetmedia.files = ./media
    # factsheetmedia.path = /assets
    # INSTALLS += factsheetmedia

    OTHER_FILES += ./android/AndroidManifest.xml
}

