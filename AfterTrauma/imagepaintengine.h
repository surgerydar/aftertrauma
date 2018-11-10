#ifndef IMAGEPAINTENGINE_H
#define IMAGEPAINTENGINE_H

#include <QPaintEngine>

class ImagePaintEngine : public QPaintEngine
{
   //Q_OBJECT
public:
    explicit ImagePaintEngine(PaintEngineFeatures features=PaintEngineFeatures());
    //
    //
    void setRect( const QRect& rect );
    QImage& image() { return m_image; }
    const QImage& constimage() const { return m_image; }
    QRect& rect() { return m_rect; }
    //
    //
    //
    virtual bool begin(QPaintDevice *pdev) override;
    virtual bool end() override { if ( m_engine ) return m_engine->end(); return false; }

    virtual void updateState(const QPaintEngineState &state) override { if ( m_engine ) m_engine->updateState(state); }

    virtual void drawRects(const QRect *rects, int rectCount) override { if ( m_engine ) m_engine->drawRects(rects,rectCount); }
    virtual void drawRects(const QRectF *rects, int rectCount) override { if ( m_engine ) m_engine->drawRects(rects,rectCount); }

    virtual void drawLines(const QLine *lines, int lineCount) override { if ( m_engine ) m_engine->drawLines(lines,lineCount); }
    virtual void drawLines(const QLineF *lines, int lineCount) override { if ( m_engine ) m_engine->drawLines(lines,lineCount); }

    virtual void drawEllipse(const QRectF &r) override { if ( m_engine ) m_engine->drawEllipse(r); }
    virtual void drawEllipse(const QRect &r) override { if ( m_engine ) m_engine->drawEllipse(r); }

    virtual void drawPath(const QPainterPath &path) override { if ( m_engine ) m_engine->drawPath(path); }

    virtual void drawPoints(const QPointF *points, int pointCount) override { if ( m_engine ) m_engine->drawPoints(points,pointCount); }
    virtual void drawPoints(const QPoint *points, int pointCount) override { if ( m_engine ) m_engine->drawPoints(points,pointCount); }

    virtual void drawPolygon(const QPointF *points, int pointCount, PolygonDrawMode mode) override { if ( m_engine ) m_engine->drawPolygon(points,pointCount,mode); }
    virtual void drawPolygon(const QPoint *points, int pointCount, PolygonDrawMode mode) override { if ( m_engine ) m_engine->drawPolygon(points,pointCount,mode); }

    virtual void drawPixmap(const QRectF &r, const QPixmap &pm, const QRectF &sr) override { if ( m_engine ) m_engine->drawPixmap(r,pm,sr); }
    virtual void drawTextItem(const QPointF &p, const QTextItem &textItem) override { if ( m_engine ) m_engine->drawTextItem(p,textItem); }
    virtual void drawTiledPixmap(const QRectF &r, const QPixmap &pixmap, const QPointF &s) override { if ( m_engine ) m_engine->drawTiledPixmap(r,pixmap,s); }
    virtual void drawImage(const QRectF &r, const QImage &pm, const QRectF &sr,
                           Qt::ImageConversionFlags flags = Qt::AutoColor) override { if ( m_engine ) m_engine->drawImage(r,pm,sr,flags); }

    //
    //
    //
    virtual Type type() const override { if ( m_engine ) return m_engine->type(); return Raster; }
signals:

public slots:

private:
    QImage          m_image;
    QRect           m_rect;
    QPaintEngine*   m_engine;
};

#endif // IMAGEPAINTENGINE_H
