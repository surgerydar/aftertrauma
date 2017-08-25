#ifndef DATABASESYNC_H
#define DATABASESYNC_H

#include <QThread>
#include "databaselist.h"

class DatabaseSync : public QThread
{
    Q_OBJECT
public:
    void run() override;
    void sync( QString& url, DatabaseList& database );
private:
    QString         m_url;
    DatabaseList&   m_database;
    bool            m_done;
signals:
    void syncStart();
    void syncProgress(double complete,double total);
    void syncDone();
    void syncError(QString reason);
public slots:

};

#endif // DATABASESYNC_H
