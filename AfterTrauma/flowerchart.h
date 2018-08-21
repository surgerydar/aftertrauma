#ifndef FLOWERCHART_H
#define FLOWERCHART_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QMutex>
#include "flowerchartpainter.h"

class FlowerChart : public QQuickPaintedItem {
    Q_OBJECT
    Q_PROPERTY(int currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)
    Q_PROPERTY(QVariantList values READ values WRITE setValues)
    Q_PROPERTY(QVariantList maxValues READ maxValues WRITE setMaxValues)
    Q_PROPERTY(int fontSize MEMBER m_fontSize)
    Q_PROPERTY(bool animated MEMBER m_animated)
public:
    explicit FlowerChart( QQuickItem* parent = 0 );
    //
    //
    //
    void paint(QPainter*painter) override;

    //
    //
    //
    int currentDate() const { return m_currentDate; }
    void setCurrentDate( const int currentDate );
    QVariantList values();
    void setValues( const QVariantList values );
    QVariantList maxValues() const;
    void setMaxValues( const QVariantList targetValues );

public slots:
    void selectCategoryAt( qreal x, qreal y );

signals:
    void categorySelected( QString category );
    void currentDateChanged( int currentDate );
protected:
    void timerEvent(QTimerEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

private:
    FlowerChartPainter m_painter;
    //
    //
    //
    int m_currentDate;
    QVector< qreal > m_values;
    QVector< qreal > m_maxValues;
    //
    // value animation
    //
    qreal           m_animationU;
    QVector< qreal >  m_valuesAnimationStart;
    QVector< qreal >  m_valuesAnimationEnd;
    //
    //
    //
    int m_fontSize;
    bool m_animated;
    //
    //
    //
    QMutex m_valueGuard;
};

#endif // FLOWERCHART_H
