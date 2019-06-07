#include "asyncdiarywriter.h"
#include "asyncdiarywriterworker.h"

AsyncDiaryWriter::AsyncDiaryWriter(QObject *parent) : QObject(parent) {
    m_padding = .25;
    m_spacing = .5;
}

void AsyncDiaryWriter::save( const QVariantList& entries, const QString& filePath ) {
    AsyncDiaryWriterWorker* worker = new AsyncDiaryWriterWorker;
    //
    //
    //
    worker->m_entries   = entries;
    worker->m_filePath  = filePath;
    worker->m_font      = m_font;
    worker->m_padding   = m_padding;
    worker->m_spacing   = m_spacing;
    //
    //
    //
    connect( worker, &AsyncDiaryWriterWorker::done, this, &AsyncDiaryWriter::done);
    connect( worker, &AsyncDiaryWriterWorker::error, this, &AsyncDiaryWriter::error);
    connect( worker, &AsyncDiaryWriterWorker::finished, worker, &QObject::deleteLater);
    //
    //
    //
    worker->start();
}
