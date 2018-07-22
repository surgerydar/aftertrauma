#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QObject>

class NotificationManager : public QObject
{
    Q_OBJECT
public:
    explicit NotificationManager(QObject *parent = nullptr);
    //
    //
    //
    static NotificationManager* shared();
signals:

public slots:
    void schedule( QString message, int date, bool repeat );
private:
    static NotificationManager* s_shared;
};

#endif // NOTIFICATIONMANAGER_H
