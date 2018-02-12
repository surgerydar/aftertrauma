#include "linechartdata.h"
#include <QUuid>
#include "pdfgenerator.h"

LineChartData::LineChartData(QObject *parent) : QObject(parent) {

}

QString LineChartData::addDataSet( QString label, QColor colour, QVariant data ) {
    QString id = QUuid::createUuid().toString();
    //
    //
    //
    m_dataset[ id ].m_label     = label;
    m_dataset[ id ].m_colour    = colour;
    m_dataset[ id ].m_label     = label;
    m_dataset[ id ].m_data.clear();
    QVariantList dataList = data.value<QVariantList>();
    for ( auto& dataPoint : dataList ) {
        m_dataset[ id ].m_data.push_back(dataPoint.value<QPointF>());
    }
    return id;
}

void LineChartData::removeDataSet( QString id ) {
    if ( m_dataset.contains(id) ) {
        m_dataset.erase(m_dataset.find(id));
    }
}

void LineChartData::clearDataSets() {
    m_dataset.clear();
}

void LineChartData::setDatasetData( QString id, QVariant data ) {
    m_dataset[ id ].m_data.clear();
    QVariantList dataList = data.value<QVariantList>();
    for ( auto& dataPoint : dataList ) {
        m_dataset[ id ].m_data.push_back(dataPoint.value<QPointF>());
    }
}

void LineChartData::setDatasetColour( QString id, QColor colour ) {
    m_dataset[ id ].m_colour = colour;
}

void LineChartData::setDatasetActive( QString id, bool activate ) {
    m_dataset[ id ].m_active = activate;
}
//
//
//
QString LineChartData::addAxis( QString label, AxisOrientation orientation, AxisAlignment alignment ) {
    QString id = QUuid::createUuid().toString();
    //
    //
    //
    m_axis[ id ].m_label        = label;
    m_axis[ id ].m_orientation  = orientation;
    m_axis[ id ].m_alignment    = alignment;
    //
    //
    //
    return id;
}

void LineChartData::removeAxis( QString id ) {
    if ( m_axis.contains(id) ) {
        m_axis.erase(m_axis.find(id));
    }
}

void LineChartData::clearAxis() {
    m_axis.clear();
}

void LineChartData::setAxisAlignment( QString id, AxisAlignment alignment ) {
    m_axis[ id ].m_alignment = alignment;
}

void LineChartData::setAxisRange( QString id, QVariant min, QVariant max ) {
    m_axis[ id ].m_min = min;
    m_axis[ id ].m_max = max;
}

void LineChartData::setAxisSteps( QString id, int steps ) {
    m_axis[ id ].m_steps = steps;
}

void LineChartData::setAxisLabel( QString id, QString label ) {
    m_axis[ id ].m_label = label;
}
//
//
//
void LineChartData::paint( QPainter* painter, const QRect& r ) {
    painter->save();
    //
    //
    //
    QFontMetrics fontMetrics = painter->fontMetrics();
    int dpiX = painter->device()->logicalDpiX();
    int dpiY = painter->device()->logicalDpiY();
    //
    //
    //
    QRect adjusted( r.x(), r.y(), r.width() - 4, r.height() - 4);
    QRect safe = safeRect(adjusted,dpiX);
    qDebug() << "bounds: " << r << " safe: " << safe;
    //
    // background
    //
    QBrush white( Qt::white );
    painter->fillRect(r,white);
    //
    // axis
    //
    if ( m_axis.size() > 0 ) {
        QList< QString > axisKeys = m_axis.keys();
        for ( auto& axisKey : axisKeys ) {
            drawAxis(painter,m_axis[axisKey],safe);
        }
    }
    //
    // data
    //
    if ( m_dataset.size() > 0 ) {
        QList< QString > dataKeys = m_dataset.keys();
        for ( auto& dataKey : dataKeys ) {
            drawData(painter,m_dataset[dataKey],safe);
        }
    }
    //
    // title
    //
    drawTitle(painter,safe);
    //
    // legend
    //
    if ( m_showLegend ) {
        drawLegend(painter,safe);
    }
    //
    //
    //
    painter->restore();
}
//
//
//
void LineChartData::save( QString filePath ) {
    QString documentId = PDFGenerator::shared()->openDocument();
    if ( documentId.length() > 0 ) {
        PDFGenerator::shared()->paint(documentId,this);
        PDFGenerator::shared()->closeDocument(documentId);
        SystemUtils::shared()->moveFile(PDFGenerator::shared()->documentPath(documentId),filePath,true);
        PDFGenerator::shared()->removeDocument(documentId);
    }
}
//
//
//
QRect LineChartData::safeRect( const QRect& r, int axisMargin ) {
    QRect safe = r;
    QList< QString > keys = m_axis.keys();
    for ( auto& key : keys ) {
        switch ( m_axis[ key ].m_orientation ) {
        case XAxis :
            switch ( m_axis[ key ].m_alignment ) {
            case AlignStart :
                safe.setLeft( r.left() + axisMargin );
                break;
            case AlignEnd :
                safe.setRight( r.right() - axisMargin );
                break;
            default:
                break;
            }
            break;
        case YAxis :
            switch ( m_axis[ key ].m_alignment ) {
            case AlignStart :
                safe.setTop( r.top() + axisMargin );
                break;
            case AlignEnd :
                safe.setBottom( r.bottom() - axisMargin );
                break;
            default:
                break;
            }
            break;
        }
    }
    return safe;
}
//
//
//
void LineChartData::drawAxis( QPainter* painter, const AxisData& axis, const QRect& r ) {
    //
    //
    //
    if ( axis.m_steps > 0 ) {
        drawGridLines(painter,axis.m_orientation,axis.m_steps,r);
    }
    //
    // TODO: ticks and labels
    //
    painter->save();
    QPen darkGray( Qt::darkGray );
    painter->setPen(darkGray);
    painter->setBrush(Qt::NoBrush);
    QPoint p0, p1;
    switch ( axis.m_orientation ) {
    case XAxis :
        switch ( axis.m_alignment ) {
        case AlignStart :
            qDebug() << "axis : x : start";
            painter->drawLine(r.topLeft(),r.topRight());
            break;
        case AlignMiddle :
            qDebug() << "axis : x : middle";
            p0.setX(r.left()); p0.setY(r.center().y());
            p1.setX(r.right()); p1.setY(r.center().y());
            painter->drawLine(p0,p1);
            break;
        case AlignEnd :
            qDebug() << "axis : x : end";
            painter->drawLine(r.bottomLeft(),r.bottomRight());
            break;
        }
        break;
    case YAxis :
        switch ( axis.m_alignment ) {
        case AlignStart :
            qDebug() << "axis : y : start";
            painter->drawLine(r.topLeft(),r.bottomLeft());
            break;
        case AlignMiddle :
            qDebug() << "axis : y : middle";
            p0.setX(r.center().x()); p0.setY(r.top());
            p1.setX(r.center().x()); p1.setY(r.bottom());
            painter->drawLine(p0,p1);
            break;
        case AlignEnd :
            qDebug() << "axis : y : end";
            painter->drawLine(r.topRight(),r.bottomRight());
            break;
        }
        break;
    }
    painter->restore();
}

