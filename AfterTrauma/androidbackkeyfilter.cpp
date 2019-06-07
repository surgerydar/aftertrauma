#include <QKeyEvent>
#include <QDebug>

#include "androidbackkeyfilter.h"
#include "notificationmanager.h"

AndroidBackKeyFilter* AndroidBackKeyFilter::s_shared = nullptr;

AndroidBackKeyFilter::AndroidBackKeyFilter(QObject *parent) : QObject(parent) {

}

AndroidBackKeyFilter* AndroidBackKeyFilter::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new AndroidBackKeyFilter;
    }
    return s_shared;
}

bool AndroidBackKeyFilter::eventFilter(QObject *obj, QEvent *event) {
    //
    // TODO: tidy this up, replace with switch etc
    //
    if (event->type() == QEvent::KeyRelease) {
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
        if ( keyEvent->key() == Qt::Key_Back ) {
            emit backKeyPressed();
            return true;
        }
    /*} else if ( event->type() == QEvent::Expose ) {
        QExposeEvent* exposeEvent = static_cast<QExposeEvent *>(event);
        qDebug() << "AndroidBackKeyFilter::eventFilter : ExposeEvent : " << exposeEvent->region();
        */
    } else if ( event->type() == QEvent::ApplicationStateChange ) {
        QApplicationStateChangeEvent* stateChangedEvent = static_cast<QApplicationStateChangeEvent *>(event);
        qDebug() << "AndroidBackKeyFilter::eventFilter : ApplicationStateChange : " << stateChangedEvent->applicationState();
        switch( stateChangedEvent->applicationState() ) {
        case Qt::ApplicationActive :
            NotificationManager::shared()->processActivationNotification();
            emit applicationActivated();
            break;
        case Qt::ApplicationInactive :
            emit applicationDeactivated();
            break;
        case Qt::ApplicationSuspended :
            emit applicationSuspended();
            break;
        case Qt::ApplicationHidden :
            emit applicationHidden();
            break;
        }

    /*} else {
        qDebug() << "AndroidBackKeyFilter::eventFilter : " << event->type();*/
    }
    return QObject::eventFilter(obj, event);
}

