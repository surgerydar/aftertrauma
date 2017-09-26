#include <QKeyEvent>

#include "androidbackkeyfilter.h"

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
    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
        if ( keyEvent->key() == Qt::Key_Back ) {
            emit backKeyPressed();
            return true;
        }
    }
    return QObject::eventFilter(obj, event);
}

