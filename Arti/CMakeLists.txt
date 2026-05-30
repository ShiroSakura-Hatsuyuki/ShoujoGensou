cmake_minimum_required(VERSION 4.2)

project(Arti LANGUAGES CXX)

#CoreArti
add_library(CoreArti STATIC)
file(GLOB_RECURSE COREARTI_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/CoreArti/Source/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/CoreArti/Include/*.hxx"
)
target_sources(CoreArti PRIVATE ${COREARTI_SOURCES})
target_include_directories(CoreArti PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CoreArti/Include>
    $<INSTALL_INTERFACE:include>
)
target_compile_features(CoreArti PUBLIC cxx_std_20)


#安装配置
include(GNUInstallDirs)
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/LibraryArti" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_BINDIR "bin" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_LIBDIR "lib" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_INCLUDEDIR "include" CACHE PATH "" FORCE)

install(TARGETS CoreArti
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
install(DIRECTORY CoreArti/Include/
    DESTINATION include/Arti
    FILES_MATCHING PATTERN "*.hxx"
)