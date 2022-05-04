set(HEADERS
    UdpVideoController.h
    LazyDynamicLibraryHelpers.h
    GStreamer.h
    )
set(SOURCES
    UdpVideoController.cpp
    LazyDynamicLibraryHelpers.cpp
    )

add_library(UdpVideo ${HEADERS} ${SOURCES})
add_library(UdpVideo::UdpVideo ALIAS UdpVideo)

target_link_libraries(UdpVideo PUBLIC Qt5::Core)
