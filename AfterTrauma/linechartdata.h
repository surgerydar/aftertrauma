#ifndef LINECHARTDATA_H
#define LINECHARTDATA_H

#include <QObject>
#include <QMap>
#include <QVector>
#include <QPointF>
#include <QPainter>
#include <QVariant>
#include "paintable.h"

class LineChartData : public QObject, public Paintable
{
    Q_OBJECT
    Q_PROPERTY(QFont font MEMBER m_font)
    Q_PROPERTY(QString title MEMBER m_title)
    Q_PROPERTY(QString subtitle MEMBER m_subtitle)
    Q_PROPERTY(bool showLegend MEMBER m_showLegend)
public:

    explicit LineChartData(QObject *parent = 0);
    //
    //
    //
    enum AxisOrientation {
        XAxis, YAxis
    };
    Q_ENUM(AxisOrientation)

    enum AxisAlignment {
        AlignStart, AlignMiddle, AlignEnd
    };
    Q_ENUM(AxisAlignment)

signals:

public slots:
    //
    //
    //
    QString addDataSet( QString label, QColor colour, QVariant data );
    void removeDataSet( QString id );
    void clearDataSets();
    void setDatasetData( QString id, QVariant data );
    void setDatasetColour( QString id, QColor color );
    void setDatasetActive( QString id, bool activate );
    //
    //
    //
    QString addAxis( QString label, AxisOrientation orientation, AxisAlignment alignment );
    void removeAxis( QString id );
    void clearAxis();
    void setAxisAlignment( QString id, AxisAlignment align );
    void setAxisRange( QString id, QVariant min, QVariant max );
    void setAxisSteps( QString id, int steps );
    void setAxisLabel( QString id, QString label );
    //
    // Paintable interface
    //
    void paint( QPainter* painter, const QRect& r ) override;
    void write( QPdfWriter* writer ) override;
    //
    //
    //
    void save( QString path );
private:
    //
    //
    //
    class DataSet {
    public:
        QString             m_label;
        QColor              m_colour;
        bool                m_active;
        QVector< QPointF >  m_data; // normalised datapaoints
    };
    QMap< QString, DataSet > m_dataset;
    //
    //
    //
    class AxisData {
    public:
        AxisOrientation     m_orientation;
        AxisAlignment       m_alignment;
        QString             m_label;
        int                 m_steps;
        QVariant            m_min;
        QVariant            m_max;
    };
    QMap< QString, AxisData > m_axis;
    //
    //
    //
    QFont   m_font;
    QString m_title;
    QString m_subtitle;
    bool    m_showLegend;
    //
    //
    //
    QRect safeRect( const QRect& r, int axisMargin );
    void drawAxis( QPainter* painter, const AxisData& axis, const QRect& r );
    void drawData( QPainter* painter, const DataSet& data, const QRect& r );
    void drawGridLines( QPainter* painter, const AxisOrientation& orientation, const int steps, const QRect& r );
    double drawTitle( QPainter* painter, const QRect& r );
    void drawLegend( QPainter* painter, const QRect& r );
};

#endif // LINECHARTDATA_H
