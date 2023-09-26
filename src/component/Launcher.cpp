#include "Launcher.h"
#include <string>
#include <QString>
#include <Windows.h>
#include <filesystem>

Launcher::Launcher(QObject *parent)
{
}

QVariantMap Launcher::getAppList()
{
    QVariantMap appList;

    for (auto it = _appList.begin(); it != _appList.end(); it++)
    {
        appList[it.key()] = it.value();
    }

    return appList;
}

void Launcher::setAppList(const QVariantMap &appList)
{
    foreach (const QString &key, appList.keys()) 
    {  
        if (appList[key].type() == QVariant::String) 
        {  
            _appList[key] = appList[key].toString();  
        }  
    }
}

Q_INVOKABLE QVariantList Launcher::getAppNames()
{
    QVariantList appNames;

    for (auto it = _appList.begin(); it != _appList.end(); it++)
    {
        appNames.append(it.key());
    }

    return appNames;
}

void Launcher::addAppSlot(const QString &name, const QString &path)
{
    // qDebug() << name << path;
    if (!(name.isNull() || name.isEmpty()))
    {
        _appList.insert(name, path);
    }
}

void Launcher::removeAppSlot(const QString &name)
{
    _appList.remove(name);
}

void Launcher::startSlot(const QString &name)
{
    QString path_t = _appList[name];
    std::wstring path = path_t.toStdWString();
    std::filesystem::path p(path);
    std::filesystem::path d = p.parent_path();
    // qDebug() << (d.c_str());
    const wchar_t* cmd = path.c_str();
    ShellExecute(NULL, NULL, cmd, NULL, d.wstring().c_str(), SW_SHOW);
}
