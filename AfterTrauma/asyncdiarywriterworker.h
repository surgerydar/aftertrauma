#ifndef ASYNCDIARYWRITERWORKER_H
#define ASYNCDIARYWRITERWORKER_H

#include <QObject>
#include <QThread>
#include <QFont>
#include <QString>
#include <QVariantList>

#include "diarywriter.h"

class AsyncDiaryWriterWorker : public QThread {
    Q_OBJECT
public:
    void run() override {
        DiaryWriter* writer = new DiaryWriter( this );
        writer->setFont(m_font);
        writer->setPadding(m_padding);
        writer->setSpacing(m_spacing);
        writer->save(m_entries,m_filePath);
        emit done(m_filePath);
    }
    //
    //
    //
    QString         m_filePath;
    QVariantList    m_entries;
    QFont           m_font;
    qreal           m_padding;
    qreal           m_spacing;

signals:
    void done(const QString &filePath);
    void error(const QString &error);

};

#endif // ASYNCDIARYWRITERWORKER_H
