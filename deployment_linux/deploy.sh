exe_path=${1:-./build/bin/ProTouchApiSimulator}
qmake_path=${2:-$(which qmake)}
repo_path=$(dirname "$0")/../
linuxdeployqt $exe_path -unsupported-allow-new-glibc -verbose=2 -bundle-non-qt-libs -always-overwrite -qmldir=$repo_path -qmake=$qmake_path
