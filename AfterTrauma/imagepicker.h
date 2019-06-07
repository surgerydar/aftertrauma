#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H

#include <QObject>

class ImagePicker : public QObject
{
    Q_OBJECT
public:
    explicit ImagePicker(QObject *parent = 0);
    static ImagePicker* shared();
private:
    static ImagePicker* s_shared;
signals:
    void imagePicked( QString url );
public slots:
    void openGallery();
    void openCamera();
};

#endif // IMAGEPICKER_H
