#ifndef PAINTABLE_H
#define PAINTABLE_H

#include <QPainter>
#include <QPdfWriter>
#include <QRect>

class Paintable {
public:
    virtual void paint( QPainter* painter, const QRect& r ) = 0;
    virtual void write( QPdfWriter* painter, const QRect& r ) = 0;
};

#endif // PAINTABLE_H
