set(HEADERS DynamicGuiController.h)
set(SOURCES DynamicGuiController.cpp)

add_library(DynamicGui ${HEADERS} ${SOURCES})
add_library(DynamicGui::DynamicGui ALIAS DynamicGui)

target_link_libraries(DynamicGui PUBLIC
                      Qt5::Core
                      Qt5::Core
                      Qt5::QuickControls2
                      Qt5::Qml
                      Qt5::Widgets
                      Qt5::Quick
                      Qt5::QuickWidgets
                      Qt5::Gui
                      Qt5::QmlWorkerScript
                      zmq)
if(CMAKE_BUILD_TYPE MATCHES Release)
    target_compile_definitions(DynamicGui PUBLIC ZMQ_STATIC)

    target_link_libraries(DynamicGui
                          PUBLIC
                          rpcrt4
                          wsock32
                          ws2_32
                          sodium
                          iphlpapi)
endif()

target_include_directories(DynamicGui PUBLIC .)
