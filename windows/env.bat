:: Copyright 2015 Rouslan Solomakhin
::
:: Licensed under the Apache License, Version 2.0 (the "License")
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

set ALTERNATE_EDITOR=emacs.exe
set EDITOR=gvim.exe
set GYP_DEFINES=component=shared_library fastbuild=2 disable_nacl=1 disable_pnacl=1
set GYP_GENERATORS=ninja
set HOME=%USERPROFILE%
set JAVA_HOME=%SYSTEMDRIVE%\java\jdk
set GOPATH=%SYSTEMDRIVE%\src\go

doskey e=start /b emacsclient.exe $*
doskey v=start /b gvim.exe $*

if not "%PATH%" == "%PATH:depot_tools=%" (
  goto skip_path
)

for /d %%g in (%SYSTEMDRIVE%\src\depot_tools\git*chromium*) do set PATH=%PATH%;%%g\cmd
set PATH=%PATH%;%GOPATH%\bin
set PATH=%PATH%;%HOME%\.third_party\cask\bin
set PATH=%PATH%;%JAVA_HOME%\bin
set PATH=%PATH%;%SYSTEMDRIVE%\console2
set PATH=%PATH%;%SYSTEMDRIVE%\emacs\bin
set PATH=%PATH%;%SYSTEMDRIVE%\Go\bin
set PATH=%PATH%;%SYSTEMDRIVE%\go_appengine
set PATH=%PATH%;%SYSTEMDRIVE%\maven\bin
set PATH=%PATH%;%SYSTEMDRIVE%\src\depot_tools
set PATH=%PATH%;%SYSTEMDRIVE%\vim

:skip_path

where cl > NUL 2>&1
if errorlevel 1 (
  if exist "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" (
    call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
  )
)

if not exist c:\src\depot_tools\win_toolchain\vs2013_files (
  set DEPOT_TOOLS_WIN_TOOLCHAIN=0
)

if exist local-env.bat (
  call local-env.bat
)
