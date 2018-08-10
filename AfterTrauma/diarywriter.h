#ifndef DIARYPAINTER_H
#define DIARYPAINTER_H

#include <QObject>
#include <QVariantList>
#include <QPdfWriter>
#include <QFont>
#include "paintable.h"

class DiaryWriter : public QObject, public Paintable
{
    Q_OBJECT
    Q_PROPERTY(QFont font MEMBER m_font)
    Q_PROPERTY( qreal padding MEMBER m_padding )
    Q_PROPERTY( qreal spacing MEMBER m_spacing )
public:
    explicit DiaryWriter(QObject *parent = 0);
    //
    //
    //
    void paint( QPainter* painter, const QRect& r ) override;
    void write( QPdfWriter* painter ) override;

signals:


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
