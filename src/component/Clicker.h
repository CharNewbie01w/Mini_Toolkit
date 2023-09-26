#ifndef CLICKER_H
#define CLICKER_H

#include <QObject>
#include <QMap>

class Clicker: public QObject
{
    Q_OBJECT
    
public:
    explicit Clicker(QObject *parent = nullptr);

};

#endif
