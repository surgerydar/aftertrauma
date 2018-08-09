#ifndef DIARYPAINTER_H
#define DIARYPAINTER_H

#include <QObject>
#include <QVariantList>
#include <QPdfWriter>
#include <QFont>
#include "paintable.h"

class DiaryPainter : public QObject, public Paintable
{
    Q_OBJECT
    Q_PROPERTY(QFont font MEMBER m_font)
public:
    explicit DiaryPainter(QObject *parent = 0);
    //
    //
    //
    void paint( QPainter* painter, const QRect& r ) override;
    void write( QPdfWriter* painter, const QRect& r ) override;

signals:


public slots:
    void save( const QVariantList& entries, const QString& filePath );

private:
    //
    //
    //
    QVariantList m_entries;
    QFont m_font;
    //
    //
    //
    void _paintEntry( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _paintEntryHeader( const QVariantMap& entry, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _paintEntryBlocks( const QVariant& blocks, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _paintEntryBlock( const QVariantMap& block, QPdfWriter* writer, const QRect& r, QPoint& cp );
    void _requestSpace( QRect& requested, QPdfWriter* writer, const QRect& r, QPoint& cp);
};

#endif // DIARYPAINTER_H
