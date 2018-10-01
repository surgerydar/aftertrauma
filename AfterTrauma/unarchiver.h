#ifndef UNARCHIVER_H
#define UNARCHIVER_H

#include <QDataStream>
#include <QFile>
#include <QDir>
#include <QThread>
#include <QDebug>

class UnArchiver : public QThread {
    Q_OBJECT
    Q_PROPERTY(QString target READ target WRITE setTarget)
    Q_PROPERTY(QString archive READ archive WRITE setArchive)
public:
    explicit UnArchiver(QObject *parent = Q_NULLPTR) : QThread(parent) {}
    //
    //
    //
    QString target() const { return m_target; }
    void setTarget( const QString target ) { m_target = target; }
    QString archive() const { return m_archive; }
    void setArchive( const QString archive ) { m_archive = archive; }
    void run() override {
        QString message;
        qDebug() << "extracting archive " << m_archive << " to " << m_target;
        QDir dir;
        if ( dir.mkpath(m_target) ) {
            dir.setCurrent(m_target);
            qDebug() << "extracting to : " << dir.currentPath();
            //
            //
            //
            m_file.setFileName(m_archive);
            //m_file(m_archive);
            if ( m_file.open(QFile::ReadOnly) ) {
                m_fileSize          = m_file.size();
                m_bytesProcessed    = 0;
                qDebug() << "unarchiving " << m_fileSize << " bytes from " << m_archive;
                m_dataStream.setDevice(&m_file);
                _extractDir(dir);
                emit done( m_archive, m_target );
            } else {
                message = "unable to open archive";
                qDebug() << message << " : " << m_archive;
                emit error( m_archive, m_target, message );
            }
        } else {
            message = "unable to create target directory";
            qDebug() << message << " : " << m_target;
            emit error( m_archive, m_target, message );
        }
    }
signals:
    void done( const QString& archive, const QString& target );
    void progress( const QString& source, const QString& archive, quint64 total, quint64 current, const QString& message );
    void error( const QString& archive, const QString& target, const QString& message );

private:
    void _extractDir( QDir& targetDir ) {
        QString message;
        //
        // extract file count
        //
        quint64 fileCount;
        m_dataStream >> fileCount;
        //
        // extract files
        //
        qDebug() << "extracting directory : " << targetDir.path() << " : items : " << fileCount;
        for ( quint64 i = 0; i < fileCount; ++i ) {
            //
            //
            //
            if ( m_dataStream.atEnd() ) {
                message = "unexpected end of file";
                // TODO: handle this error
                emit error( m_archive, m_target, message );
                return;
            }
            QString fileName;
            m_dataStream >> fileName;
            if ( fileName.length() > 0 ) {
                bool isDir;
                m_dataStream >> isDir;
                if ( isDir ) {
                    //
                    // extract directory
                    //
                    qDebug() << "extracting directory : " << fileName;
                    if ( targetDir.exists(fileName) || targetDir.mkdir(fileName) ) {
                        targetDir.cd(fileName);
                        _extractDir(targetDir);
                        targetDir.cdUp();
                    } else {
                        message = QString( "unable to create directory %1" ).arg(fileName);
                        emit error( m_archive, m_target, message );
                    }
                } else {
                    //
                    // extract file
                    //
                    QString filePath = targetDir.absoluteFilePath(fileName);
                    if ( !_extractFile(filePath) ) {
                        message = QString( "unable to extract file %1" ).arg(fileName);
                        qDebug() << message;
                        emit error( m_archive, m_target, message );
                    }
                }
            }
            m_bytesProcessed = m_file.pos();
            emit progress( m_archive, m_target, m_fileSize, m_bytesProcessed, message );
        }
    }
    bool _extractFile( const QString& filePath ) {
        qDebug() << "extracting file : " << filePath;
        QFile file( filePath );
        if ( file.open(QFile::WriteOnly) ) {
            QByteArray compressed;
            m_dataStream >> compressed;
            QByteArray data = qUncompress(compressed);
            qDebug() << "writing " << data.length() << " bytes to " << filePath;
            file.write(data);
            return true;
        } else {
            qDebug() << "unable to open file : " << filePath;
        }
        return false;
    }
    //
    //
    //
    QString     m_archive;
    QString     m_target;
    QFile       m_file;
    QDataStream m_dataStream;
    quint64     m_fileSize;
    quint64     m_bytesProcessed;
};

#endif // UNARCHIVER_H
