#ifndef SHAREDIALOG_H
#define SHAREDIALOG_H

#include <QObject>

class ShareDialog : public QObject
{
    Q_OBJECT
public:
    explicit ShareDialog(QObject *parent = 0);
    static ShareDialog* shared();
signals:

public slots:
    void shareFile( QString text, QString filePath );

private:
    static ShareDialog* s_shared;
};

#endif // SHAREDIALOG_H
