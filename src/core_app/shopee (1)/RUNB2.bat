@echo off
chcp 65001 >nul
title ShopeeWeb - Build & Run
color 0A

echo ============================================
echo    SHOPEE WEB - AUTO BUILD ^& RUN
echo ============================================
echo.

cd /d "%~dp0src\core_app"
set "CATALINA_HOME=%cd%\tomcat_dir\apache-tomcat-10.1.19"

:: 1. Tắt Tomcat cũ (nếu đang chạy)
echo [1/4] Đang tắt Tomcat cũ...
call "tomcat_dir\apache-tomcat-10.1.19\bin\shutdown.bat" >nul 2>&1
timeout /t 3 /nobreak >nul
echo      ✓ Đã tắt Tomcat cũ

:: 2. Build project
echo.
echo [2/4] Đang build project (mvn package)...
call C:\maven\bin\mvn.cmd clean package -q
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo ╔══════════════════════════════════════╗
    echo ║   ✗ BUILD THẤT BẠI! Kiểm tra lỗi   ║
    echo ╚══════════════════════════════════════╝
    pause
    exit /b 1
)
echo      ✓ Build thành công!

:: 3. Deploy WAR
echo.
echo [3/4] Đang deploy WAR vào Tomcat...
copy /Y "target\shopee-web-1.0-SNAPSHOT.war" "tomcat_dir\apache-tomcat-10.1.19\webapps\ROOT.war" >nul
echo      ✓ Deploy thành công!

:: 4. Khởi động Tomcat
echo.
echo [4/4] Đang khởi động Tomcat...
echo.
echo ============================================
echo    ✓ Server đang chạy tại:
echo    http://localhost:8080/home
echo ============================================
echo    Nhấn Ctrl+C để tắt server
echo ============================================
echo.

call "tomcat_dir\apache-tomcat-10.1.19\bin\catalina.bat" run
