@echo off
rem 设置当前控制台为UTF-8编码
chcp 65001 >> nul

:: [原理 1] @echo off 用于关闭命令本身的回显，仅输出结果，相当于 Bash 中的 set +x 的效果（但更彻底）

:: [原理 2] %~dp0 是批处理中的特殊变量，d 代表驱动器，p 代表路径，0 代表脚本自身
:: 它能确保无论你在哪里调用该脚本，都会切换到脚本文件所在的物理目录
cd /d "%~dp0"
echo 处理路径: %cd%
call flutter clean

call flutter pub get

::pause
:: 加上 pause 可以防止脚本执行完后窗口立即关闭，方便查看输出结果