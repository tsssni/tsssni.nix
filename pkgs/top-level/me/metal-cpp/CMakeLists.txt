cmake_minimum_required(VERSION 4.0.0)
project(metal-cpp VERSION 26)

install(DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR}/Foundation
    ${CMAKE_CURRENT_SOURCE_DIR}/Metal
    ${CMAKE_CURRENT_SOURCE_DIR}/MetalFX
    ${CMAKE_CURRENT_SOURCE_DIR}/QuartzCore
    DESTINATION include
)

add_library(metal-cpp INTERFACE)

target_include_directories(metal-cpp INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
)

find_library(METAL_FRAMEWORK Metal REQUIRED)
find_library(FOUNDATION_FRAMEWORK Foundation REQUIRED)
find_library(QUARTZCORE_FRAMEWORK QuartzCore REQUIRED)

target_link_libraries(metal-cpp INTERFACE
    ${METAL_FRAMEWORK}
    ${FOUNDATION_FRAMEWORK}
    ${QUARTZCORE_FRAMEWORK}
)

install(
    TARGETS metal-cpp
    EXPORT metal-cpp-targets
)

install(
    EXPORT metal-cpp-targets
    FILE metal-cpp-targets.cmake
    NAMESPACE apple::
    DESTINATION lib/cmake/metal-cpp
)

include(CMakePackageConfigHelpers)

configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/metal-cpp-config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/metal-cpp-config.cmake
    INSTALL_DESTINATION lib/cmake/metal-cpp
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/metal-cpp-version.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/metal-cpp-config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/metal-cpp-version.cmake
    DESTINATION lib/cmake/metal-cpp
)
