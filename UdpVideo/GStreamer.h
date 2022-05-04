#pragma once

#include "LazyDynamicLibraryHelpers.h"
#include <QCoreApplication>

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

constexpr const char gst_main_lib[] = "libgstreamer-1.0-0";

LazyDynamicFunction<int(int*,char***)> gst_init("gst_init", gst_main_lib);
LazyDynamicFunction<GstElement*(const char*, GError**)> gst_parse_launch("gst_parse_launch", gst_main_lib);
LazyDynamicFunction<GstStateChangeReturn(GstElement*, GstState)> gst_element_set_state("gst_element_set_state", gst_main_lib);
LazyDynamicFunction<void(void*)> gst_object_unref("gst_object_unref", gst_main_lib);


inline void tryLoadGstreamerLibraries()
{
    DynamicLibrariesStorage::instance()
        .addPath(QCoreApplication::applicationDirPath() + "/bin/")
        .addPath(QCoreApplication::applicationDirPath() + "/lib/gstreamer-1.0/")
        .load("libintl-8")
        .load("ADVAPI32")
        .load("IPHLPAPI")
        .load("dnsapi")
        .load("kernel32")
        .load("msvcrt")
        .load("ole32")
        .load("SHELL32")
        .load("SHLWAPI")
        .load("USER32")
        .load("WS2_32")
        .load("zlib1")
        .load("libglib-2.0-0")
        .load("libgmodule-2.0-0")
        .load("libgobject-2.0-0")
        .load("libgstvideotestsrc")
        .load("libgstcoreelements")
        .load("libglib-2.0-0")
        .load("libgstbase-1.0-0")
        .load("liborc-0.4-0")
        .load("libgstvideo-1.0-0")
        .load("libgstx264")
        .load("libgstvideoparsersbad")
        .load("libgstrtp")
        .load("libgstudp")
        .load(gst_main_lib)
        .resolve(gst_init)
        .resolve(gst_parse_launch)
        .resolve(gst_element_set_state)
        .resolve(gst_object_unref)
        ;
}
