#include <QDate>
#include <QDebug>
#include <QTextDocument>
#include <QAbstractTextDocumentLayout>
#include "diarywriter.h"
#include "pdfgenerator.h"
#include "colours.h"
#include "flowerchartpainter.h"
#include "systemutils.h"

DiaryWriter::DiaryWriter(QObject *parent) : QObject(parent) {
    m_padding = .25;
    m_spacing = .5;
    m_challengeIcon.load(":/icons/challenge.png");
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
    m_pageNumber = 1;
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
        qDebug() << "DiaryWriter::save : writing";
        PDFGenerator::shared()->write(documentId,this);
        PDFGenerator::shared()->closeDocument(documentId);
        qDebug() << "DiaryWriter::save : copying temporary file";
        SystemUtils::shared()->moveFile(PDFGenerator::shared()->documentPath(documentId),filePath,true);
        qDebug() << "DiaryWriter::save : removing temporary file";
        PDFGenerator::shared()->removeDocument(documentId);
        m_entries.clear();
        qDebug() << "DiaryWriter::save : done";
        emit saved( filePath );
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
    QDate date( entry["year"].toInt(),entry["month"].toInt()+1,entry["day"].toInt());
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
        QVector< qreal > maxValues  = { .25, .5, .75, 1., 1. };
        flowerChartPainter.paint(&flowerImagePainter, flowerBounds, values, maxValues, labels, 12 * ( ( 1./ 72.) * writer->resolution() ), true);
        flowerImagePainter.end();
        //
        //
        //
        m_painter.drawImage(headerRect.x(),headerRect.y(),flowerImage);
    }
    //
    // append challenges
    //
    if ( entry.contains("challenges") ) {
        const qreal challengeHeightInches = .5;
        const qreal kChallengePaddingInches = .1;
        //
        //
        //
        cp.setY( cp.y() + headerRect.height() );
        //
        //
        //
        int challengeHeight = _inchesToPixels(challengeHeightInches,writer);
        int challengeIconOffset = _inchesToPixels(kChallengePaddingInches,writer);
        int challengeIconHeight = challengeHeight - _inchesToPixels(kChallengePaddingInches*2.,writer);
        int challengeIconWidth = ( (qreal)m_challengeIcon.width() / (qreal)m_challengeIcon.height() ) * (qreal) challengeIconHeight;
        //
        //
        //
        QFont challengeFont = m_font;
        challengeFont.setPointSize(9);
        m_painter.setFont(challengeFont);
        //
        //
        //
        QVariantList challenges = entry["challenges"].value<QVariantList>();
        for ( auto& challenge : challenges ) {
            QVariantMap challengeMap = challenge.value<QVariantMap>();
            //
            //
            //
            QRect challengeRect( cp.x(), cp.y(), r.width() / 2, challengeHeight );
            _requestSpace( challengeRect, writer, r, cp);
            QRect challengeBounds = challengeRect.adjusted(m_adjustedPadding,0,-m_adjustedPadding,0);
            //
            // fill background
            //
            m_painter.fillRect( challengeBounds, Colours::shared()->colour("slate") );
            //
            // draw icon
            //
            QRect iconRect(challengeBounds.x()+challengeIconOffset,challengeBounds.y()+challengeIconOffset,challengeIconWidth,challengeIconHeight);
            m_painter.drawImage(iconRect,m_challengeIcon);
            //
            // draw text
            //
            QRect textRect( iconRect.right()+challengeIconOffset, iconRect.top(),
                            challengeBounds.width()-(iconRect.width()+challengeIconOffset*3), iconRect.height());
            m_painter.drawText(textRect,Qt::TextWordWrap|Qt::AlignTop|Qt::AlignLeft,challengeMap["name"].toString());
            //
            // update cp
            //
            cp.setY( cp.y() + challengeRect.height() );
        }
    } else {
        //
        // advance cp
        //
        cp.setY( cp.y() + bounds.height() );
    }
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
        if ( !QFile::exists(imagePath) ) {
            imagePath = SystemUtils::shared()->mediaPath(content);
            if ( !QFile::exists(imagePath) ) {
                qDebug() << "DiaryWriter::_paintEntryBlock : unable to load image : " << content;
                return;
            }
        }
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
        /*
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
        */
        QTextDocument doc;
        doc.documentLayout()->setPaintDevice(m_painter.device());
        doc.setDefaultFont(blockFont);
        doc.setTextWidth(bounds.width()-m_adjustedPadding*3);
        doc.setHtml(content);
        int textHeight = doc.size().height();
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
        //
        //
        //
        m_painter.fillRect( textBox, Colours::shared()->colour("almostWhite"));
        //
        //
        //
        m_painter.save();
        m_painter.translate(QPointF(textBounds.x(), textBounds.y()));
        doc.drawContents(&m_painter);
        m_painter.restore();
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
                m_pageNumber++;
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
    //
    //
    //
    m_painter.save();
    QFont titleFont = m_font;
    titleFont.setPointSize(24);
    m_painter.setFont(titleFont);
    m_painter.setPen(Colours::shared()->colour("lightSlate"));
    QString title( "AfterTrauma - Diary" );
    m_painter.drawText( left.x(), left.y() - m_painter.fontMetrics().descent(), title );
    //
    // page number
    //
    titleFont.setPointSize(10);
    m_painter.setFont(titleFont);
    int offset = m_painter.fontMetrics().height();
    QString pageNumber = QString( "page %1" ).arg(m_pageNumber);
    m_painter.drawText( left.x(), left.bottom()+offset, pageNumber );
    m_painter.restore();
}

