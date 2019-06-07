#include <QRadialGradient>
#include <QColor>
#include <QBrush>
#include <QFont>
#include <QFontMetrics>
#include <QMutexLocker>
#include <qmath.h>

#include "flowerchartpainter.h"
#include "colours.h"

FlowerChartPainter::FlowerChartPainter(QObject *parent) : QObject(parent) {

}

void FlowerChartPainter::paint(QPainter*painter, const QRect& bounds, const QVector<qreal>& values, const QVector<qreal>& maxValues, const QVector<QString>& labels, int fontSize, bool drawLabels) {
    //
    // clear to transparent
    //
    painter->save();
    QColor trans( 0, 0, 0, 0 );
    painter->setCompositionMode(QPainter::CompositionMode_Source);
    painter->fillRect(bounds,trans);
    painter->restore();
    //
    //
    //
    painter->save();
    painter->setRenderHints(QPainter::TextAntialiasing|QPainter::Antialiasing);
    //
    //
    //
    qreal radius = qMin( bounds.width(), bounds.height()) / 2.;
    QPointF cp( bounds.x() + bounds.width()/2., bounds.y() + bounds.height()/2.);
    //
    //
    //
    drawBackground(painter,cp,radius);
    //
    //
    //
    qreal sweep = (2*M_PI) / (qreal) values.size();
    qreal angle  = 0.;
    QPainterPath maxPath;
    if ( values.size() > 0 ) {
        for ( int i = 0; i < values.size(); ++i ) {
            QColor colour = Colours::shared()->categoryColour(i);
            drawPetal(painter, values[i], maxValues[ i ], cp, radius, angle, sweep, colour, maxPath);
            angle += sweep;
        }
        maxPath.closeSubpath();;
    }
    //
    //
    //
    if ( drawLabels ) {
        //
        // draw min/max paths
        //
        QPen pen(QColor(255,255,255,128));
        painter->save();
        pen.setStyle(Qt::DashLine);
        pen.setWidth(1);
        painter->setBrush(Qt::NoBrush);
        painter->setPen( pen );
        painter->drawPath( maxPath );
        painter->restore();
        //
        // draw labels
        //
        angle = sweep / 2;
        radius *= .6;
        QColor textColour(Colours::shared()->colour("almostWhite"));
        painter->setPen(textColour);
        QFont font("Roboto", fontSize );
        QFontMetrics metrics(font, painter->device());
        painter->setFont(font);
        for ( int i = 0; i < 5; ++i ) {
            QPointF p(
                        cp.x()+(qCos(angle)*radius-qSin(angle)),
                        cp.y()+(qSin(angle)*radius-qCos(angle))
                        );
            //
            // TODO: create generic text alignment function(s)
            //
            QRect textBounds = metrics.boundingRect(labels[ i ]);
            painter->drawText( p.x()-textBounds.width()/2., p.y()+(textBounds.height()/2.-metrics.descent()), labels[ i ] );
            //
            //
            //
            angle += sweep;
        }
    }
    painter->restore();
}

void FlowerChartPainter::drawBackground( QPainter* painter, QPointF& cp,  qreal radius ) {
    //
    //
    //
    painter->save();
    //
    //
    //
    QRadialGradient gradient(cp, 100);
    gradient.setColorAt(0.,QColor(255,255,255,128));
    gradient.setColorAt(1.,QColor(255,255,255,38));
    QBrush brush(gradient);
    painter->setPen(Qt::NoPen);
    painter->setBrush(brush);
    painter->drawEllipse(cp.x()-radius,cp.y()-radius, radius*2., radius*2.);
    //
    //
    //
    painter->restore();
}

void FlowerChartPainter::drawPetal( QPainter* painter, qreal value, qreal maxValue, QPointF& cp, qreal radius, qreal angle, qreal sweep, QColor& colour, QPainterPath& maxPath ) {
    //
    //
    //
    painter->save();
    //
    // build petal path
    //
    QPainterPath petalPath;
    generatePetalPath( petalPath, cp, radius*value, angle, sweep, true);
    //
    // fill petal path
    //
    QBrush fill( colour );
    painter->setBrush(fill);
    painter->setPen(Qt::NoPen);
    painter->drawPath( petalPath );
    //
    // restore painter state
    //
    painter->restore();
    //
    // append maxpath
    //
    generatePetalPath( maxPath, cp, radius*maxValue, angle, sweep, false);
}

void FlowerChartPainter::generatePetalPath( QPainterPath& path, QPointF& cp, qreal radius, qreal angle, qreal sweep, bool close ) {
    //
    // calculate petal points
    //
    QPointF p1(
                cp.x()+(qCos(angle)*radius-qSin(angle)),
                cp.y()+(qSin(angle)*radius-qCos(angle))
                );
    QPointF p3(
                cp.x()+(qCos(angle+sweep/2.)*radius-qSin(angle+sweep/2.)),
                cp.y()+(qSin(angle+sweep/2.)*radius-qCos(angle+sweep/2.))
                );
    QPointF p5(
                cp.x()+(qCos(angle+sweep)*radius-qSin(angle+sweep)),
                cp.y()+(qSin(angle+sweep)*radius-qCos(angle+sweep))
                );
    QPointF p0(
                (cp.x() + p1.x())/2.,
                (cp.y() + p1.y())/2.
                );
    QPointF p6(
                (cp.x()+p5.x())/2.,
                (cp.y()+p5.y())/2.
                );
    QPointF chord(
                p5.x()-p1.x(),
                p5.y()-p1.y()
                );
    qreal chordLength = qSqrt(chord.x()*chord.x()+chord.y()*chord.y());
    QPointF chordNorm(
                chord.x()/chordLength,
                chord.y()/chordLength
                );
    QPointF p2(
                p3.x()-(chord.x()/4.),
                p3.y()-(chord.y()/4.)
                );
    QPointF p4(
                p3.x()+(chord.x()/4.),
                p3.y()+(chord.y()/4.)
                );
    //
    // build path
    //
    if ( close ) {
        path.moveTo(cp);
        path.lineTo(p0);
    } else {
        if ( path.elementCount() == 0 ) {
            path.moveTo(p0);
        } else {
            path.lineTo(p0);
        }
    }
    path.cubicTo(p1,p2,p3);
    path.cubicTo(p4,p5,p6);
    if ( close ) {
        path.closeSubpath();
    }
}

