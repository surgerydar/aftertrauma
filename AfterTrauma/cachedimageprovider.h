#ifndef CACHEDIMAGEPROVIDER_H
#define CACHEDIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QThreadPool>

class CachedImageProvider : public QQuickAsyncImageProvider
{
public:
    CachedImageProvider();
    //
    //
    //
    QQuickImageResponse *requestImageResponse(const QString &id, const QSize &requestedSize);
private:
    QThreadPool m_pool;
};

#endif // CACHEDIMAGEPROVIDER_H
