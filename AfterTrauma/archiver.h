#ifndef ARCHIVER_H
#define ARCHIVER_H

#include <QDataStream>
#include <QFile>
#include <QDir>
#include <QThread>
#include <QDebug>
//
//
//
class Archiver : public QThread {
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource)
    Q_PROPERTY(QString archive READ archive WRITE setArchive)
public:
    explicit Archiver(QObject *parent = Q_NULLPTR) : QThread(parent) {}
    //
    //
    //
    QString source() const { return m_source; }
    void setSource( const QString source ) { m_source = source; }
    QString archive() const { return m_archive; }
    void setArchive( const QString archive ) { m_archive = archive; }
    //
    //
    //
    void run() override {
        QString message;
        //
        // open source directory
        //
        QDir dir( m_source );
        if ( dir.exists() ) {
            //
            // open archive
            //
            QFile archive( m_archive );
            if ( archive.open(QFile::WriteOnly) ) {
                //
                // traverse directory
                //
                m_dataStream.setDevice(&archive);
                QStringList files = dir.entryList(QDir::Files);
                quint64 nFiles = files.size();
                quint64 filesProcessed = 0;
                message = "archiving files";
                for ( auto& filename : files ) {
                    QString filePath = dir.absoluteFilePath(filename);
                    qDebug() << "archiving file : " << filename;
                    _addFile( filename, filePath );
                    filesProcessed++;
                    emit progress(m_source, m_archive,nFiles,filesProcessed,message);
                }
                archive.close();
                emit done( m_source, m_archive);
            } else {
                message = "unable to open target archive";
                qDebug() << message << " : " << m_archive;
                emit error( m_source, m_archive, message );
            }

        } else {
            message = "unable to open source directory";
            qDebug() << message << " : " << m_source;
            emit error( m_source, m_archive, message );
        }
    }
signals:
    void done( const QString& source, const QString& archive );
    void progress( const QString& source, const QString& archive, quint64 total, quint64 current, const QString& message );
    void error( const QString& source, const QString& archive, const QString& message );

private:
    void _addFile( const QString& filename, const QString& filepath ) {
        QFile file(filepath);
        if ( file.open( QFile::ReadOnly ) ) {
            //
            // write compressed file to data stream
            //
            QByteArray data = file.readAll();
            m_dataStream << filename;
            m_dataStream << qCompress(data);
        } else {
            emit error( m_source, m_archive, filepath );
        }
    }
    //
    //
    //
    QString     m_source;
    QString     m_archive;
    QDataStream m_dataStream;
};
#endif // ARCHIVER_H
