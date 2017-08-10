QT += qml quick multimedia

CONFIG += c++11

SOURCES += main.cpp \
    imagepicker.cpp \
    systemutils.cpp \
    installer.cpp \
    jsonfile.cpp \
    database.cpp

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
    factsheets/emotions.introduction.json \
    factsheets/body.introduction.json \
    factsheets/body.json \
    factsheets/categories.json \
    factsheets/emotions.cominghomefromhospital.json \
    factsheets/emotions.depression.json \
    factsheets/emotions.helpfulorganisations.json \
    factsheets/emotions.howtohelpalovedone.json \
    factsheets/emotions.json \
    factsheets/emotions.managingdifficultfeelings.json \
    factsheets/emotions.stressaftertrauma.json \
    factsheets/emotions.treatmentapproaches.json \
    factsheets/emotions.whendoiaskforhelp.json \
    factsheets/forcarers.introduction.json \
    factsheets/forcarers.json \
    factsheets/life.introduction.json \
    factsheets/life.json \
    factsheets/mind.introduction.json \
    factsheets/mind.json \
    factsheets/relationships.introduction.json \
    factsheets/relationships.json \
    factsheets/services.introduction.json \
    factsheets/services.json \
    factsheets/traumasurvivorandcarerstories.introduction.json \
    factsheets/traumasurvivorandcarerstories.json

ios {
    OBJECTIVE_SOURCES += ios/ImagePicker.mm
    QMAKE_INFO_PLIST = ios/Info.plist

    factsheet.files = ./factsheets
    factsheet.path =
    QMAKE_BUNDLE_DATA += factsheet

    launch_images.files = $$files($$PWD/ios/launchimages/LaunchImage*.png)
    QMAKE_BUNDLE_DATA += launch_images
}

osx {
    SOURCES += osx/ImagePicker.cpp
}

HEADERS += \
    imagepicker.h \
    systemutils.h \
    installer.h \
    jsonfile.h \
    database.h
