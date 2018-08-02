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
            QFile file(m_archive);
            if ( file.open(QFile::ReadOnly) ) {
                int fileSize = ( int ) file.size();
                int bytesProcessed = 0;
                m_dataStream.setDevice(&file);
                message = "extracting data";
                while( !m_dataStream.atEnd() ) {
                    QString filename;
                    m_dataStream >> filename;
                    qDebug() << "extracted filename " << filename;
                    if ( filename.length() > 0 ) {
                        QString filepath = dir.absoluteFilePath(filename);
                        if ( !_extractFile(filepath) ) {
                            message = QString( "unable to extract file %1" ).arg(filename);
                            emit error( m_archive, m_target, message );
                        }
                    } else {
                        qDebug() << "invalid filename";
                    }
                    bytesProcessed = (int)file.pos();
                    emit progress( m_archive, m_target, fileSize, bytesProcessed, message );
                }
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
    void progress( const QString& source, const QString& archive, int total, int current, const QString& message );
    void error( const QString& archive, const QString& target, const QString& message );

private:
    bool _extractFile( const QString& filepath ) {
        qDebug() << "extracting file : " << filepath;
        QFile file( filepath );
        if ( file.open(QFile::WriteOnly) ) {
            QByteArray compressed;
            m_dataStream >> compressed;
            QByteArray data = qUncompress(compressed);
            file.write(data);
            return true;
        } else {
            qDebug() << "unable to open file : " << filepath;
        }
        return false;
    }
    //
    //
    //
    QString     m_archive;
    QString     m_target;
    QDataStream m_dataStream;
};

#endif // UNARCHIVER_H
