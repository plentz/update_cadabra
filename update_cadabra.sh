#!/bin/bash

# update cadabra!
# auto-update rubygems + gems + macports + ports + textmate bundles, pain-free!
# IMPORTANT: don't forget to run chmod u+x in this file before execute

# *1 since a lot of gems depends on older versions of other gems, dont cleanup stuff

if [ "$(whoami)" = 'root' ]; then
  echo "Ooops! Don't run this script with sudo (some tools may need your enviroment to be correctly updated)"
  exit 1
fi

if which -s port
then
	echo "==> update macports, ports, clean outdated ports and uninstall inactive ports"
	sudo -E port -q selfupdate
	sudo -E port -q -d sync
	sudo -E port -u -q upgrade installed
	#sudo -E port -f uninstall inactive (-u option in the previous line do this)
	#sudo -E port clean --all installed - this isn't enough?
	sudo -E port -f -p -q clean --all installed
fi

if which -s gem
then
	echo "==> update rubygems and update the gems"
	gem update -q --system
	gem update -q
	#gem cleanup -q # see *1
fi

if which -s rvm
then
if [[ -s $HOME/.rvm/scripts/rvm ]] ; then 
        source $HOME/.rvm/scripts/rvm
fi

	echo "==> update rvm, rubygems and update the gems"
	rvm update
	rvm reload
	rvm gem update -q --system
	rvm gem update -q
	#rvm gem cleanup -q #see *1
fi

if [ -d ~/Library/Application\ Support/TextMate/Bundles ]
then
	echo "==> update textmate bundles"
	cd ~/Library/Application\ Support/TextMate/Bundles
	ls | while read fn; do
		if [ -d "${fn}/.git" ]
		then
			echo "> ${fn}"
			cd "${fn}"
			# git doesnt allow me to do a git pull outside the dir (or the man page is a huge #fail)
			git pull -q
			cd ..
		fi
	done
fi