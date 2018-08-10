#include <QDate>
#include <QDebug>
#include "diarywriter.h"
#include "pdfgenerator.h"
#include "colours.h"
#include "flowerchartpainter.h"
#include "systemutils.h"

DiaryWriter::DiaryWriter(QObject *parent) : QObject(parent) {
    m_padding = .25;
    m_spacing = .5;
}
//
//
//
void DiaryWriter::paint( QPainter* /*painter*/, const QRect& /*r*/ ) {
    qDebug() << "DiaryWriter::paint( QPainter* painter, const QRect& r ) : unimplimented";
}

void DiaryWriter::write( QPdfWriter* writer ) {
    //
    //
    //
    m_adjustedPadding = _inchesToPixels( m_padding, writer );
    m_adjustedSpacing = _inchesToPixels( m_spacing, writer );
    //
    //
    //
    m_painter.begin( writer );
    _paintPageBackground();
    //
    //
    //
    QRect r = m_painter.viewport();
    QPoint cp( r.x(), r.y() );
    for ( auto& entry : m_entries ) {
        QVariantMap entryMap = entry.toMap();
        _paintEntry( entryMap, writer, r, cp );
        //cp.setY( cp.y() + m_adjustedSpacing );
    }
    m_painter.end();
}

void DiaryWriter::save( const QVariantList& entries, const QString& filePath ) {
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

void DiaryWriter::_paintEntry( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp ) {
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

void DiaryWriter::_paintEntryHeader( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp ) {
    //
    // check for space
    //
    int headerHeight = _inchesToPixels(3.5,writer);
    QRect bounds( cp.x(), cp.y(), r.width() / 2, headerHeight );
    _requestSpace( bounds, writer, r, cp);
    qDebug() << "DiaryWriter::_paintEntryHeader : bounds : " << bounds;
    //
    // paint background
    //
    QRect headerRect = _padRectangle(bounds);
    m_painter.fillRect( headerRect, Colours::shared()->colour("slate") );
    //
    // paint date
    //
    m_painter.setPen(Colours::shared()->colour("almostWhite"));
    QDate date( entry["year"].toInt(),entry["month"].toInt(),entry["day"].toInt());
    QString titleText = date.toString("d, MMM, yyyy");
    QFont titleFont = m_font;
    titleFont.setPointSize(24);
    m_painter.setFont(titleFont);
    m_painter.drawText( headerRect, titleText, Qt::AlignHCenter | Qt::AlignTop );
    //
    // paint flower chart
    //
    if ( entry.contains("values") ) {
        //
        // convert values
        //
        QVector< qreal > values;
        QVector<QString> labels;
        //qDebug() << "values: " << entry["values"];
        QVariantList valuesList = entry["values"].toList();
        for ( QVariant& value : valuesList ) {
            QVariantMap valueMap = value.toMap();
            values.push_back( valueMap["value"].toDouble() );
            labels.push_back( valueMap["label"].toString() );
            //qDebug() << "value: " << valueMap["value"].toDouble();
        }
        //qDebug() << "values: " << values << " size:" << values.size();
        //qDebug() << "labels: " << labels;

        //
        //
        //
        QImage flowerImage(headerRect.width(),headerRect.height(),QImage::Format_ARGB32);
        QPainter flowerImagePainter(&flowerImage);
        //
        // paint chart into offscreen image
        //
        QRect flowerBounds(m_adjustedPadding/2,m_adjustedPadding/2, headerRect.width()-m_adjustedPadding, headerRect.height()-m_adjustedPadding);
        FlowerChartPainter flowerChartPainter;
        flowerChartPainter.paint(&flowerImagePainter, flowerBounds, values, labels, 12 * ( ( 1./ 72.) * writer->resolution() ), true);
        flowerImagePainter.end();
        //
        //
        //
        m_painter.drawImage(headerRect.x(),headerRect.y(),flowerImage);
    }
    //
    // advance cp
    //
    cp.setY( cp.y() + bounds.height() );
}

void DiaryWriter::_paintEntryBlocks( const QVariant& blocks, QPdfWriter* writer, const QRect& r, QPoint& cp ) {
    //
    // iterate over blocks
    //
    QSequentialIterable iterable = blocks.value<QSequentialIterable>();
    foreach (const QVariant &block, iterable) {
        QVariantMap blockMap = block.toMap();
        _paintEntryBlock( blockMap, writer, r, cp );
    }
}

void DiaryWriter::_paintEntryBlock( const QVariantMap& block, QPdfWriter* writer, const QRect& r, QPoint& cp ) {
    QString type = block["type"].toString();
    QString content = block["content"].toString();
    QRect bounds( cp.x(), cp.y(), r.width() / 2, 0 );
    if ( type == "image" ) {
        //
        // load image
        //
        QString imagePath = SystemUtils::shared()->documentDirectory().append("/").append(content);
        QImage image;
        if ( image.load(imagePath) ) {
            //
            // get dimensions
            //
            qreal scale = ( qreal ) ( bounds.width() - m_adjustedPadding * 2 ) / ( qreal ) image.width();
            bounds.setHeight((image.height() * scale)+m_adjustedPadding * 2.);
            _requestSpace(bounds,writer,r,cp);
            //
            // move imageRect back into position
            //
            QRect imageRect = _padRectangle(bounds);
            //
            //
            //
            m_painter.drawImage(imageRect, image);
        } else {
            qDebug() << "DiaryWriter::_paintEntryBlock : unable to load image : " << block["content"].toString();
        }
    } else if ( type == "text" ) {
        QFont blockFont = m_font;
        blockFont.setPointSize(12);
        m_painter.setFont(blockFont);
        m_painter.setPen(Colours::shared()->colour("veryDarkSlate"));
        //
        // adjust bounds height to fit text
        //
        int textHeight = m_painter.boundingRect(0,0,bounds.width()-m_adjustedPadding*3,r.height(), Qt::AlignLeft | Qt::AlignTop | Qt::TextWordWrap,content).height();
        bounds.setHeight( textHeight + m_adjustedPadding * 3 );
        //
        //
        //
        _requestSpace(bounds,writer,r,cp);
        //
        //
        //
        QRect textBox = _padRectangle(bounds);
        QRect textBounds = textBox.adjusted(m_adjustedPadding/2,m_adjustedPadding/2,-m_adjustedPadding/2,-m_adjustedPadding/2);
        qDebug() << "DiaryWriter::_paintEntryBlock : bounds: " << bounds << " : textBox: " << textBox << " : textBounds: " << textBounds << " : textHeight:" << textHeight;
        //
        //
        //
        m_painter.fillRect( textBox, Colours::shared()->colour("almostWhite"));
        m_painter.drawText( textBounds, Qt::AlignLeft | Qt::AlignTop | Qt::TextWordWrap, content );
    } else {
        qDebug() << "DiaryWriter::_paintEntryBlock : unknown block type : " << type;
    }
    cp.setY( cp.y() + bounds.height() );
}

void DiaryWriter::_requestSpace( QRect& requested, QPdfWriter* writer, const QRect& r, QPoint& cp) {
    if ( cp.y() + requested.height() > r.bottom() ) {
        //
        // adjust cp
        //
        if ( cp.x() > r.x() ) {
            //
            // request new page and reset cp
            //
            if (writer->newPage()) {
                _paintPageBackground();
            } else {
                qDebug() << "DiaryWriter::_requestSpace : unable to create new page";
            }
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

void DiaryWriter::_paintPageBackground() {
    QRect bounds = m_painter.viewport();
    QRect left = bounds.adjusted(0,0, -( bounds.width()/2+ 4 ),0);
    QRect right = bounds.adjusted(bounds.width()/2+4,0,0,0);
    //
    //
    //
    m_painter.fillRect(left,Colours::shared()->colour("veryLightSlate"));
    m_painter.fillRect(right,Colours::shared()->colour("veryLightSlate"));
}

