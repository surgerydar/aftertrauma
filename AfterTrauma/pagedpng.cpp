#include "pagedpng.h"
#include <QDebug>
#include "systemutils.h"

class QRasterPaintEngine;
//
//
//
PagedPNG::PagedPNG(QObject *parent) : QObject(parent), QPagedPaintDevice( /*new PagedPngPaintDevicePrivate(this)*/ ) {
    qDebug() << "PagedPNG::PagedPNG";
    m_resolution = 150;
    setPageSize(A4);
    setPageOrientation(QPageLayout::Portrait);
}

bool PagedPNG::newPage() {
    qDebug() << "PagedPNG::newPage()";
    m_pages.push_back(QImage(m_image.width(),m_image.height(),QImage::Format_ARGB32));
    //m_pages[ m_pages.size() - 1].swap(m_image);
    //
    //
    //
    QPainter painter;
    painter.begin(&m_pages[ m_pages.size() - 1]);
    painter.drawImage(0,0,m_image);
    painter.end();
    //
    //
    //
    m_image.fill(Qt::white);
    //
    //
    //
    QString filepath = SystemUtils::shared()->documentDirectory() + QString( "/page%1.png" ).arg(m_pages.size());
    m_pages[ m_pages.size() - 1].save(filepath);

    return true;
}

QPaintEngine *PagedPNG::paintEngine() const {
    qDebug() << "PagedPNG::paintEngine()";
    QRect rect = pageLayout().fullRectPixels(m_resolution);
    QRect paintRect = pageLayout().paintRectPixels(m_resolution);
    qDebug() << "PagedPNG::paintEngine : paintRect=" << paintRect;
    if ( m_image.width() != rect.width() || m_image.height() != rect.height() ) {
        //m_image = QImage(rect.width(),rect.height(),QImage::Format_RGBA8888);
        m_image = QImage(rect.width(),rect.height(),QImage::Format_ARGB32);
        m_image.fill(Qt::white);
    }
/*
#ifdef Q_OS_IOS
    //QPaintDevice* paintDevice = const_cast<QPaintDevice*>(&m_image);
    QPaintEngine* engine = new QRasterPaintEngine(&m_image));
#else
    //new QRasterPaintEngine(paintDevice);
    QPaintEngine* engine = m_image.paintEngine();
#endif
*/
    QPaintEngine* engine = m_image.paintEngine();
    /*
    if ( !engine->paintDevice() ) {
        engine->setPaintDevice(&m_image);
    }
    */
    if ( !engine->paintDevice() ) {
        qDebug() << "PagedPNG::paintEngine : engine type=" << engine->type() << " : no paint device";
        return nullptr;
    }

    qDebug() << "PagedPNG::paintEngine : engine type=" << engine->type() << " : devType=" << engine->paintDevice()->devType();
    return engine;
}

 QImage* PagedPNG::imageptr() {
     QRect rect = pageLayout().fullRectPixels(m_resolution);
     if ( m_image.width() != rect.width() || m_image.height() != rect.height() ) {
         //m_image = QImage(rect.width(),rect.height(),QImage::Format_RGBA8888);
         m_image = QImage(rect.width(),rect.height(),QImage::Format_ARGB32);
         m_image.setDotsPerMeterX(m_resolution*40);
         m_image.setDotsPerMeterY(m_resolution*40);
         m_image.fill(Qt::white);
     }
     return &m_image;
 }

QTransform PagedPNG::printTransform() {
    QRect fullRect = pageLayout().fullRectPixels(m_resolution);
    QRect paintRect = pageLayout().paintRectPixels(m_resolution);

    QTransform transform;
    transform.translate(paintRect.x(), paintRect.y());
    qreal scale = qMin((qreal)paintRect.width()/(qreal)fullRect.width(), (qreal)paintRect.height()/(qreal)fullRect.height());
    transform.scale(scale,scale);

    return transform;
}

QRect PagedPNG::paintRect() {
    return pageLayout().paintRectPixels(m_resolution);
}

int PagedPNG::metric(PaintDeviceMetric metric) const {
    qDebug() << "PagedPNG::metric : metric : " << metric;
    switch( metric ) {
    case PdmWidth :
        return pageLayout().paintRectPixels(m_resolution).width();
    case PdmHeight :
        return pageLayout().paintRectPixels(m_resolution).height();
    case PdmWidthMM :
        return qRound(pageLayout().paintRect(QPageLayout::Millimeter).width());
    case PdmHeightMM :
        return qRound(pageLayout().paintRect(QPageLayout::Millimeter).height());
    case PdmNumColors :
        return m_image.colorCount();
    case PdmDepth :
        return m_image.depth();
    case PdmDpiX :
    case PdmDpiY :
        return m_resolution;
    case PdmPhysicalDpiX :
        return m_image.physicalDpiX();
    case PdmPhysicalDpiY :
        return m_image.physicalDpiY();
    case PdmDevicePixelRatio :
        return m_image.devicePixelRatio();
    case PdmDevicePixelRatioScaled :
        return m_image.devicePixelRatio();

    }
    return 0;
}

void PagedPNG::write(QIODevice* device) {
    //
    // commit current page
    //
    newPage();
    //
    //
    //
    QSize documentSize(m_pages[0].width(),m_pages[0].height()*m_pages.size());
    qDebug() << "PagedPNG::write : size=" << documentSize << " : pages=" << m_pages.size();
    QImage document( documentSize, QImage::Format_ARGB32 );
    QPainter painter;
    painter.begin(&document);
    int y = 0;
    for ( QImage& page : m_pages ) {
        qDebug() << "PagedPNG::write : page at=" << y;
        painter.drawImage(0,y,page);
        y += page.height();
    }
    painter.end();
    document.save(device,"PNG");
    //document.save(device,"JPG");
}
