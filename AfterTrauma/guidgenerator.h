#ifndef GUIDGENERATOR_H
#define GUIDGENERATOR_H

#include <QObject>

class GuidGenerator : public QObject
{
    Q_OBJECT
public:
    explicit GuidGenerator(QObject *parent = 0);
    static GuidGenerator* shared();
private:
    static GuidGenerator* s_shared;
signals:

public slots:
    QString generate();
};

#endif // GUIDGENERATOR_H
