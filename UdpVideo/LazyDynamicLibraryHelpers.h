#pragma once

#include <utility>
#include <vector>
#include <QString>


template<typename>
struct LazyDynamicFunction;

struct LazyDynamicFunctionBase
{
    LazyDynamicFunctionBase(const char* name, const char* libraryName);
    void resolve();
    bool isResolved();
    const char* name;
    const char* library;
    void* handle;
};

template<typename Ret, typename...Args>
struct LazyDynamicFunction<Ret(Args...)> : LazyDynamicFunctionBase
{
    using LazyDynamicFunctionBase::LazyDynamicFunctionBase;
    Ret operator()(Args... args)
    {
        return reinterpret_cast<Ret(*)(Args...)>(handle)(std::forward<Args>(args)...);
    }
};

struct DynamicLibrariesStorage
{
    DynamicLibrariesStorage& addPath(const QString&);
    DynamicLibrariesStorage& load(const QString&);
    DynamicLibrariesStorage& resolve(LazyDynamicFunctionBase&);
    static DynamicLibrariesStorage& instance();
private:
    DynamicLibrariesStorage() = default;
};
