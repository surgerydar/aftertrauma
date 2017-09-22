#ifndef CACHEDIMAGEPROVIDER_H
#define CACHEDIMAGEPROVIDER_H

#include <QQuickImageProvider>

class CachedImageProvider : public QQuickImageProvider
{
public:
    CachedImageProvider();
    //
    //
    //
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

};

#endif // CACHEDIMAGEPROVIDER_H
