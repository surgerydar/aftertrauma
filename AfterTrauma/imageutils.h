#ifndef IMAGEUTILS_H
#define IMAGEUTILS_H

#include <QObject>

class ImageUtils : public QObject
{
    Q_OBJECT
public:
    explicit ImageUtils(QObject *parent = 0);

    static ImageUtils* shared();
private:
    static ImageUtils* s_shared;

signals:

public slots:
    QString urlEncode(  QString path, int width, int height );
};

#endif // IMAGEUTILS_H
