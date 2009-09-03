#!/bin/bash

# update cadabra!
# update MacPorts + RubyGems in a single line
# IMPORTANT: don't forget to run chmod u+x in this file before execute

if [ "$(whoami)" != 'root' ]; then
  echo "Ooops! You must be root to run this script (or call this script using: sudo $0)"
  exit 1
fi

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

echo "==> update RubyGems"
gem update --system
echo "==> update and clean outdated gems"
gem update
gem cleanup