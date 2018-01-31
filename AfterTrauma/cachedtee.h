#ifndef CACHEDTEE_H
#define CACHEDTEE_H

#include <QIODevice>
#include <QMutex>
#include <QDebug>

class CachedTee : public QIODevice
{
    Q_OBJECT
public:
    explicit CachedTee(QObject *parent = 0);
    ~CachedTee();
    //
    //
    //
    void setup( QIODevice* input, QIODevice* output );
    //
    //
    //
    bool open(OpenMode mode) override;
    void close() override;
    bool isSequential() const override {
        qDebug() << "CachedTee::isSequential";
        return true;
    }
    qint64 bytesAvailable() const override {
        qDebug() << "CachedTee::bytesAvailable : " << m_buffer.size();
        return m_buffer.size();
    }
protected:
    qint64 readData(char *data, qint64 maxlen) override;
    qint64 readLineData(char *data, qint64 maxlen) override;
    qint64 writeData(const char *data, qint64 len) override;
private:
    void processInput();
    QIODevice*  m_input;
    QIODevice*  m_output;
    QMutex      m_bufferGuard;
    QByteArray  m_buffer;
signals:

public slots:
};

#endif // CACHEDTEE_H
