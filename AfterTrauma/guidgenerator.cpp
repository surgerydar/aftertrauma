#include "guidgenerator.h"
#include <QUuid>

GuidGenerator* GuidGenerator::s_shared = nullptr;

GuidGenerator::GuidGenerator(QObject *parent) : QObject(parent) {

}

GuidGenerator* GuidGenerator::shared() {
    if ( !s_shared ) {
        s_shared = new GuidGenerator();
    }
    return s_shared;
}

QString GuidGenerator::generate() {
    return QUuid::createUuid().toString();
}
