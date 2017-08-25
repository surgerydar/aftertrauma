#include "databasesync.h"
#include <QWebSocket>
#include <QMutex>
#include <QWaitCondition>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

void DatabaseSync::run() {
    /*
    QWebSocket socket;
    QMutex mutex;
    QWaitCondition connectedCondition;
    QWaitCondition responseCondition;
    //
    //
    //
    QJsonDocument json;
    QJsonObject command;
    QJsonObject response;
    bool connected = false;
    //
    // connect to signals
    //
    connect(&socket, &QWebSocket::connected, this, [this,&mutex,&connectedCondition,&connected](){
        mutex.lock();
        connected = true;
        connected.wakeAll();
        mutex.unlock();
    });
    connect(&socket, &QWebSocket::disconnected, this, [this,&mutex,&connectedCondition,&connected](){
        mutex.lock();
        connected = true;
        connected.wakeAll();
        mutex.unlock();
    });
    connect(&socket, &QWebSocket::textMessageReceived, this, [this,&mutex,&responseCondition,&response](const QString& message){
        //
        // parse message
        //
        QJsonDocument json;
        json.fromJson(message);
        //
        // interpret response
        //
        mutex.lock();
        response = json.object();
        responseCondition.wakeAll();
        mutex.unlock();
    });
    //
    //
    //
    socket.open(m_url);
    //
    //
    //
    emit syncStart();
    //
    // wait for connection
    //
    mutex.lock();
    connectedCondition.wait(&mutex);
    mutext.unlock();
    if ( !connected ) {
        emit syncError("unable to connect");
        return;
    }
    //
    // send sync request
    //
    mutex.lock();
    command["command"] = "syncstart";
    command["collection"] = m_database.collection;
    command["objects"] = m_database.find(QVariant()); // TODO: just send id's
    json.setObject(command);
    socket.sendTextMessage(json.toJson());
    //
    // wait for sync response
    //
    responseCondition.wait(&mutex);
    //
    // process sync response
    //
    bool abort = false;
    QString reason;
    QJsonArray upList;
    QJsonArray downList;
    if ( response.contains("status") ) {
        if ( response["status"].toString() == "ERROR" ) {
            abort = true;
            reason = response.contains("error") ? response["error"].toString() : "unknows error";
        } else {
            if ( response.contains("response") ) {
                QJsonArray syncList = response["response"].toArray();
                QVariantMap query;
                for ( int i = 0; i < syncList.size(); i++ ) {
                    QVariantMap down = syncList[ i ].toVariant().toMap();
                    query["id"] = down["id"];
                    QVariantList result = m_database.find(query).toList();
                    if ( result.size() > 0 ) {
                        QVariantMap up = m_database.find(query).toMap(); // FIX ME: this returns a list
                        if ( down["date"] < up["date"] ) {
                            // add object to up list
                            upList.append(up);
                        } else if ( down["date"] > up["date"] ) {
                            // add id to down list
                            downList.append(down["id"]);
                        }
                    } else {

                    }
                }
            }
        }
    }
    mutex.unlock();
    if ( abort ) {
        emit syncError(reason);
        return;
    }
    */
}

void DatabaseSync::sync( QString& url, DatabaseList& database ) {
    m_url = url;
    //m_database = database;
}
