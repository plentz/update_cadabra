## update_cadabra

update_cadabra is an update script for rvm(+rubygems & gems & full cleanup), rubygems (+ gems), macports (+ ports), homebrew(update & upgrade & cleanup), textmate bundles -- pain-free!

* * *

To install (the easy way):

	gem install update_cadabra

To automagically update everything, run:

	update_cadabra
	

* * *
To install (the hard way):

	git clone git://github.com/plentz/update_cadabra.git
	cd update_cadabra
	chmod u+x bin/update_cadabra.sh
	sudo ln -s "`pwd`/bin/update_cadabra.sh" /usr/local/bin/update_cadabra