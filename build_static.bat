@echo off

setlocal EnableDelayedExpansion

set SRC=yoga
set SRC_CMAKE=%CD%\%SRC%
set BIN=%SRC%\build_static_odin

if not exist "%SRC%" (
    git clone --revision cfdacac0e3c2e91ab15939027688756271a66025 --depth=1 https://github.com/facebook/yoga "%SRC%" || exit /b 1
)

echo Configuring build...
cmake -S "cmake" -B "%BIN%" -A x64 -DCMAKE_BUILD_TYPE=Release -DYOGA_LIBRARY_TYPE=STATIC -DYOGA_SOURCE_DIR="%SRC_CMAKE%" || exit /b 1

echo Building project...
cmake --build "%BIN%" --config Release || exit /b 1

if exist "%BIN%\Release\yoga.lib" (
    copy /y "%BIN%\Release\yoga.lib" yoga_static.lib >nul || exit /b 1
) else if exist "%BIN%\yoga.lib" (
    copy /y "%BIN%\yoga.lib" yoga_static.lib >nul || exit /b 1
) else (
    echo ERROR: Could not find static yoga.lib output
    exit /b 1
)

echo Build completed successfully!
