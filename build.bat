@echo off

setlocal EnableDelayedExpansion

set SRC=yoga
set SRC_CMAKE=%CD%\%SRC%
set BIN=%SRC%\build_shared_odin

if not exist "%SRC%" (
    git clone --depth=1 https://github.com/facebook/yoga "%SRC%" || exit /b 1
)

echo Configuring build...
cmake -S "cmake" -B "%BIN%" -A x64 -DCMAKE_BUILD_TYPE=Release -DYOGA_LIBRARY_TYPE=SHARED -DYOGA_SOURCE_DIR="%SRC_CMAKE%" || exit /b 1

echo Building project...
cmake --build "%BIN%" --config Release || exit /b 1

if exist "%BIN%\Release\yoga.dll" (
    copy /y "%BIN%\Release\yoga.dll" yoga.dll >nul || exit /b 1
) else if exist "%BIN%\yoga.dll" (
    copy /y "%BIN%\yoga.dll" yoga.dll >nul || exit /b 1
) else (
    echo ERROR: Could not find yoga.dll output
    exit /b 1
)

if exist "%BIN%\Release\yoga.lib" (
    copy /y "%BIN%\Release\yoga.lib" yoga.lib >nul || exit /b 1
) else if exist "%BIN%\yoga.lib" (
    copy /y "%BIN%\yoga.lib" yoga.lib >nul || exit /b 1
) else (
    echo ERROR: Could not find yoga.lib output
    exit /b 1
)

echo Build completed successfully!
