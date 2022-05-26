for /f "tokens=*" %%a in ('git rev-parse --short HEAD') do set revision=%%a
echo import QtQuick 2.0; Text { text:'%revision%'} > CommonItems/Version.qml
