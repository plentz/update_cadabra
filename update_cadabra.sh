#!/bin/bash

# update cadabra!
# auto-update rubygems + gems + macports + ports + textmate bundles, pain-free!
# IMPORTANT: don't forget to run chmod u+x in this file before execute

if [ "$(whoami)" != 'root' ]; then
  echo "Ooops! You must be root to run this script (or call this script using: sudo $0)"
  exit 1
fi

if which -s port
then
	echo "==> update macports, ports, clean outdated ports and uninstall inactive ports"
	port selfupdate
	port -d sync
	portindex
	port upgrade installed
	port -f uninstall inactive
	#port clean --all installed - this isn't enough?
	port -f -p clean --all installed
fi

if which -s gem
then
	echo "==> update rubygems, update gems and clean outdated gems"
	gem update -q --system
	gem update -q
	gem cleanup -q
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