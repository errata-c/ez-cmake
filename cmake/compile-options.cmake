
set(EZ_IS_64 "$<EQUAL:${CMAKE_SIZEOF_VOID_P},8>")
set(EZ_IS_32 "$<EQUAL:${CMAKE_SIZEOF_VOID_P},4>")

set(EZ_IS_WINDOWS "$<PLATFORM_ID:Windows>")
set(EZ_IS_DARWIN "$<PLATFORM_ID:Darwin>")
set(EZ_IS_LINUX "$<PLATFORM_ID:Linux>")
set(EZ_IS_ANDROID "$<PLATFORM_ID:Android>")
set(EZ_IS_FREEBSD "$<PLATFORM_ID:FreeBSD>")
set(EZ_IS_CRAY "$<PLATFORM_ID:CrayLinuxEnvironment>")
set(EZ_IS_MSYS "$<PLATFORM_ID:MSYS>")

set(OPT "$<IF:$<CXX_COMPILER_ID:MSVC>,/,->")

set(ENV{CXX_WARN_ALL} "${OPT}Wall")

set(CXX_WARN_ERROR "")
string(APPEND CXX_WARN_ERROR "$<$<CXX_COMPILER_ID:MSVC>:/WX>")
string(APPEND CXX_WARN_ERROR "$<$<CXX_COMPILER_ID:Clang,GCC,ICC>:-Werror>")
set(CXX_WARN_ERROR "${CXX_WARN_ERROR}")

set(CXX_WARN_0 "${OPT}W0")

set(CXX_WARN_1 "${OPT}W1")

set(CXX_WARN_2 "${OPT}W2")

set(CXX_WARN_3 "${OPT}W3")

set(CXX_WARN_OFF "${OPT}w")

set(CXX_WARN_MAX "")
string(APPEND CXX_WARN_MAX "$<$<CXX_COMPILER_ID:MSVC>:/W4;/WX>")
string(APPEND CXX_WARN_MAX "$<$<CXX_COMPILER_ID:Clang,GCC,ICC>:-Wall;-Wextra;-pedantic;-Werror>")
set(ENV{CXX_WARN_MAX} "${CXX_WARN_MAX}")

set(ENV{CXX_O0} "$<IF:$<CXX_COMPILER_ID:MSVC>,/Od,-O0>")

set(ENV{CXX_O1} "${OPT}O1")

set(CXX_O2 "")
string(APPEND CXX_O2 "$<$<CXX_COMPILER_ID:MSVC>:/Ox>") # Same as /O2, just a few opts disabled.
string(APPEND CXX_O2 "$<$<CXX_COMPILER_ID:Clang,GCC,ICC>:-O2>")
set(ENV{CXX_O2} ${CXX_O2})

set(CXX_O3 "")
string(APPEND CXX_O3 "$<$<CXX_COMPILER_ID:MSVC>:/O2>") # MSVC doesn't go higher than 2
string(APPEND CXX_O3 "$<$<CXX_COMPILER_ID:Clang,GCC,ICC>:-O3>")
set(ENV{CXX_O3} ${CXX_O3})

set(ENV{CXX_Os} "${OPT}Os")

set(CXX_LTO "")
#These are all roughly the same.
string(APPEND CXX_LTO "$<$<CXX_COMPILER_ID:MSVC>:/LTCG>") # Link time code generation.
string(APPEND CXX_LTO "$<$<CXX_COMPILER_ID:Clang,GCC>:-flto>") # Link time optimization.
string(APPEND CXX_LTO "$<$<CXX_COMPILER_ID:ICC>:-ipo>") # Whole program optimization
set(ENV{CXX_LTO} ${CXX_LTO})
