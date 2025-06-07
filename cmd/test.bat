@echo off
chcp 65001 > nul

@REM 当前路径
set _work=%~dp0
echo path is:%_work:~,3%

@REM 脚本完整路径
set "_batf=%~f0"
echo %_batf%


setlocal EnableDelayedExpansion
set "count=1"
for %%i in (1 2 3) do (
  set "count=%%i"
  echo Count is: !count!
)


@REM @echo off
@REM setlocal EnableDelayedExpansion
@REM set /p input=Enter a number: 
@REM set "result=%input% doubled is !input!*2"
@REM set /a calc=!input!*2
@REM echo %result%
@REM echo Result with calculation: !calc!
@REM endlocal

@REM set var=helloword
@REM set "new=%var:~,4%"
@REM echo %new%



set variable=helloworld
set "newvar=%variable:hello=cpp%"

echo %newvar%
