#ifndef RANDINT_H
#define RANDINT_H

#include <QObject>

class RandintGenerator: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int ranNum READ getRanNum)
    
public:
    explicit RandintGenerator(QObject *parent = nullptr);
    int getRanNum();

};

#endif
