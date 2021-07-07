
set(PROCESSOR_IS_MIPS FALSE)
set(PROCESSOR_IS_ARM FALSE)
set(PROCESSOR_IS_AARCH64 FALSE)
set(PROCESSOR_IS_X86 FALSE)
set(PROCESSOR_IS_POWER FALSE)

if(CMAKE_SYSTEM_PROCESSOR MATCHES "^mips")
  set(PROCESSOR_IS_MIPS TRUE)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^arm")
  set(PROCESSOR_IS_ARM TRUE)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^aarch64")
  set(PROCESSOR_IS_AARCH64 TRUE)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(x86_64)|(AMD64|amd64)|(^i.86$)")
  set(PROCESSOR_IS_X86 TRUE)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(powerpc|ppc)")
  set(PROCESSOR_IS_POWER TRUE)
endif()

# Possiblities for CMAKE_SYSTEM_NAME
# CMAKE_SYSTEM_NAME may have version information in front or behind the name of the system
# You can match a regex to check the name like this: .*NAME.*

# Darwin, iOS, tvOS, watchOS
# Linux
# HPUX
# Android
# NaCl
# Integrity
# VxWorks
# QNX
# OpenBSD, kOpenBSD
# FreeBSD, kFreeBSD, DragonFly
# NetBSD, kNetBSD
# Emscripten
# SunOS
# SYSV5
# BSDI
# Solaris
# AIX
# Minix
# BeOS (not supported by SDL, bad sign)
# Haiku

# Predefined variables you can query for platform checks

# UNIX
# ANDROID
# BORLAND
# CYGWIN
# IOS
# MINGW
# WIN32
# WINCE
# WINDOWS_PHONE
# APPLE
# WINDOWS_STORE
# RISCOS
# EMSCRIPTEN
# MSYS
# XCODE