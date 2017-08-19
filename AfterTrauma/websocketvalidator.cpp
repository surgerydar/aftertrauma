#include "websocketvalidator.h"


WebSocketValidator* WebSocketValidator::s_shared = nullptr;

WebSocketValidator::WebSocketValidator(QObject *parent) : QValidator(parent) {

}

WebSocketValidator* WebSocketValidator::shared() {
    if ( !s_shared ) {
        s_shared = new WebSocketValidator();
    }
    return s_shared;
}

//
// QValidator implimentation
//
void WebSocketValidator::fixup(QString &input) const {

}
QValidator::State WebSocketValidator::validate(QString &input, int &pos) const {
    //m_pending = input;

    return QValidator::Acceptable;
}
void WebSocketValidator::onConnected() {

}

void WebSocketValidator::onDisconnected() {

}

void WebSocketValidator::onTextMessageReceived(QString message) {

}
