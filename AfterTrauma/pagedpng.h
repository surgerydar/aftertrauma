#ifndef PAGEDPNG_H
#define PAGEDPNG_H

#include <QPagedPaintDevice>
#include <QImage>
#include <QVector>
#include <QPainter>
#include <QIODevice>
#include "imagepaintengine.h"

class PagedPNG : public QObject, public QPagedPaintDevice
{
    Q_OBJECT
public:
    explicit PagedPNG(QObject *parent = 0);

    bool newPage() override;
    QPaintEngine *paintEngine() const override;

    int resolution() const { return m_resolution; };
    void setResolution( const int resolution ) { m_resolution = resolution; };
    void write(QIODevice* device);

    QImage* imageptr();
    QTransform printTransform();
    QRect paintRect();

signals:

public slots:

protected:
    int metric(PaintDeviceMetric metric) const override;

private:

    int             m_resolution;
    //mutable ImagePaintEngine    m_engine;
    mutable QImage  m_image;
    QVector<QImage> m_pages;

};

#endif // PAGEDPNG_H
