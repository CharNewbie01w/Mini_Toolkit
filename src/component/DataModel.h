#ifndef DATAMODEL_H
#define DATAMODEL_H

#include <QObject>
#include <QVariantMap>
#include <QDebug>
#include <QJsonObject>
#include <QJsonDocument>

class DataModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap data READ getData NOTIFY dataChanged)

public:
    explicit DataModel(QObject *parent = nullptr);
    ~DataModel();
    QVariantMap getData();

signals:
    void dataChanged(QVariantMap data);

public slots:
    void setDataSlot(const QString &key, const QVariant &value);
    void addAppSlot(const QString &key, const QVariant &path);

private:
    QVariantMap jsonToMap(QJsonDocument json);
    QJsonObject mapToJson(QVariantMap map);
    QVariantMap defaultData();

private:
    QJsonObject jsonObj;
    QVariantMap _data;

};

#endif
