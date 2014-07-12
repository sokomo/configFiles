# Begin /etc/profile.d/qt.sh
   
QTDIR="/opt/qt-4"
   
pathappend /opt/qt-4/bin           PATH
pathappend /opt/qt-4/lib/pkgconfig PKG_CONFIG_PATH
   
export QTDIR
   
# End /etc/profile.d/qt.sh
