#include <QDate>
#include <QDebug>
#include "diarypainter.h"
#include "pdfgenerator.h"
#include "colours.h"
#include "flowerchartpainter.h"

DiaryPainter::DiaryPainter(QObject *parent) : QObject(parent) {

}
//
//
//
void DiaryPainter::paint( QPainter* painter, const QRect& r ) {
    qDebug() << "DiaryPainter::paint( QPainter* painter, const QRect& r ) : unimplimented";
}

void DiaryPainter::write( QPdfWriter* writer, const QRect& r ) {
    //
    //
    //
    QPoint cp( r.x(), r.y() );
    for ( auto& entry : m_entries ) {
        QVariantMap entryMap = entry.toMap();
        _paintEntry( entryMap, writer, r, cp );
    }
}

void DiaryPainter::save( const QVariantList& entries, const QString& filePath ) {
    QString documentId = PDFGenerator::shared()->openDocument();
    if ( documentId.length() > 0 ) {
        m_entries = entries;
        PDFGenerator::shared()->write(documentId,this);
        PDFGenerator::shared()->closeDocument(documentId);
        SystemUtils::shared()->moveFile(PDFGenerator::shared()->documentPath(documentId),filePath,true);
        PDFGenerator::shared()->removeDocument(documentId);
        m_entries.clear();
    }
}

void DiaryPainter::_paintEntry( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp ) {
    //
    // entry header
    //
    _paintEntryHeader(entry, writer, r, cp );
    //
    // entry blocks
    //
    if ( entry.contains("blocks") ) {
        _paintEntryBlocks( entry["blocks"], writer, r, cp );
    }
}

void DiaryPainter::_paintEntryHeader( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp ) {
    //
    // check for space
    //
    int headerHeight = 4 * writer->resolution();
    QRect bounds( cp.x(), cp.y(), r.width() / 2, headerHeight );
    _requestSpace( bounds, writer, r, cp);
    //
    //
    //
    QPainter painter( writer );
    //
    // paint background
    //
    painter.fillRect( bounds, Colours::shared()->colour("slate") );
    //
    // paint date
    //
    painter.setPen(Colours::shared()->colour("almostWhite"));
    QDate date( entry["year"].toInt(),entry["month"].toInt(),entry["day"].toInt());
    QString titleText = date.toString("d,MMM,yyyy");
    QFont titleFont = m_font;
    titleFont.setPointSize(24);
    painter.setFont(titleFont);
    qreal offset = ( qreal ) painter.fontMetrics().height() * 1.5;
    //painter.drawText( bounds.x() + 40, bounds.y() + offset, titleText );
    painter.drawText( bounds, titleText, Qt::AlignHCenter | Qt::AlignTop );
    //
    // paint flower chart
    //
    if ( entry.contains("values") ) {
        //
        // convert values
        //
        QVector< qreal > values;
        QVector<QString> labels;
        qDebug() << "values: " << entry["values"];
        QVariantList valuesList = entry["values"].toList();
        for ( QVariant& value : valuesList ) {
            QVariantMap valueMap = value.toMap();
            values.push_back( valueMap["value"].toDouble() );
            labels.push_back( valueMap["label"].toString() );
            qDebug() << "value: " << valueMap["value"].toDouble();
        }
        qDebug() << "values: " << values << " size:" << values.size();
        qDebug() << "labels: " << labels;

        //
        //
        //
        QImage flowerImage(bounds.width(),bounds.height(),QImage::Format_ARGB32);
        QPainter flowerImagePainter(&flowerImage);
        //
        // paint chart into offscreen image
        //
        QRect flowerBounds(0,0, bounds.width(), bounds.height());
        FlowerChartPainter flowerChartPainter;
        flowerChartPainter.paint(&flowerImagePainter, bounds, values, labels, 12 * ( ( 1./ 72.) * writer->resolution() ), true);
        flowerImagePainter.end();
        //
        //
        //
        painter.drawImage(0,0,flowerImage);
    }
    //
    // advance cp
    //
    cp.setY( cp.y() + headerHeight );
}

void DiaryPainter::_paintEntryBlocks( const QVariant& blocks, QPdfWriter* writer, const QRect& r, QPoint& cp ) {
    //
    // iterate over blocks
    //
    QSequentialIterable iterable = blocks.value<QSequentialIterable>();
    foreach (const QVariant &block, iterable) {
        QVariantMap blockMap = block.toMap();
        _paintEntryBlock( blockMap, writer, r, cp );
    }
}

void DiaryPainter::_paintEntryBlock( const QVariantMap& block, QPdfWriter* writer, const QRect& r, QPoint& cp ) {

}

void DiaryPainter::_requestSpace( QRect& requested, QPdfWriter* writer, const QRect& r, QPoint& cp) {
    if ( cp.y() + requested.height() > r.bottom() ) {
        //
        // adjust cp
        //
        if ( cp.x() > r.x() ) {
            //
            // request new page and reset cp
            //
            writer->newPage();
            cp.setX( r.x() );
            cp.setY( r.y() );
        } else {
            //
            // move to next column
            //
            cp.setX( r.width() / 2 );
            cp.setY( r.y() );
        }
    }
    //
    // adjust requested
    //
    requested.moveTo(cp);
}
