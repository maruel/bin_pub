@echo off
setlocal
:: Works around WARNING: Terminal is not fully functional
set TERM=msys
"C:\Program Files (x86)\Git\cmd\git" %*
