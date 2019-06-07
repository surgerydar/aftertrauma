#ifndef PNGGenerator_H
#define PNGGenerator_H

#include <QObject>
#include <QPainter>
#include <QTemporaryFile>
#include <QUuid>
#include <QMap>
#include <QVariant>
#include <QDebug>
#include <memory>
#include "systemutils.h"
#include "paintable.h"
#include "pagedpng.h"
class PNGGenerator : public QObject
{
    Q_OBJECT
public:
    explicit PNGGenerator(QObject*parent=0);
    virtual ~PNGGenerator();
    //
    //
    //
    static PNGGenerator* shared();

signals:

public slots:
    QString openDocument() {
        QString id = QUuid::createUuid().toString();
        m_documents[ id ] = std::make_shared<PNGDocument>();
        if ( m_documents[ id ]->isOpen() ) {
            m_documents[ id ]->m_writer->setResolution(150);
            m_documents[ id ]->m_writer->setPageOrientation(QPageLayout::Landscape);
            m_documents[ id ]->m_writer->setPageSize(PagedPNG::A4);
            PagedPNG::Margins margins = {30,30,30,30};
            //PagedPNG::Margins margins = {1,1,1,1};
            m_documents[ id ]->m_writer->setMargins(margins);
        }
        return m_documents[ id ]->isOpen() ? id : QString();
    }

    void closeDocument(QString id ) {
        if ( m_documents.contains(id) ) {
            m_documents[id]->close();
        }
    }

    void removeDocument( QString id ) {
        if ( m_documents.contains( id ) ) {
            m_documents.remove(id);
        }
    }

    QString documentPath(QString id) {
        if ( m_documents.contains(id) ) {
            return m_documents[id]->m_file.fileName();
        }
        return "";
    }

    QRect pageBounds(QString id) {
        QRect r;
        if ( m_documents.contains(id) && m_documents[ id ]->isOpen() ) {
            r = m_documents[id]->m_writer->paintRect();
        }
        return r;
    }

    PagedPNG* writer(QString id) {
        if ( m_documents.contains(id) && m_documents[ id ]->isOpen() ) {
            return m_documents[ id ]->m_writer;
        }
        return nullptr;
    }

    void paint(QString id, Paintable* paintable) {
        if ( m_documents.contains(id) ) {
/*
#ifdef Q_OS_IOS
            QPainter painter( m_documents[id]->m_writer->imageptr() );
#else
            QPainter painter( m_documents[id]->m_writer );
#endif
            painter.setViewport(m_documents[id]->m_writer->paintRect());
            QRect r = painter.viewport();
            r.moveTo(0,0);
*/
            QPainter painter( m_documents[id]->m_writer->imageptr() );
            QRect r = m_documents[id]->m_writer->paintRect();
            paintable->paint(&painter,r);
        }
    }

    void write(QString id, Paintable* paintable) {
        if ( m_documents.contains(id) ) {
            PagedPNG* writer = m_documents[id]->m_writer;
            //
            //
            //
            writer->setPageOrientation(QPageLayout::Portrait);
            paintable->write(writer);
        }
    }

private:
    static PNGGenerator* s_shared; // TODO: shared_ptr
    class PNGDocument : public QObject {
    public:
        PNGDocument( QObject* parent = 0 ) : QObject( parent ) {
            m_writer = nullptr;
            //m_file.setFileTemplate("XXXXXX.pdf");
            qDebug() << "PNGDocument::PNGDocument";
            if ( m_file.open() ) {
                //m_writer = std::make_shared<PagedPNG>(this);
                qDebug() << "PNGDocument::PNGDocument : creating PagedPNG";
                m_writer = new PagedPNG(this);
            }
        }
        ~PNGDocument() {
            qDebug() << "PNGDocument::~PNGDocument";
            if ( isOpen() ) {
                close();
            }
        }
        bool isOpen() {
            return m_file.isOpen();
        }
        void close() {
            if ( isOpen() ) {
                m_writer->write( &m_file );
                m_file.close();
            }
        }
        //
        //
        //
        QTemporaryFile              m_file;
        //std::shared_ptr<PagedPNG>   m_writer;
        PagedPNG*                   m_writer;
    };
    QMap< QString, std::shared_ptr<PNGGenerator::PNGDocument> > m_documents;
};

#endif // PNGGenerator_H
