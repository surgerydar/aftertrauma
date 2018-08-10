#ifndef PDFGENERATOR_H
#define PDFGENERATOR_H

#include <QObject>
#include <QPainter>
#include <QPdfWriter>
#include <QTemporaryFile>
#include <QUuid>
#include <QMap>
#include <QVariant>
#include <QDebug>
#include <memory>
#include "systemutils.h"
#include "paintable.h"

class PDFGenerator : public QObject
{
    Q_OBJECT
public:
    explicit PDFGenerator(QObject*parent=0);
    virtual ~PDFGenerator();
    //
    //
    //
    static PDFGenerator* shared();

signals:

public slots:
    QString openDocument() {
        QString id = QUuid::createUuid().toString();
        m_documents[ id ] = std::make_shared<PDFDocument>();
        if ( m_documents[ id ]->isOpen() ) {
            m_documents[ id ]->m_writer->setPageOrientation(QPageLayout::Landscape);
            m_documents[ id ]->m_writer->setPageSize(QPdfWriter::A4);
            QPdfWriter::Margins margins = {30,30,30,30};
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
            QPainter painter( m_documents[id]->m_writer.get() );
            r = painter.viewport();
        }
        return r;
    }

    std::shared_ptr<QPdfWriter> writer(QString id) {
        if ( m_documents.contains(id) && m_documents[ id ]->isOpen() ) {
            return m_documents[ id ]->m_writer;
        }
        return nullptr;
    }

    void paint(QString id, Paintable* paintable) {
        if ( m_documents.contains(id) ) {
            QPainter painter( m_documents[id]->m_writer.get() );
            QRect r = painter.viewport();
            paintable->paint(&painter,r);
        }
    }

    void write(QString id, Paintable* paintable) {
        if ( m_documents.contains(id) ) {
            QPdfWriter* writer = m_documents[id]->m_writer.get();
            //
            //
            //
            writer->setPageOrientation(QPageLayout::Portrait);
            paintable->write(writer);
        }
    }

    //void drawText(QString id, QVariant position, QString text);
private:
    static PDFGenerator* s_shared; // TODO: shared_ptr
    class PDFDocument : public QObject {
    public:
        PDFDocument( QObject* parent = 0 ) : QObject( parent ) {
            m_writer = nullptr;
            //m_file.setFileTemplate("XXXXXX.pdf");
            if ( m_file.open() ) {
                m_writer = std::make_shared<QPdfWriter>( &m_file );
            }
        }
        ~PDFDocument() {
            qDebug() << "PDFDocument::~PDFDocument";
            if ( isOpen() ) {
                close();
            }
        }
        bool isOpen() {
            return m_file.isOpen();
        }
        void close() {
            if ( isOpen() ) {
                m_file.close();
            }
        }
        //
        //
        //
        QTemporaryFile              m_file;
        std::shared_ptr<QPdfWriter> m_writer;
    };
    QMap< QString, std::shared_ptr<PDFGenerator::PDFDocument> > m_documents;
};

#endif // PDFGENERATOR_H
