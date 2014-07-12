LFS_INSTALLATION_DIR=$1
#LFS_BOOTSCRIPT_DIR=$2
#INSTALLATION_SCRIPT_DIR=$3


PATCH_DIR_LFS=$LFS_INSTALLATION_DIR/patch


echo "Install Main system 01"



# Install gmp
PACKAGE_INSTALL_NAME="gmp"
PACKAGE_VERSION="5.1.3"
echo "Expanding $PACKAGE_INSTALL_NAME ..."
tar -xf $LFS_INSTALLATION_DIR/$PACKAGE_INSTALL_NAME*
pushd $PACKAGE_INSTALL_NAME*


echo "Configure and build $PACKAGE_INSTALL_NAME ..."
./configure --prefix=/usr --enable-cxx
make


echo "Installing $PACKAGE_INSTALL_NAME ..."
make install

rm -rf /usr/share/doc/gmp
mkdir -pv /usr/share/doc/gmp
cp    -rfv doc/{isa_abi_headache,configuration} doc/*.html \
         /usr/share/doc/gmp


popd

echo "Removing $PACKAGE_INSTALL_NAME installation directory..."
rm -rf $PACKAGE_INSTALL_NAME*

# -----------------------------------------------------


# Install mpfr
PACKAGE_INSTALL_NAME="mpfr"
PACKAGE_VERSION="3.1.2"
echo "Expanding $PACKAGE_INSTALL_NAME ..."
tar -xf $LFS_INSTALLATION_DIR/$PACKAGE_INSTALL_NAME*
pushd $PACKAGE_INSTALL_NAME*

rm -rf /usr/share/doc/mpfr

echo "Configure and build $PACKAGE_INSTALL_NAME ..."
./configure  --prefix=/usr        \
             --enable-thread-safe \
             --docdir=/usr/share/doc/mpfr
make


echo "Installing $PACKAGE_INSTALL_NAME ..."
make install

make html
make install-html


popd

echo "Removing $PACKAGE_INSTALL_NAME installation directory..."
rm -rf $PACKAGE_INSTALL_NAME*

# -----------------------------------------------------


# Install mpc
PACKAGE_INSTALL_NAME="mpc"
echo "Expanding $PACKAGE_INSTALL_NAME ..."
tar -xf $LFS_INSTALLATION_DIR/$PACKAGE_INSTALL_NAME*
pushd $PACKAGE_INSTALL_NAME*


echo "Configure and build $PACKAGE_INSTALL_NAME ..."
./configure --prefix=/usr
make


echo "Installing $PACKAGE_INSTALL_NAME ..."
make install


popd

echo "Removing $PACKAGE_INSTALL_NAME installation directory..."
rm -rf $PACKAGE_INSTALL_NAME*

# -----------------------------------------------------


# Install gcc
PACKAGE_INSTALL_NAME="gcc"
PACKAGE_VERSION="4.8.2"
echo "Expanding $PACKAGE_INSTALL_NAME ..."
tar -xf $LFS_INSTALLATION_DIR/$PACKAGE_INSTALL_NAME*
pushd $PACKAGE_INSTALL_NAME*


echo "Configure and build $PACKAGE_INSTALL_NAME ..."
case `uname -m` in
  i?86) sed -i 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in ;;
esac

sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in

sed -i -e /autogen/d -e /check.sh/d fixincludes/Makefile.in 
mv -v libmudflap/testsuite/libmudflap.c++/pass41-frag.cxx{,.disable}

mkdir -v ../gcc-build
cd ../gcc-build

../gcc-${PACKAGE_VERSION}/configure --prefix=/usr               \
                       --libexecdir=/usr/lib       \
                       --enable-shared             \
                       --enable-threads=posix      \
                       --enable-__cxa_atexit       \
                       --enable-clocale=gnu        \
                       --enable-languages=c,c++,fortran    \
                       --disable-bootstrap         \
                       --disable-install-libiberty \
                       --enable-lto                \
                       --enable-multilib           \
                       --with-system-zlib
make


echo "Installing $PACKAGE_INSTALL_NAME ..."
make install


echo "Config gcc ..."
# ln -sfv /usr/bin/cpp /lib
# ln -sfv gcc /usr/bin/cc

# echo 'main(){}' > dummy.c
# cc dummy.c -v -Wl,--verbose &> dummy.log
# readelf -l a.out | grep ': /lib'

# grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

# grep -B4 '^ /usr/include' dummy.log

# grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

# grep "/lib.*/libc.so.6 " dummy.log

# grep found dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib


popd

echo "Removing $PACKAGE_INSTALL_NAME installation directory..."
rm -rf $PACKAGE_INSTALL_NAME*

# -----------------------------------------------------


