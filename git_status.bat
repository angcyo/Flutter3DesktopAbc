@echo off
rem 设置当前控制台为UTF-8编码
chcp 65001 >> nul

git remote -v
git status

set "coreFolder=Flutter3Core"
echo "%CD%\%coreFolder%\"
IF EXIST "%CD%\%coreFolder%\" (
    cd %coreFolder%
    git remote -v
    git status
    cd ..
)

set "extendFolder=Flutter3Extend"
echo "%CD%\%extendFolder%\"
IF EXIST "%CD%\%extendFolder%\" (
    cd %extendFolder%
    git remote -v
    git status
    cd ..
)

set "desktopFolder=Flutter3Desktop"
echo "%CD%\%desktopFolder%\"
IF EXIST "%CD%\%desktopFolder%\" (
    cd %desktopFolder%
    git remote -v
    git status
    cd ..
)

set "abcFolder=Flutter3Abc"
IF EXIST "%CD%\%abcFolder%\" (
    cd %abcFolder%
    git remote -v
    git status
    cd ..
)

echo "结束"
rem pause