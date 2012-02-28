#!/bin/bash

# update cadabra!
# auto-update rvm( + rubygems & gems), rubygems (+ gems), macports (+ ports), homebrew formulas, textmate bundles -- pain-free!
# IMPORTANT: don't forget to run chmod u+x in this file before execute

if [ "$(whoami)" = 'root' ]; then
  echo "Ooops! Don't run this script with sudo (some tools may need your enviroment variables to be correctly updated)"
  exit 1
fi

sudo echo "" # just to get sudo access and don't bother you later :)

# find the dir of this script
SCRIPT_PATH="${BASH_SOURCE[0]}";
if([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null

if which -s port
then
	echo "==> update macports, ports, clean outdated ports and uninstall inactive ports"
	sudo -E port -q selfupdate
	sudo -E port -q -d sync > /dev/null
	sudo -E port -u -q upgrade installed
	#sudo -E port -f uninstall inactive (-u option in the previous line do this)
	#sudo -E port clean --all installed - this isn't enough?
	sudo -E port -f -p -q clean --all installed
	rm -rf PortIndex PortIndex.quick
fi

if which -s brew
then
	echo "==> update homebrew formulas"
	brew update > /dev/null
fi

if which -s gem
then
	echo "==> update rubygems and update the gems"
	gem update -q --system > /dev/null
	gem update -q > /dev/null
	gem cleanup -q
fi

if which -s rvm
then
	echo "==> update rvm, rubygems and update the gems"
	rvm get head > /dev/null
	rvm do gem update -q --system > /dev/null
	rvm do gem update -q > /dev/null
	rvm all do gem cleanup -q
fi

if [ -d ~/Library/Application\ Support/TextMate/Bundles ]
then
	echo "==> update textmate bundles"
	cd ~/Library/Application\ Support/TextMate/Bundles
	ls | while read bundle; do
		if [ -d "${bundle}/.git" ]
		then
			echo " > ${bundle}"
			cd "${bundle}"
			# git doesnt allow me to do a git pull outside the dir (or the man page is a huge #fail)
			git pull -q
			cd ..
		fi
	done
fi

popd > /dev/null