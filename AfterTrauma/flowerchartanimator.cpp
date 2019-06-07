#include "flowerchartanimator.h"
#include <QDebug>

FlowerChartAnimator::FlowerChartAnimator(QQuickItem* parent) : QQuickItem(parent) {
    m_timer = 0;
    m_interval = 6000;
}

void FlowerChartAnimator::setInterval( const int interval ) {
    if ( interval != m_interval ) {
        m_interval = interval;
        if ( m_timer > 0 ) {
            stop();
            start();
        }
        emit intervalChanged(m_interval);
    }
}

void FlowerChartAnimator::start() {
    if ( m_timer == 0 ) {
        m_timer = startTimer(m_interval);
        emit runningChanged(true);
    }
}

void FlowerChartAnimator::stop() {
    if ( m_timer != 0 ) {
        killTimer(m_timer);
        m_timer = 0;
        emit runningChanged(false);
    }
}

double FlowerChartAnimator::value(int index) {
    if ( index >= 0 && index < m_values.size() ) {
        return m_values[ index ];
    }
    return 0.;
}

void FlowerChartAnimator::timerEvent(QTimerEvent* /*event*/) {
    for ( int i = 0; i < m_values.size(); ++i ) {
        m_values[ i ] = ( double ) qrand() / ( double ) RAND_MAX;
    }
    emit newValues();
}
