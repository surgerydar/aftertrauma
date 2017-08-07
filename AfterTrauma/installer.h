#ifndef INSTALLER_H
#define INSTALLER_H

#include <QThread>
//
//
//
class Installer : public QThread {
    Q_OBJECT
    void run() override;
signals:
    void complete();
    void error( QString& error );
};


#endif // INSTALLER_H
