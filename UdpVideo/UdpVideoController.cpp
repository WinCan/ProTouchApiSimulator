#include "UdpVideoController.h"
#include <windows.h>
#include <libloaderapi.h>
#include <QFile>
#include <iostream>
#include <QCoreApplication>

namespace
{
extern "C"
{
enum GstState
{
    GST_STATE_NULL = 1,
    GST_STATE_PLAYING = 4
};
enum GstStateChangeReturn
{
    last = 3
};

using GstElement = void;
using GError = void;
int (*gst_init)(int*,char***) = nullptr;
GstElement* (*gst_parse_launch)(const char*, GError**) = nullptr;
GstStateChangeReturn (*gst_element_set_state)(GstElement*, GstState) = nullptr;
void (*gst_object_unref)(void*) = nullptr;
} //extern C
} //anon ns

void check(const char* dll)
{
    if(NULL == LoadLibraryEx(dll, NULL, LOAD_LIBRARY_SEARCH_USER_DIRS))
    {
        auto error = GetLastError();
        std::cerr << "Failed to load: " << dll << " : " << error << std::endl;
    }
}

struct UdpVideoController::Pimpl
{
    Pimpl()
    {
        if(QFile::exists("./bin/libgstreamer-1.0-0.dll"))
        {
            auto actualPath = QCoreApplication::applicationDirPath().replace('/', '\\').toStdWString();
            AddDllDirectory((actualPath + L"\\bin\\").c_str());
            AddDllDirectory((actualPath + L"\\lib\\gstreamer-1.0\\").c_str());

            loadLibrary("libintl-8.dll");
            loadLibrary("ADVAPI32.dll");
            loadLibrary("dnsapi.dll");
            loadLibrary("IPHLPAPI.DLL");
            loadLibrary("KERNEL32.dll");
            loadLibrary("msvcrt.dll");
            loadLibrary("ole32.dll");
            loadLibrary("SHELL32.dll");
            loadLibrary("SHLWAPI.dll");
            loadLibrary("USER32.dll");
            loadLibrary("WS2_32.dll");
            loadLibrary("zlib1.dll");
            loadLibrary("libglib-2.0-0.dll");
            loadLibrary("libgmodule-2.0-0.dll");
            loadLibrary("libgobject-2.0-0.dll");
            loadLibrary("libgstvideotestsrc.dll");
            loadLibrary("libgstcoreelements.dll");
            loadLibrary("libglib-2.0-0.dll");
            loadLibrary("libgstbase-1.0-0.dll");
            loadLibrary("liborc-0.4-0.dll");
            loadLibrary("libgstvideo-1.0-0.dll");
            loadLibrary("libgstx264.dll");
            loadLibrary("libgstvideoparsersbad.dll");
            loadLibrary("libgstrtp.dll");
            loadLibrary("libgstudp.dll");

            gstreamerHandle = loadLibrary("libgstreamer-1.0-0.dll");

            if(gstreamerHandle != NULL)
            {
#define RESOLVE(name) name = reinterpret_cast<decltype(name)>(GetProcAddress(gstreamerHandle, #name))
                RESOLVE(gst_init);
                RESOLVE(gst_parse_launch);
                RESOLVE(gst_element_set_state);
                RESOLVE(gst_object_unref);
#undef RESOLVE
                gst_init(nullptr, nullptr);
            }
        }
    }
    void startPipeline(const QString& beginning, const QString& ip, const QString& port)
    {
        auto pipeline = beginning +
                        " is-live=true do-timestamp=true "
                        "! autovideoconvert "
                        "! queue leaky=downstream "
                        "! x264enc tune=zerolatency "
                        "! h264parse "
                        "! rtph264pay pt=96 "
                        "! udpsink host=" + ip + " port=" + port;
        gstPipeline = gst_parse_launch(pipeline.toStdString().c_str(), nullptr);
        gst_element_set_state(gstPipeline, GST_STATE_PLAYING);
    }

    void stop()
    {
        if(gstPipeline != nullptr)
        {
            gst_element_set_state(gstPipeline, GST_STATE_NULL);
            gst_object_unref(gstPipeline);
            gstPipeline = nullptr;
        }
    }

    bool hasGstreamer()
    {
        return gstreamerHandle != NULL;
    }
    HMODULE WINAPI gstreamerHandle = NULL;
    GstElement* gstPipeline = nullptr;
    HMODULE loadLibrary(const char* dllName)
    {
        HMODULE module = LoadLibraryEx(dllName, NULL, LOAD_LIBRARY_SEARCH_USER_DIRS);
        if(module == NULL)
        {
            //for some reason "DSNAPI.DLL" doesnt load via LoadLibraryEx, dunno why, so here is fallback
            module = LoadLibrary(dllName);
        }
        if(module != NULL)
        {
            loadedDlls.push_back(module);
        }
        else
        {
            std::cerr << "Failed to load " << dllName << ", application may not work as expected" << std::endl;
        }
        return module;
    }
    std::vector<HMODULE> loadedDlls;
    ~Pimpl()
    {
        for(HMODULE module : loadedDlls)
        {
            FreeLibrary(module);
        }
    }
};

UdpVideoController::UdpVideoController(QObject* parent)
    : QObject(parent)
{
    pimpl = std::make_unique<Pimpl>();
}

void UdpVideoController::startPipeline(const QString &beginning, const QString& ip, const QString& port)
{
    return pimpl->startPipeline(beginning, ip, port);
}

void UdpVideoController::stop()
{
    return pimpl->stop();
}

bool UdpVideoController::hasGstreamer()
{
    return pimpl->hasGstreamer();
}

UdpVideoController::~UdpVideoController() = default;
