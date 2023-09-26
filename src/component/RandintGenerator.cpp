#include "RandintGenerator.h"
#include <random>
#include <time.h>

RandintGenerator::RandintGenerator(QObject *parent)
{
    srand(time(NULL));
}

int RandintGenerator::getRanNum()
{
    return rand();
}