void LineChartData::drawData( QPainter* painter, const DataSet& data, const QRect& r ) {
    if ( data.m_data.size() > 0 ) {
        //
        //
        //
        painter->save();
        //
        //
        //
        QPen pen( data.m_colour );
        QPainterPath path;
        path.moveTo(
                    r.x()+data.m_data[ 0 ].x()*(double)r.width(),
                    r.y()+((double)r.height()-data.m_data[ 0 ].y()*(double)r.height())
                );
        for ( int i = 1; i < data.m_data.size(); ++i ) {
            path.lineTo(
                        r.x()+data.m_data[ i ].x()*(double)r.width(),
                        r.y()+((double)r.height()-data.m_data[ i ].y()*(double)r.height())
                    );
        }
        painter->strokePath(path,pen);
        //
        //
        //
        painter->restore();
    }
}

void LineChartData::drawGridLines( QPainter* painter, const AxisOrientation& orientation, const int steps, const QRect& r ) {
    //
    //
    //
    painter->save();
    //
    //
    //
    QPen grey( Qt::lightGray );
    QPainterPath path;
    //
    //
    //
    double spacing;
    QPoint p0;
    QPoint p1;
    switch( orientation ) {
    case XAxis :
        spacing = r.width() / steps;
        p0.setX(r.left()); p0.setY(r.top());
        p1.setX(r.left()); p1.setY(r.bottom());
        for ( int i = 0; i < steps; i++ ) {
            path.moveTo(p0);
            path.lineTo(p1);
            p0.setX(p0.x()+spacing);
            p1.setX(p1.x()+spacing);
        }
        break;
    case YAxis :
        spacing = r.height() / steps;
        p0.setX(r.left()); p0.setY(r.top());
        p1.setX(r.right()); p1.setY(r.top());
        for ( int i = 0; i < steps; i++ ) {
            path.moveTo(p0);
            path.lineTo(p1);
            p0.setY(p0.y()+spacing);
            p1.setY(p1.y()+spacing);
        }
        break;
    }
    painter->strokePath(path,grey);
    //
    //
    //
    painter->restore();
}

void LineChartData::drawTitle( QPainter* painter, const QRect& r ) {
    painter->save();
    QPen darkGray( Qt::darkGray );
    painter->setPen(darkGray);
    int offset = 0;
    if ( m_title.length() > 0 ) {
        QFont titleFont = m_font;
        titleFont.setPointSize(24);
        painter->setFont(titleFont);
        offset += painter->fontMetrics().height();
        painter->drawText( r.x(), r.y() + offset, m_title );
    }
    if ( m_subtitle.length() > 0 ) {
        QFont titleFont = m_font;
        titleFont.setPointSize(18);
        painter->setFont(titleFont);
        offset += painter->fontMetrics().height();
        painter->drawText( r.x(), r.y()+ offset, m_subtitle );
    }
    painter->restore();
}

void LineChartData::drawLegend( QPainter* painter, const QRect& r ) {

}
