#include "flowerchart.h"

#include <QRadialGradient>
#include <QColor>
#include <QBrush>
#include <QPainter>
#include <QFont>
#include <QFontMetrics>
#include <QMutexLocker>
#include <qmath.h>


const QString darkGreen = "#03BD5B";
const QString lightGreen = "#9DBF1C";
const QString blue = "#2191FB";
const QString darkPurple = "#A939B9";
const QString lightPurple = "#FF48B8";
const QString red = "#BA274A";
const QString darkOrange = "#EB5E28";
const QString lightOrange = "#F6AA1C";
const QString veryDarkSlate = "#202C35";
const QString darkSlate = "#202C35";
const QString mediumDarkSlate = "#3B6064";
const QString slate = "#55828B";
const QString mediumLightSlate = "#8DA9C4";
const QString lightSlate = "#B8CADA";
const QString veryLightSlate = "#E5EBF1";
const QString almostWhite = "#F5F7FA";

const QVector<QString> categoryColours = {
    darkGreen,
    darkPurple,
    blue,
    darkOrange,
    lightPurple,
    lightGreen,
    red,
    lightOrange
};

QString categoryColour( int index ) {
    return categoryColours[ index % categoryColours.size() ];
}

const QVector<QString> labels = {
    "emotions", "mind", "body", "life", "relationships"
};

FlowerChart::FlowerChart( QQuickItem* parent ) : QQuickPaintedItem( parent ) {
    m_currentDate   = 0;
    m_values        = { 0., 0., 0., 0., 0. };
    m_targetValues  = { 0., 0., 0., 0., 0. };
    m_startValues   = { 0., 0., 0., 0., 0. };
}
//
//
//
void FlowerChart::setCurrentDate( const int currentDate ) {
    m_currentDate = currentDate;
    update();
}
//
//
//
void FlowerChart::paint(QPainter*painter) {
    //
    // clear to transparent
    //
    painter->save();
    QColor trans( 0, 0, 0, 0 );
    painter->setCompositionMode(QPainter::CompositionMode_Source);
    painter->fillRect(0.,0., width(), height(),trans);
    painter->restore();
    //
    //
    //
    drawBackground(painter);
    //
    //
    //
    qreal sweep = (2*M_PI) / 5.;
    qreal angle  = 0.;
    qreal radius = qMin( width(), height()) / 2.;
    QPointF cp( width()/2., height()/2.);
    if ( m_values.size() > 0 ) {
        QMutexLocker locker(&m_valueGuard);
        for ( int i = 0; i < 5; ++i ) {
            QColor colour = categoryColour(i);
            drawPetal(painter, cp, radius * m_values[ i ], angle, sweep, colour);
            angle += sweep;
        }
    }
    //
    //
    //
    if ( isEnabled() ) {
        //
        // draw labels
        //
        angle = sweep / 2;
        radius *= .6;
        QColor textColour(almostWhite);
        painter->setPen(textColour);
        QFont font("Roboto", 24 );
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
            QRect bounds = metrics.boundingRect(labels[ i ]);
            painter->drawText( p.x()-bounds.width()/2., p.y()+(bounds.height()/2.-metrics.descent()), labels[ i ] );
            /*
            painter->save();
            painter->setPen(Qt::red);
            painter->drawLine(0,p.y()+metrics.descent(),width(),p.y()+metrics.descent());
            painter->setPen(Qt::green);
            painter->drawLine(0,p.y(),width(),p.y());
            painter->restore();
            painter->drawLine(cp,p);
            */
            angle += sweep;
        }
    }
}

void FlowerChart::drawBackground( QPainter* painter ) {
    //
    //
    //
    painter->save();
    //
    //
    //
    QPointF cp( width() / 2., height() / 2.);
    QRadialGradient gradient(cp, 100);
    gradient.setColorAt(0.,QColor(255,255,255,128));
    gradient.setColorAt(1.,QColor(255,255,255,38));
    QBrush brush(gradient);
    painter->setPen(Qt::NoPen);
    painter->setBrush(brush);
    painter->drawEllipse(0.,0., width(), height());
    //
    //
    //
    painter->restore();
}

void FlowerChart::drawPetal( QPainter* painter, QPointF& cp, qreal radius, qreal angle, qreal sweep, QColor& colour ) {
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
    //
    //
    painter->save();
    //
    // build path
    //
    QPainterPath path;
    path.moveTo(cp);
    path.lineTo(p0);
    path.cubicTo(p1,p2,p3);
    path.cubicTo(p4,p5,p6);
    path.closeSubpath();
    //
    // fill path
    //
    QBrush fill( colour );
    painter->setBrush(fill);
    painter->setPen(Qt::NoPen);
    painter->drawPath( path );
    //
    // restore painter state
    //
    painter->restore();
}
//
//
//
QVariantList FlowerChart::values() {
    QMutexLocker locker(&m_valueGuard); // unable to lock const
    QVariantList values;
    for ( auto& value : m_values ) {
        values.push_back( QVariant::fromValue(value) );
    }
    return values;
}
void FlowerChart::setValues( const QVariantList values ) {
    QMutexLocker locker( &m_valueGuard );
    /*
    m_values.clear();
    for ( auto& value : values ) {
        m_values.push_back( value.toReal() );
    }
    update();
    */
    for ( int i = 0; i < 5; i++ ) {
        m_valuesAnimationStart[ i ] = m_values[ i ];
        m_valuesAnimationEnd[ i ] = values[ i ].toReal();
    }
    m_animationU = 0.;
    startTimer(33, Qt::PreciseTimer);
}
QVariantList FlowerChart::targetValues() const {
    QVariantList targetValues;
    for ( auto& value : m_targetValues ) {
        targetValues.push_back( QVariant::fromValue(value) );
    }
    return targetValues;
}
void FlowerChart::setTargetValues( const QVariantList targetValues ) {
    m_targetValues.clear();
    for ( auto& value : targetValues ) {
        m_targetValues.push_back( value.toReal() );
    }
    update();
}
QVariantList FlowerChart::startValues() const {
    QVariantList startValues;
    for ( auto& value : m_startValues ) {
        startValues.push_back( QVariant::fromValue(value) );
    }
    return startValues;
}
void FlowerChart::setStartValues( const QVariantList startValues ) {
    m_startValues.clear();
    for ( auto& value : startValues ) {
        m_startValues.push_back( value.toReal() );
    }
    update();
}
void FlowerChart::timerEvent(QTimerEvent *event) {
    QMutexLocker locker(&m_valueGuard);
    if ( m_animationU >= 1. ) {
        killTimer(event->timerId());
        for ( int i = 0; i < 5; i++ ) {
            m_values[ i ] = m_valuesAnimationEnd[ i ];
        }
    } else {
        for ( int i = 0; i < 5; i++ ) {
            m_values[ i ] = m_valuesAnimationStart[ i ] + ( m_valuesAnimationEnd[ i ] - m_valuesAnimationStart[ i ] ) * m_animationU;
        }
        m_animationU += .1;
    }
    update();
}


