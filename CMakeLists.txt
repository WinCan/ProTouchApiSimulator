project(ProTouchApiSimulator)
cmake_minimum_required(VERSION 3.12.0)

set(HEADERS
	PluginLoader.h
	messagegenerator.h
	tcpclient.h)
	
	
set(SOURCES
	PluginLoader.cpp
	messagegenerator.cpp
	tcpclient.cpp)

set(QRC_FILES
	CommonItems.qrc
	Design.qrc
	qml.qrc)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -s")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -s")
set(CMAKE_CXX_STANDARD 17)

include(Cache.cmake)

find_package(Qt5 COMPONENTS Widgets Qml Quick QmlImportScanner QuickControls2 Gui QuickWidgets QmlWorkerScript REQUIRED)

add_subdirectory(DynamicGui)
add_subdirectory(UdpVideo)

execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE PT_API_GIT_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
file(WRITE CommonItems/Version.qml "import QtQuick 2.0; Text { text:'${PT_API_GIT_VERSION}'}")
	
add_executable(ProTouchApiSimulator
               WIN32
               main.cpp
               ${SOURCES}
               ${HEADERS}
               ${QRC_FILES})

target_link_libraries(ProTouchApiSimulator
                      PUBLIC
                      Qt5::Core
                      Qt5::QuickControls2
                      Qt5::Qml
                      Qt5::Widgets
                      Qt5::Quick
                      Qt5::QuickWidgets
                      Qt5::Gui
                      Qt5::QmlWorkerScript
                      DynamicGui::DynamicGui
                      UdpVideo::UdpVideo)


if(CMAKE_BUILD_TYPE MATCHES Release)
    if(WIN32)
        target_link_libraries(ProTouchApiSimulator
                              PUBLIC
                              -static
                              -static-libgcc
                              -static-libstdc++
                              z
                              zstd)
    endif()
endif()


target_include_directories(ProTouchApiSimulator PUBLIC ./)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/build/bin)

install(TARGETS ProTouchApiSimulator
        CONFIGURATIONS Release
        RUNTIME DESTINATION release)

qt5_import_qml_plugins(ProTouchApiSimulator)
