set(HEADERS DynamicGuiController.h)
set(SOURCES DynamicGuiController.cpp)

add_library(DynamicGui ${HEADERS} ${SOURCES})
add_library(DynamicGui::DynamicGui ALIAS DynamicGui)

target_link_libraries(DynamicGui PUBLIC Qt5::Core zmq)

target_include_directories(DynamicGui PUBLIC .)
