#include "DataModel.h"
#include <QFile>

DataModel::DataModel(QObject *parent)
{
    QFile file("conf.json");
    if (file.exists())
    {
        file.open(QIODevice::ReadOnly | QIODevice::Text);
        QByteArray data = file.readAll();
        QJsonDocument json = QJsonDocument::fromJson(data);
        _data = jsonToMap(json);
        file.close();
    }
    else
    {
        _data = defaultData();
    }
}

DataModel::~DataModel()
{
    // qDebug() << "DataModel::~DataModel()";
    QFile file("conf.json");
    if (file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        // jsonObj = QJsonObject(QJsonDocument::fromJson(QJsonDocument::fromVariant(QVariant(_data)).toJson()).object());
        // QJsonDocument json = QJsonDocument(jsonObj);
        file.write(QJsonDocument(mapToJson(_data)).toJson());
        file.close();
    }
}

QVariantMap DataModel::getData()
{
    return _data;
}

void DataModel::addAppSlot(const QString &key, const QVariant &path)
{
}

QVariantMap DataModel::jsonToMap(QJsonDocument json)
{
    jsonObj = json.object();
    return jsonObj.toVariantMap();
}

QJsonObject DataModel::mapToJson(QVariantMap map)
{
    QMapIterator<QString, QVariant> i(map);
    QJsonObject obj;
    while (i.hasNext())
    {
        i.next();
        if (i.value().type() == QVariant::String)
        {
            obj.insert(i.key(), i.value().toString());
        }
        else if (i.value().type() == QVariant::Int)
        {
            obj.insert(i.key(), i.value().toInt());
        }
        else if (i.value().type() == QVariant::Double)
        {
            obj.insert(i.key(), i.value().toDouble());
        }
        else if (i.value().type() == QVariant::Bool)
        {
            obj.insert(i.key(), i.value().toBool());
        }
        else 
        {
            obj.insert(i.key(), mapToJson(i.value().toMap()));
            // qDebug() << "mapToJson" << i.key() << i.value().toJsonObject();
        }
    }

    return obj;
}

QVariantMap DataModel::defaultData()
{
    QVariantMap data;
    // data.insert("key", "value");
    data.insert("appList", QVariantMap());
    return data;
}

void DataModel::setDataSlot(const QString &key, const QVariant &value)
{
    if (!_data.contains(key))
    {
        // Create
        _data.insert(key, value);
    }
    else
    {
        // Modify
        _data[key] = value;
    }
}
