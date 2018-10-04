#ifndef DIARYPAINTER_H
#define DIARYPAINTER_H

#include <QObject>
#include <QVariantList>
#include <QPdfWriter>
#include <QFont>
#include <QImage>
#include "paintable.h"

class DiaryWriter : public QObject, public Paintable
{
    Q_OBJECT
    Q_PROPERTY(QFont font READ font WRITE setFont)
    Q_PROPERTY(qreal padding READ padding WRITE setPadding)
    Q_PROPERTY(qreal spacing READ spacing WRITE setSpacing)
public:
    explicit DiaryWriter(QObject *parent = 0);
    //
    //
    //
    void paint( QPainter* painter, const QRect& r ) override;
    void write( QPdfWriter* painter ) override;
    //
    //
    //
    QFont font() const { return m_font; }
    void setFont( const QFont& font ) { m_font = font; }
    qreal padding() const { return m_padding; }
    void setPadding( const qreal padding ) { m_padding = padding; }
    qreal spacing() const { return m_spacing; }
    void setSpacing( const qreal spacing ) { m_spacing = spacing; }

signals:
    void saved( QString pdfPath );
    void error( QString error );

public slots:
    void save( const QVariantList& entries, const QString& filePath );

private:
    //
    //
    //
    QVariantList    m_entries;
    QFont           m_font;
    qreal           m_padding;
    qreal           m_spacing;
    qreal           m_adjustedPadding;
    qreal           m_adjustedSpacing;
    QPainter        m_painter;
    int             m_pageNumber;
    QImage          m_challengeIcon;
    //
    //
    //
    void _paintEntry( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _paintEntryHeader( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _paintEntryBlocks( const QVariant& blocks, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _paintEntryBlock( const QVariantMap& block, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _requestSpace( QRect& requested, QPdfWriter* writer, const QRect& r, QPoint& cp);
    void _paintPageBackground();
    QRect _padRectangle( QRect& rectangle ) { return rectangle.adjusted(m_adjustedPadding,m_adjustedPadding/2,-m_adjustedPadding,-m_adjustedPadding/2); }
    //
    //
    //
    qreal _inchesToPixels( qreal inches, QPdfWriter* writer ) { return ( qreal ) writer->resolution() * inches; }
};

#endif // DIARYPAINTER_H
