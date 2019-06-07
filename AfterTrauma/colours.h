#ifndef COLOURS_H
#define COLOURS_H

#include <QObject>
#include <QColor>
#include <QMap>
#include <QVector>

class Colours : public QObject
{
    Q_OBJECT
public:
    explicit Colours(QObject *parent = 0);
    //
    //
    //
    static Colours* shared();

signals:

public slots:
    QColor categoryColour( int index ) {
        return s_categoryColours[ index % s_categoryColours.size() ];
    }
    QColor colour( const QString name ) {
        if ( s_colours.contains(name) ) {
            return s_colours[name];
        }
        return QColor();
    }

private:
    static Colours* s_shared;
    static QMap< QString, QColor > s_colours;
    static QVector< QColor > s_categoryColours;
};

#endif // COLOURS_H
