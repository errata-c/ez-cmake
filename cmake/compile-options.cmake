
set(ENV{IS_64} "$<EQUAL:${CMAKE_SIZEOF_VOID_P},8>")
set(ENV{IS_32} "$<EQUAL:${CMAKE_SIZEOF_VOID_P},4>")

set(ENV{IS_WINDOWS} "$<PLATFORM_ID:Windows>")
set(ENV{IS_DARWIN} "$<PLATFORM_ID:Darwin>")
set(ENV{IS_LINUX} "$<PLATFORM_ID:Linux>")
set(ENV{IS_ANDROID} "$<PLATFORM_ID:Android>")
set(ENV{IS_FREEBSD} "$<PLATFORM_ID:FreeBSD>")
set(ENV{IS_CRAY} "$<PLATFORM_ID:CrayLinuxEnvironment>")
set(ENV{IS_MSYS} "$<PLATFORM_ID:MSYS>")


set(DASH_OPT "$<OR:$<CXX_COMPILER_ID:Clang,GCC>,$<AND:${IS_WINDOWS},$<CXX_COMPILER_ID:ICC>>>")


set(ENV{CXX_WARN_ALL} "$<IF:${DASH_OPT},-Wall,/Wall>")

set(CXX_WARN_ERROR "")
string(APPEND CXX_WARN_ERROR "$<$<CXX_COMPILER_ID:MSVC>:/WX>")
string(APPEND CXX_WARN_ERROR "$<$<CXX_COMPILER_ID:Clang,GCC>:-Werror>")
string(APPEND CXX_WARN_ERROR "$<$<CXX_COMPILER_ID:ICC>:$<IF:$<PLATFORM_ID:WINDOWS>,/Werror,-Werror>>")
set(ENV{CXX_WARN_ERROR} "${CXX_WARN_ERROR}")

set(ENV{CXX_WARN_0} "$<IF:${DASH_OPT},-W0,/W0>")

set(ENV{CXX_WARN_1} "$<IF:${DASH_OPT},-W1,/W1>")

set(ENV{CXX_WARN_2} "$<IF:${DASH_OPT},-W2,/W2>")

set(ENV{CXX_WARN_3} "$<IF:${DASH_OPT},-W3,/W3>")

set(ENV{CXX_WARN_OFF} "$<IF:${DASH_OPT},-w,/w>")

set(CXX_WARN_MAX "")
string(APPEND CXX_WARN_MAX "$<$<CXX_COMPILER_ID:MSVC>:/W4;/WX>")
string(APPEND CXX_WARN_MAX "$<$<CXX_COMPILER_ID:Clang,GCC>:-Wall;-Wextra;-pedantic;-Werror>")
string(APPEND CXX_WARN_MAX "$<$<CXX_COMPILER_ID:ICC>:$<IF:$<PLATFORM_ID:WINDOWS>,/Wall;/Wextra;/pedantic;/Werror,-Wall;-Wextra;-pedantic;-Werror>>")
set(ENV{CXX_WARN_MAX} "${CXX_WARN_MAX}")

set(ENV{CXX_O0} "$<IF:${DASH_OPT},-O0,/Od>")

set(ENV{CXX_O1} "$<IF:${DASH_OPT},-O1,/O1>")

set(CXX_O2 "")
string(APPEND CXX_O2 "$<$<CXX_COMPILER_ID:MSVC>:/Ox>") # Same as /O2, just a few opts disabled.
string(APPEND CXX_O2 "$<$<CXX_COMPILER_ID:Clang,GCC>:-O2>")
string(APPEND CXX_O2 "$<$<CXX_COMPILER_ID:ICC>:$<IF:$<PLATFORM_ID:WINDOWS>,/O2,-O2>>")
set(ENV{CXX_O2} ${CXX_O2})

set(CXX_O3 "")
string(APPEND CXX_O3 "$<$<CXX_COMPILER_ID:MSVC>:/O2>") # MSVC doesn't go higher than 2
string(APPEND CXX_O3 "$<$<CXX_COMPILER_ID:Clang,GCC>:-O3>")
string(APPEND CXX_O3 "$<$<CXX_COMPILER_ID:ICC>:$<IF:$<PLATFORM_ID:WINDOWS>,/O3,-O3>>")
set(ENV{CXX_O3} ${CXX_O3})

set(ENV{CXX_Os} "$<IF:${DASH_OPT},-Os,/Os>")

set(CXX_LTO "")
#These are all roughly the same.
string(APPEND CXX_LTO "$<$<CXX_COMPILER_ID:MSVC>:/LTCG>") # Link time code generation.
string(APPEND CXX_LTO "$<$<CXX_COMPILER_ID:Clang,GCC>:-flto>") # Link time optimization.
string(APPEND CXX_LTO "$<$<CXX_COMPILER_ID:ICC>:$<IF:$<PLATFORM_ID:WINDOWS>,/Qipo,-ipo>>") # Whole program optimization
set(ENV{CXX_LTO} ${CXX_LTO})
