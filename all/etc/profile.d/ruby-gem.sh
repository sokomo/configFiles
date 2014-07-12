# Begin /etc/profile.d/qt.sh
   
RUBY_GEM_PATH=$(ruby -rubygems -e "puts Gem.user_dir") 
pathappend ${RUBY_GEM_PATH}/bin           PATH

   
# End /etc/profile.d/qt.sh
