cmake_minimum_required(VERSION 3.16)

project(Mini_Toolkit VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(FLUENTUI_BUILD_EXAMPLES OFF)
set(FLUENTUI_BUILD_FRAMELESSHEPLER OFF)
set(QRC_FILE resource.qrc)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTODLL ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appMini_Toolkit
    src/main.cpp
    src/component/Launcher.cpp
    src/component/Launcher.h
    src/component/Clicker.cpp
    src/component/Clicker.h
    src/component/RandintGenerator.cpp
    src/component/RandintGenerator.h
    src/component/DataModel.h
    src/component/DataModel.cpp
    resource.qrc
    icon.rc
)

qt_add_qml_module(appMini_Toolkit
    URI Mini_Toolkit
    VERSION 1.0
    QML_FILES main.qml
    RESOURCES resource.qrc
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMini_Toolkit PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMini_Toolkit
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMini_Toolkit
    PRIVATE Qt6::Quick
    fluentuiplugin
    FramelessHelper::Core
    FramelessHelper::Quick
)

include(GNUInstallDirs)
install(TARGETS appMini_Toolkit
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

add_subdirectory(FluentUI)
add_subdirectory(framelesshelper)
