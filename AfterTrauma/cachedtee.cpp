#include "cachedtee.h"
#include <qmath.h>
#include <QDebug>

CachedTee::CachedTee(QObject *parent) : QIODevice(parent) {
    m_input = m_output = nullptr;
}

CachedTee::~CachedTee() {
    qDebug() << "CachedTee::~CachedTee";
}

//
//
//
void CachedTee::setup( QIODevice* input, QIODevice* output ) {
    //
    // take ownership of input and output
    //
    m_input = input;
    m_output = output;
    m_input->setParent(this);
    if ( m_output ) {
        m_output->setParent(this);
    }
    //
    // read any bytes avaliable
    //
    processInput();
    //
    // connect to input signals
    //
    connect( m_input, &QIODevice::readyRead,[this]() {
        processInput();
    });
    //
    // handle input closing
    //
    connect( m_input, &QIODevice::aboutToClose,[this]() {
        qDebug() << "CachedTee : input about to close : error : " << m_input->errorString();
        if ( isOpen() ) close();
    });
}
//
//
//
bool CachedTee::open(OpenMode mode) {
    if ( mode == ReadOnly ) {
        if ( QIODevice::open(mode) ) {
            if ( m_buffer.size() > 0 ) {
                emit readyRead();
            }
            return true;
        }
    }
    return false;
}

void CachedTee::close() {
    qDebug() << "CachedTee::close";
    QIODevice::close();
    if ( m_input ) {
        if ( m_input->isOpen() ) m_input->close();
        m_input->deleteLater();
        m_input = nullptr;
    }
    if ( m_output ) {
        if ( m_output->isOpen() ) m_output->close();
        m_output->deleteLater();
        m_output = nullptr;
    }
    m_bufferGuard.lock();
    m_buffer.clear();
    m_bufferGuard.unlock();
    //
    //
    //
    deleteLater();
}

qint64 CachedTee::readData(char *data, qint64 maxlen) {
    qDebug() << "CachedTee::readData";
    qint64 bytesToRead = qMin( (qint64)m_buffer.size(), maxlen );
    m_bufferGuard.lock();
    memcpy(data,m_buffer.data(),bytesToRead);
    if ( bytesToRead == m_buffer.size() ) {
        m_buffer.clear();
    } else {
        m_buffer = m_buffer.right(m_buffer.size()-bytesToRead);
    }
    m_bufferGuard.unlock();
    return bytesToRead;
}

qint64 CachedTee::readLineData(char* /*data*/, qint64 /*maxlen*/) {
    return 0;
}

qint64 CachedTee::writeData(const char* /*data*/, qint64 /*len*/) {
    return 0;
}
//
//
//
void CachedTee::processInput() {
    //
    // read data from input
    //
    int bytesAvailable = m_input->bytesAvailable();
    if ( bytesAvailable > 0 ) {
        qDebug() << "CachedTee::processInput : " << bytesAvailable << " bytes";

        QByteArray buffer(bytesAvailable,0);
        int bytesRead = m_input->read( buffer.data(), bytesAvailable );
        //
        // write data to output
        //
        if ( m_output && m_output->isWritable() ) {
            m_output->write(buffer.data(),bytesRead);
        }
        //
        // append to internal buffer
        //
        buffer.resize(bytesRead);
        m_bufferGuard.lock();
        m_buffer.append(buffer);
        m_bufferGuard.unlock();
        qDebug() << "CachedTee::processInput : buffer size : " << m_buffer.size();
        //
        //
        //
        emit readyRead();
    }
}
