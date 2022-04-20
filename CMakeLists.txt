project(ProTouchApiSimulator)

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
