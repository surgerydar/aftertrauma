#include "cachedimageprovider.h"
#include <QFile>
#include <QImageReader>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include "systemutils.h"

class CachedImageResponse : public QQuickImageResponse, public QRunnable
{
    public:
        CachedImageResponse(const QString &id, const QSize &requestedSize) :
            m_id(id),
            m_requestedSize(requestedSize) {
            setAutoDelete(false);
            m_instanceCount++;
        }
        virtual ~CachedImageResponse() {
            m_instanceCount--;
            qDebug() << "~CachedImageResponse : " << m_instanceCount << " remaining";
        }

        QQuickTextureFactory *textureFactory() const {
            return QQuickTextureFactory::textureFactoryForImage(m_image);
        }
        QString errorString() const {
            return m_errorString;
        }
        //
        //
        //
        void run() {
            //
            // check for image in local cache
            //
            QUrl url( m_id );
            QString localPath = SystemUtils::shared()->documentDirectory().append("/media/").append(url.fileName());
            if ( QFile::exists(localPath) ) {
                QFile file(localPath);
                if(file.open(QFile::ReadOnly)) {
                    //qDebug() << "CachedImageResponse : loading cached image data : " << localPath;
                    QByteArray buffer;
                    while (!file.atEnd()) {
                        QByteArray chunk = file.read(512);
                        if ( chunk.size() > 0 ) {
                            buffer.append(chunk);
                            QThread::yieldCurrentThread();
                        }
                    }
                    //qDebug() << "CachedImageResponse : cached image data loaded";
                    m_image.loadFromData(buffer);
                    //qDebug() << "CachedImageResponse : cached image loaded from data";
                    if ( !m_image.isNull() ) {
                        scaleImage();
                        emit finished();
                        return;
                    } else {
                        qDebug() << "CachedImageResponse : error loading cached image : " << localPath;
                    }
                } else {
                    qDebug() << "CachedImageResponse : error loading cached image : " << localPath;
                }

            }
            //
            // fall through to load from network
            //
            //qDebug() << "CachedImageResponse : loading image from network : " << m_id;
            QNetworkAccessManager net;
            QEventLoop loop;
            connect(&net, &QNetworkAccessManager::finished, [this,&loop]( QNetworkReply* reply ) {
                this->replyFinished(reply);
                loop.quit();
            });
            //
            // load image from network
            //
            QNetworkRequest request(url);
            request.setHeader(QNetworkRequest::UserAgentHeader, "AfterTrauma v0.1");
            net.get(request);
            loop.exec();
        }

        void scaleImage() {
            if (m_requestedSize.isValid()) {
                //qDebug() << "CachedImageResponse : resizing image";
                m_image = m_image.scaled(m_requestedSize, Qt::KeepAspectRatio);
                //qDebug() << "CachedImageResponse : image resized";
            }
        }

private slots:
        void replyFinished(QNetworkReply* reply) {
            //qDebug() << "CachedImageResponse : reply : " << reply->request().url();
            if ( reply->error() == QNetworkReply::NoError ) {
                QByteArray data = reply->readAll();
                m_image.loadFromData(data);
                if ( !m_image.isNull() ) {
                    QString filename = reply->url().fileName();
                    QString filepath = SystemUtils::shared()->documentDirectory().append("/media/").append(filename);
                    m_image.save(filepath);
                    scaleImage();
                } else {
                   m_errorString = "Invalid image format";
                }
            } else {
                //
                //
                //
                m_errorString = reply->errorString();
            }
            if ( m_errorString.length() > 0 ) {
                qDebug() << "CachedImageResponse error : " << reply->error() << " : " << m_errorString;
            }
            reply->deleteLater();
            emit finished();
        }

private:
        QString m_id;
        QSize   m_requestedSize;
        QImage  m_image;
        QString m_errorString;
        static int m_instanceCount;
};

int CachedImageResponse::m_instanceCount = 0;

CachedImageProvider::CachedImageProvider() : QQuickAsyncImageProvider() {

}
//
//
//
QQuickImageResponse* CachedImageProvider::requestImageResponse(const QString &id, const QSize &requestedSize) {
    //qDebug() << "requested id : " << id;
    CachedImageResponse *response = new CachedImageResponse(id, requestedSize);
    m_pool.start(response);
    return response;
}
