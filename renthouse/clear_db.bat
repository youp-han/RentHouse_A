@echo off
echo 기존 데이터베이스 삭제 중...
del "%USERPROFILE%\Documents\db.sqlite" 2>nul
echo 데이터베이스가 삭제되었습니다. 앱을 다시 시작하면 새 데이터베이스가 생성됩니다.
pause