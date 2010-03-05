#!/bin/bash

# update cadabra!
# update MacPorts + RubyGems in a single line
# IMPORTANT: don't forget to run chmod u+x in this file before execute

if [ "$(whoami)" != 'root' ]; then
  echo "Ooops! You must be root to run this script (or call this script using: sudo $0)"
  exit 1
fi

if which -s port
then
	echo "==> update MacPorts"
	port selfupdate
	echo "==> update and clean outdated ports"
	port -d sync
	portindex
	port upgrade installed
	echo "==> uninstalling inactive ports"
	port -f uninstall inactive
	#port clean --all installed - this isn't enough?
	port -f -p clean --all installed
fi

if which -s gem
then
	echo "==> update RubyGems"
	gem update -q --system
	echo "==> update and clean outdated gems"
	gem update -q
	gem cleanup -q
fi

if [ -d ~/Library/Application\ Support/TextMate/Bundles ]
then
	echo "==> update TextMate Bundles"
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