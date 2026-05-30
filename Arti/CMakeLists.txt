cmake_minimum_required(VERSION 4.2)

project(Arti LANGUAGES CXX)

add_subdirectory(Rely-on/SDL3)

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

#Arti
add_library(Arti STATIC)
file(GLOB_RECURSE ARTI_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/Arti/Source/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/Arti/Include/*.hxx"
)
target_sources(Arti PRIVATE ${ARTI_SOURCES})
target_include_directories(Arti PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Arti/Include>
    $<INSTALL_INTERFACE:include>
)
target_compile_features(Arti PUBLIC cxx_std_20)
target_link_libraries(Arti PRIVATE CoreArti SDL3::SDL3)


#installation Configuration
include(GNUInstallDirs)
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/LibraryArti" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_BINDIR "bin" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_LIBDIR "lib" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_INCLUDEDIR "include" CACHE PATH "" FORCE)

#CoreArti
install(TARGETS CoreArti
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
install(DIRECTORY CoreArti/Include/
    DESTINATION include/Arti
    FILES_MATCHING PATTERN "*.hxx"
)

#Arti
install(TARGETS Arti
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
install(DIRECTORY Arti/Include/
    DESTINATION include/Arti
    FILES_MATCHING PATTERN "*.hxx"
)