#ifndef ANDROIDBACKKEYFILTER_H
#define ANDROIDBACKKEYFILTER_H

#include <QObject>
//
// TODO: refactor to something like EventFilter
//
class AndroidBackKeyFilter : public QObject
{
    Q_OBJECT
public:
    explicit AndroidBackKeyFilter(QObject *parent = 0);
    static AndroidBackKeyFilter* shared();
protected:
    bool eventFilter(QObject *obj, QEvent *event);
private:
    static AndroidBackKeyFilter* s_shared;

signals:
    void backKeyPressed();
    void applicationActivated();
    void applicationDeactivated();
    void applicationSuspended();

public slots:
};

#endif // ANDROIDBACKKEYFILTER_H
