#include "pnggenerator.h"
#include <QDebug>

PNGGenerator* PNGGenerator::s_shared = nullptr;

PNGGenerator::PNGGenerator(QObject*parent) : QObject(parent) {

}

PNGGenerator::~PNGGenerator() {
    m_documents.clear();
}

PNGGenerator* PNGGenerator::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new PNGGenerator;
    }
    return s_shared;
}
