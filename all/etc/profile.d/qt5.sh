# Begin /etc/profile.d/qt.sh

QT5DIR="/opt/qt-5"

pathappend /opt/qt-5/bin           PATH
pathappend /opt/qt-5/lib/pkgconfig PKG_CONFIG_PATH

export QT5DIR

# End /etc/profile.d/qt.sh
