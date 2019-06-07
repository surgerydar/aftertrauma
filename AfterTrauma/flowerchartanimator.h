#ifndef FLOWERCHARTANIMATOR_H
#define FLOWERCHARTANIMATOR_H

#include <QQuickItem>
#include <QVector>

class FlowerChartAnimator : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)
    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
public:
    explicit FlowerChartAnimator(QQuickItem* parent=nullptr);
    //
    //
    //
    int count() const { return m_values.size(); }
    void setCount( const int count ) { m_values.resize(count); emit countChanged(count); }

    int interval() const { return m_interval; }
    void setInterval( const int interval );

    bool running() const { return m_timer != 0; }
signals:
    void newValues();
    void countChanged( int count );
    void intervalChanged( int frequency );
    void runningChanged( bool running );
public slots:
    void start();
    void stop();
    double value(int index);

protected:
    void timerEvent(QTimerEvent *event) override;

private:
    int             m_interval;
    QVector<double> m_values;
    int             m_timer;
};

#endif // FLOWERCHARTANIMATOR_H
