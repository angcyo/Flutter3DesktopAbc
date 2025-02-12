@echo off
rem 设置当前控制台为UTF-8编码
chcp 65001 >> nul

rem Building Windows application...                                   165.0s
rem √ Built build\windows\x64\runner\Release\flutter3_desktop_abc_bn.exe
dart run Flutter3Core/script/build_config.dart & flutter build windows --release