#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <QMap>
#include <QVariantMap>
#include <QVariantList>
#include <QDebug>

class Launcher : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap appList READ getAppList WRITE setAppList)
public:
    explicit Launcher(QObject *parent = nullptr);
    QVariantMap getAppList();
    void setAppList(const QVariantMap &appList);
    Q_INVOKABLE QVariantList getAppNames();

public slots:
    void addAppSlot(const QString &name, const QString &path);
    void removeAppSlot(const QString &name);
    void startSlot(const QString &name);
    
private:
    QMap<QString, QString> _appList;

};

#endif
