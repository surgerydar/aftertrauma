#ifndef FLOWERCHART_H
#define FLOWERCHART_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QMutex>

class FlowerChart : public QQuickPaintedItem {
    Q_OBJECT
    //Q_PROPERTY(int currentDate READ currentDate WRITE setCurrentDate)
    Q_PROPERTY(QVariantList values READ values WRITE setValues)
    //Q_PROPERTY(QVariantList targetValues READ targetValues WRITE setTargetValues)
    //Q_PROPERTY(QVariantList startValues READ startValues WRITE setStartValues)
    Q_PROPERTY(int fontSize MEMBER m_fontSize)
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
    QVariantList targetValues() const;
    void setTargetValues( const QVariantList targetValues );
    QVariantList startValues() const;
    void setStartValues( const QVariantList startValues );

protected:
    void timerEvent(QTimerEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

private:
    void drawBackground(QPainter*painter);
    void drawPetal(QPainter* painter, QPointF& cp, int index, qreal angle, qreal sweep, QColor& colour);
    void generatePetalPath( QPainterPath& path, QPointF& cp, qreal radius, qreal angle, qreal sweep, bool isMinMax );
    //
    //
    //
    int m_currentDate;
    QList< qreal > m_values;
    QList< qreal > m_maxValues;
    QList< qreal > m_minValues;
    //
    // value animation
    //
    qreal           m_animationU;
    QList< qreal >  m_valuesAnimationStart;
    QList< qreal >  m_valuesAnimationEnd;
    //
    //
    //
    int m_fontSize;
    //
    //
    //
    QMutex m_valueGuard;
};

#endif // FLOWERCHART_H
