@echo off
rem 设置当前控制台为UTF-8编码
chcp 65001 >> nul

git rebase origin/main

set "coreFolder=Flutter3Core"
echo "%CD%\%coreFolder%\"
IF EXIST "%CD%\%coreFolder%\" (
    cd %coreFolder%
    echo 准备拉取仓库：%coreFolder%
    git fetch
    git rebase origin/main
    cd ..
) else (
    echo 准备克隆仓库：%coreFolder%
    git clone git@github.com:angcyo/Flutter3Core.git 
)

set "extendFolder=Flutter3Extend"
echo "%CD%\%extendFolder%\"
IF EXIST "%CD%\%extendFolder%\" (
    cd %extendFolder%
    echo 准备拉取仓库：%extendFolder%
    git fetch
    git rebase origin/main
    cd ..
) else (
    echo 准备克隆仓库：%extendFolder%
    git clone git@github.com:angcyo/Flutter3Extend.git
)

set "desktopFolder=Flutter3Desktop"
echo "%CD%\%desktopFolder%\"
IF EXIST "%CD%\%desktopFolder%\" (
    cd %desktopFolder%
    echo 准备拉取仓库：%desktopFolder%
    git fetch
    git rebase origin/main
    cd ..
) else (
    echo 准备克隆仓库：%desktopFolder%
    git clone git@github.com:angcyo/Flutter3Desktop.git
)

echo "结束"
pause