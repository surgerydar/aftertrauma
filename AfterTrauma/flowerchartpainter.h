#ifndef FLOWERCHARTPAINTER_H
#define FLOWERCHARTPAINTER_H

#include <QObject>
#include <QPainter>
#include <QRect>
#include <QList>
#include <QPointF>

class FlowerChartPainter : public QObject
{
    Q_OBJECT
public:
    explicit FlowerChartPainter(QObject *parent = 0);
    //
    //
    //
    void paint(QPainter*painter, const QRect& bounds, const QVector<qreal>& values, const QVector<qreal>& maxValues, const QVector<QString>& labels, int fontSize, bool drawLabels);

signals:

public slots:

private:
    void drawBackground( QPainter* painter, QPointF& cp, qreal radius );
    void drawPetal( QPainter* painter, qreal value, qreal maxValue, QPointF& cp, qreal radius, qreal angle, qreal sweep, QColor& colour, QPainterPath& maxPath );
    void generatePetalPath( QPainterPath& path, QPointF& cp, qreal radius, qreal angle, qreal sweep, bool close );
};

#endif // FLOWERCHARTPAINTER_H
