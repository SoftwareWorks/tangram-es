include(cmake/iOS.toolchain.cmake)

set(ARCH "armv7 arm64 x86_64")
set(SUPPORTED_PLATFORMS "iphonesimulator iphoneos")
set(TANGRAM_FRAMEWORK ${PROJECT_SOURCE_DIR}/${TANGRAM_FRAMEWORK})
set(FRAMEWORKS CoreGraphics CoreFoundation CoreLocation QuartzCore UIKit OpenGLES Security CFNetwork GLKit)

# NB:cmake versions before 3.9.0 had an issue where the path specified for MACOSX_FRAMEWORK_LOCATION
# was prepended by "../" when set to something other than "Resources" which is what we require here.
# Refer: https://gitlab.kitware.com/cmake/cmake/issues/16680 for the actual cmake issue
if(${CMAKE_VERSION} VERSION_LESS "3.9.0")
  set(MACOSX_FRAMEWORK_LOCATION ${EXECUTABLE_NAME}.app/Frameworks)
else()
  set(MACOSX_FRAMEWORK_LOCATION Resources/Frameworks)
endif()

message(STATUS "Linking with Tangram Framework: ${TANGRAM_FRAMEWORK}")
message(STATUS "Building for architectures: ${ARCH}")

get_nextzen_api_key(NEXTZEN_API_KEY)
add_definitions(-DNEXTZEN_API_KEY="${NEXTZEN_API_KEY}")

# Generate demo app configuration plist file to inject API key
configure_file("${PROJECT_SOURCE_DIR}/platforms/ios/demo/Config.plist.in"
  "${PROJECT_SOURCE_DIR}/platforms/ios/demo/resources/Config.plist"
)

add_bundle_resources(IOS_DEMO_RESOURCES "${PROJECT_SOURCE_DIR}/platforms/ios/demo/resources/" "Resources")

add_executable(tangram MACOSX_BUNDLE
  platforms/ios/demo/src/AppDelegate.m
  platforms/ios/demo/src/main.m
  platforms/ios/demo/src/MapViewController.m
  ${IOS_DEMO_RESOURCES}
  ${TANGRAM_FRAMEWORK}
)

target_link_libraries(tangram ${TANGRAM_FRAMEWORK})

# setting xcode properties
set_target_properties(tangram PROPERTIES
  MACOSX_BUNDLE_INFO_PLIST "${PROJECT_SOURCE_DIR}/platforms/ios/demo/Info.plist"
  MACOSX_FRAMEWORK_IDENTIFIER "com.mapzen.tangram"
  RESOURCE ${IOS_DEMO_RESOURCES}
)

set_source_files_properties(${TANGRAM_FRAMEWORK} PROPERTIES
  MACOSX_PACKAGE_LOCATION ${MACOSX_FRAMEWORK_LOCATION})

if(NOT ${CMAKE_BUILD_TYPE} STREQUAL "Release")
  set_xcode_property(tangram GCC_GENERATE_DEBUGGING_SYMBOLS YES)
endif()

set_xcode_property(tangram CODE_SIGN_IDENTITY "iPhone Developer")
set_xcode_property(tangram SUPPORTED_PLATFORMS ${SUPPORTED_PLATFORMS})
set_xcode_property(tangram ONLY_ACTIVE_ARCH "YES")
set_xcode_property(tangram VALID_ARCHS "${ARCH}")
set_xcode_property(tangram TARGETED_DEVICE_FAMILY "1,2")
set_xcode_property(tangram LD_RUNPATH_SEARCH_PATHS "@executable_path/Frameworks")

foreach(_framework ${FRAMEWORKS})
  add_framework(${_framework} tangram ${CMAKE_SYSTEM_FRAMEWORK_PATH})
endforeach()
