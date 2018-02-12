#include "sharedialog.h"

#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
extern void _shareFile( QString text, QString filePath );
#endif

ShareDialog* ShareDialog::s_shared = nullptr;

ShareDialog::ShareDialog(QObject *parent) : QObject(parent) {

}

ShareDialog* ShareDialog::shared() {
    if ( !s_shared ) {
        s_shared = new ShareDialog;
    }
    return s_shared;
}

void ShareDialog::shareFile( QString text, QString filePath ) {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    _shareFile( text, filePath );
#endif
}

