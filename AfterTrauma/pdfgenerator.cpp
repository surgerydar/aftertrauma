#include "pdfgenerator.h"
#include <QDebug>

PDFGenerator* PDFGenerator::s_shared = nullptr;

PDFGenerator::PDFGenerator(QObject*parent) : QObject(parent) {

}

PDFGenerator::~PDFGenerator() {
    m_documents.clear();
}

PDFGenerator* PDFGenerator::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new PDFGenerator;
    }
    return s_shared;
}
