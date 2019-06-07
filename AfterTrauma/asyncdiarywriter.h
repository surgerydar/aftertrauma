#ifndef ASYNCDIARYWRITER_H
#define ASYNCDIARYWRITER_H

#include <QObject>
#include <QFont>
#include <QVariantList>

class AsyncDiaryWriter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QFont font MEMBER m_font)
    Q_PROPERTY( qreal padding MEMBER m_padding )
    Q_PROPERTY( qreal spacing MEMBER m_spacing )

public:
    explicit AsyncDiaryWriter(QObject *parent = 0);

signals:
    void done( QString filePath );
    void error( QString error );

public slots:
    void save( const QVariantList& entries, const QString& filePath );

private:
    QFont   m_font;
    qreal   m_padding;
    qreal   m_spacing;
};

#endif // ASYNCDIARYWRITER_H
