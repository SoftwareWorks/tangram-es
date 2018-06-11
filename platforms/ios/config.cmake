add_definitions(-DTANGRAM_IOS)
# target_compile_definitions(tangram-core PUBLIC TANGRAM_IOS)

set(IOS_PLATFORM "OS")
set(IOS_DEVICE_ARCHS "armv7 arm64")
set(IOS_SIMULATOR_ARCHS "x86_64")
set(IOS_TARGET_VERSION "9.3")

include(cmake/iOS.toolchain.cmake)

set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "")
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO")
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "")
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO")
set(CMAKE_XCODE_ATTRIBUTE_SUPPORTED_PLATFORMS "iphonesimulator iphoneos")
set(CMAKE_XCODE_ATTRIBUTE_VALID_ARCHS "${IOS_ARCH}")
set(CMAKE_XCODE_ATTRIBUTE_ARCHS "${IOS_ARCH}")
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "${IOS_TARGET_VERSION}")

# Tell SQLiteCpp to not build its own copy of SQLite, we will use the system library instead.
set(SQLITECPP_INTERNAL_SQLITE OFF CACHE BOOL "")

# target_add_framework(tangram-core CoreFoundation)
# target_add_framework(tangram-core CoreGraphics)
# target_add_framework(tangram-core UIKit)
# target_add_framework(tangram-core GLKit)
