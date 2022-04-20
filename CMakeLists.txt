project(ProTouchApiSimulator)
cmake_minimum_required(VERSION 3.12.0)

set(HEADERS
	messagegenerator.h
	tcpclient.h)
	
	
set(SOURCES
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

include(Cache.cmake)

find_package(Qt5 COMPONENTS Widgets Qml Quick REQUIRED)

add_subdirectory(DynamicGui)
	
add_executable(ProTouchApiSimulator
               main.cpp
               ${SOURCES}
               ${HEADERS}
               ${QRC_FILES})

target_link_libraries(ProTouchApiSimulator
                      PUBLIC
                      Qt5::Core
                      Qt5::Qml
                      Qt5::Widgets
                      Qt5::Quick
                      DynamicGui::DynamicGui
                      )

target_include_directories(ProTouchApiSimulator PUBLIC ./)

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR})

install(TARGETS ProTouchApiSimulator
        CONFIGURATIONS Release
        RUNTIME DESTINATION release)
