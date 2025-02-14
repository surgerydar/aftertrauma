#include "flowerchart.h"

#include <QRadialGradient>
#include <QColor>
#include <QBrush>
#include <QFont>
#include <QFontMetrics>
#include <QMutexLocker>
#include <qmath.h>

//
// TODO: move to global utility
//
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
    return categoryColours[ ( index % categoryColours.size() ) ];
}

const QVector<QString> labels = {
    "Emotions", "Confidence", "Body", "Life", "Relationships"
};

FlowerChart::FlowerChart( QQuickItem* parent ) : QQuickPaintedItem( parent ), m_painter( this ) {
    m_currentDate   = 0;
    m_values        = { 0., 0., 0., 0., 0. };
    m_maxValues  = { .25, .5, .75, 1., 1. };
    m_valuesAnimationStart  = { 0., 0., 0., 0., 0. };
    m_valuesAnimationEnd    = { 0., 0., 0., 0., 0. };
    m_fontSize = 24;
    m_animated = true;
    //
    //
    //
    setAcceptedMouseButtons(Qt::AllButtons);
    setRenderTarget(QQuickPaintedItem::FramebufferObject);
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
    QRect bounds( 0, 0, width(), height() );
    m_painter.paint(painter, bounds, m_values, m_maxValues, labels, m_fontSize, isEnabled());
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
    if( values.size() < 5 ) return;
    if ( m_animated ) {
        for ( int i = 0; i < 5; i++ ) {
            m_valuesAnimationStart[ i ] = m_values[ i ];
            m_valuesAnimationEnd[ i ] = values[ i ].toReal();
        }
        m_animationU = 0.;
        startTimer(33, Qt::PreciseTimer);
    } else {
        m_animationU = 1.;
        for ( int i = 0; i < 5; i++ ) {
            m_valuesAnimationStart[ i ] = m_valuesAnimationEnd[ i ] = m_values[ i ] = values[ i ].toReal();
        }
        update();
    }
}
QVariantList FlowerChart::maxValues() const {
    QVariantList maxValues;
    for ( auto& value : m_maxValues ) {
        maxValues.push_back( QVariant::fromValue(value) );
    }
    return maxValues;
}
void FlowerChart::setMaxValues( const QVariantList maxValues ) {
    m_maxValues.clear();
    for ( auto& value : maxValues ) {
        m_maxValues.push_back( value.toReal() );
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

void FlowerChart::mouseMoveEvent(QMouseEvent *event) {

}

void FlowerChart::mousePressEvent(QMouseEvent *event) {

}

void FlowerChart::mouseReleaseEvent(QMouseEvent *event) {
    selectCategoryAt(event->x(),event->y());
}
//
//
//
void FlowerChart::selectCategoryAt( qreal x, qreal y ) {
    QPointF mp( x, y );
    qDebug() << "FlowerChart::mouseReleaseEvent " << mp;
    //
    //
    //
    qreal sweep = (2*M_PI) / 5.;
    qreal angle  = 0.;
    qreal radius = qMin( width(), height()) / 2.;
    QPointF cp( width()/2., height()/2.);
    //
    //
    //
    QPointF mpd = mp - cp;
    qreal md = sqrt( mpd.x() * mpd.x() + mpd.y() * mpd.y() );
    if (  md > radius ) {
        qDebug() << "FlowerChart::mouseReleaseEvent md=" << md << " radius=" << radius;
        return;
    }
    //
    // draw labels
    //
    angle = sweep / 2;
    radius *= .6;
    qreal minDistance = std::numeric_limits<qreal>::max();
    int minIndex = -1;
    for ( int i = 0; i < 5; ++i ) {
        QPointF p(
                    cp.x()+(qCos(angle)*radius-qSin(angle)),
                    cp.y()+(qSin(angle)*radius-qCos(angle))
                    );
        //
        //
        //
        QPointF d = p - mp;
        qreal distance = d.manhattanLength();
        if ( distance < minDistance ) {
            minDistance = distance;
            minIndex = i;
        }
        //
        //
        //
        angle += sweep;
    }
    if ( minIndex >= 0 ) {
        emit categorySelected( labels[ minIndex ].toLower(), minIndex );
    }
}



