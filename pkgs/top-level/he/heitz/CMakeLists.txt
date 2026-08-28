cmake_minimum_required(VERSION 3.16)
project(heitz VERSION 1.0.0 LANGUAGES CXX
    DESCRIPTION "Heitz et al. SIGGRAPH 2019 blue-noise sampler tables")

set(SPP "256" CACHE STRING "samples per pixel variant (1/2/4/8/16/32/64/128/256)")

set(src "samplerBlueNoiseErrorDistribution_128x128_OptimizedFor_2d2d2d2d_${SPP}spp.cpp")

# promote the three data arrays from file-local `static const int`
# to externally-linked `extern const int` so consumers can reference them.
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/${src}" content)
string(REPLACE "static const int" "extern const int" content "${content}")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/patched.cpp" "${content}")

add_library(heitz SHARED "${CMAKE_CURRENT_BINARY_DIR}/patched.cpp")
target_compile_features(heitz PRIVATE cxx_std_14)
target_compile_options(heitz PRIVATE -O3)
target_include_directories(heitz PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

install(TARGETS heitz EXPORT heitzTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(FILES heitz/heitz.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/heitz)
install(EXPORT heitzTargets
    FILE heitzTargets.cmake
    NAMESPACE heitz::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/heitz
)

configure_package_config_file(
    heitz-config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/heitz-config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/heitz
)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/heitz-config.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/heitz
)
