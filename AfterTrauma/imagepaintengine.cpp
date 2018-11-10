#include "imagepaintengine.h"
#include <QDebug>

ImagePaintEngine::ImagePaintEngine(PaintEngineFeatures features) : QPaintEngine(features) {
    m_engine = nullptr;
}
//
//
//
void ImagePaintEngine::setRect( const QRect& rect ) {
    m_rect = rect;
}
//
//
//
bool ImagePaintEngine::begin(QPaintDevice *pdev) {
    //
    //
    //
    if ( m_image.width() != m_rect.width() || m_image.height() != m_rect.height() ) {
        qDebug() << "ImagePaintEngine::begin : resizing image to : " << m_rect;
        m_image = QImage( m_rect.width(), m_rect.height(),QImage::Format_RGBA8888);
    }
    //
    //
    //
    m_engine = m_image.paintEngine();
    if ( m_engine ) {
        return m_engine->begin(pdev);
    }
    return false;
}
