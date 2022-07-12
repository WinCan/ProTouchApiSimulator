#include "LazyDynamicLibraryHelpers.h"
#ifdef Q_OS_WIN64
#include <windows.h>
#endif
#include <QFile>
#include <QCoreApplication>
#include <memory>
#include <QHash>
#include <iostream>

#ifdef Q_OS_WIN64
namespace
{
struct Pimpl
{
    QHash<QString, HMODULE> modules;
    ~Pimpl()
    {
        for(auto module : modules)
        {
            FreeLibrary(module);
        }
    }
};

static Pimpl& storage()
{
    static std::unique_ptr<Pimpl> instance = std::make_unique<Pimpl>();
    return *instance;
}
}
#endif

DynamicLibrariesStorage& DynamicLibrariesStorage::instance()
{
    static DynamicLibrariesStorage inst{};
    return inst;
}

DynamicLibrariesStorage& DynamicLibrariesStorage::addPath(const QString& path)
{
#ifdef Q_OS_WIN64
    AddDllDirectory(path.toStdWString().c_str());
#else
    Q_UNUSED(path);
#endif
    return instance();
}

DynamicLibrariesStorage& DynamicLibrariesStorage::load(const QString& name)
{
#ifdef Q_OS_WIN64
    auto stdStr = (name + ".dll").toStdString();
    HMODULE module = LoadLibraryEx(stdStr.c_str(), NULL, LOAD_LIBRARY_SEARCH_USER_DIRS);
    if(module == NULL)
    {
        //for some reason "DSNAPI.DLL" doesnt load via LoadLibraryEx, dunno why, so here is fallback
        module = LoadLibrary(stdStr.c_str());
    }
    if(module != NULL)
    {
        storage().modules.insert(name, module);
    }
    else
    {
        std::cerr << "Failed to load " << stdStr << ", application may not work as expected" << std::endl;
    }
#else
    Q_UNUSED(name);
#endif
    return instance();
}

DynamicLibrariesStorage& DynamicLibrariesStorage::resolve(LazyDynamicFunctionBase& func)
{
#ifdef Q_OS_WIN64
    auto module = storage().modules.value(func.library, NULL);
    if(module != NULL)
    {
        func.handle = reinterpret_cast<void*>(GetProcAddress(module, func.name));
    }
#else
    Q_UNUSED(func);
#endif
    return instance();
}

LazyDynamicFunctionBase::LazyDynamicFunctionBase(const char* name, const char* libraryName)
    : name{name}
    , library{libraryName}
    , handle{nullptr}
{}

bool LazyDynamicFunctionBase::isResolved()
{
    return handle != nullptr;
}
