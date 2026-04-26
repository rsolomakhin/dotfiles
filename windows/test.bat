:: Copyright 2026 Rouslan Solomakhin
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

@echo off
setlocal

:: Setup a sandbox directory for testing.
if not exist C:\temp_sandbox mkdir C:\temp_sandbox
set USERPROFILE=C:\temp_sandbox

:: Run the installation script.
call %~dp0install.bat --name "Test User" --email "test@example.com" ^
  || (echo "Installation failed" && exit /b 1)

:: Verify the outcomes.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Content %~dp0expected_outcomes.txt | ForEach-Object { if (-not (Test-Path $_)) { throw \"Missing: $_\" } }" || (echo "Verification failed" && exit /b 1)

echo [Test] Verifying Vim configuration...
:: Run vim in silent Ex mode (-es) to avoid interactive prompts.
:: -u ensures we use the sandboxed config.
:: --cmd ensures the runtimepath is correct before the config is loaded.
vim -u %USERPROFILE%\.vimrc --cmd "set rtp+=%USERPROFILE%\vimfiles" -es -c "redir! > %USERPROFILE%\vim_messages | messages | qall!"
findstr /I "error" %USERPROFILE%\vim_messages && (
  echo [Error] Vim reported errors during startup:
  type %USERPROFILE%\vim_messages
  exit /b 1
)

echo [Test] Verifying Vim warning for missing coc.vim...
del %USERPROFILE%\vimfiles\coc.vim
vim -u %USERPROFILE%\.vimrc --cmd "set rtp+=%USERPROFILE%\vimfiles" -es -c "redir! > %USERPROFILE%\vim_warning | messages | qall!"
findstr /C:"Warning: ~/vimfiles/coc.vim not found. Please run windows\install.bat again." %USERPROFILE%\vim_warning || (
  echo [Error] Vim failed to warn about missing coc.vim
  exit /b 1
)

echo Test passed successfully.
endlocal
