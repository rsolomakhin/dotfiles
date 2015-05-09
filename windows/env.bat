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

set EDITOR=runemacs
set GYP_DEFINES="component=shared_library fastbuild=2"
set GYP_GENERATORS=ninja
set HOME=%USERPROFILE%
set PATH=%PATH%;%SYSTEMDRIVE%\emacs\bin;%SYSTEMDRIVE%\console2;%SYSTEMDRIVE%\src\depot_tools;%USERPROFILE%\.third_party\cask\bin;%SYSTEMDRIVE%\java\jdk\bin;%SYSTEMDRIVE%\maven\bin
call "%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"
