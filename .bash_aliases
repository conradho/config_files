# alias definitions
alias c='clear'
alias l='clear; ls -ABhl'
# could do ls | less, but then won't have color
alias helper='cd ~/Documents/helper/helper; l'
alias coho='cd ~/Documents/coho_website/coho; l'
alias jae='cd ~/Documents/bigcentric/bigcentric; l'
alias notes='cd ~/Documents/notes; l'
alias util='cd ~/Documents/shared_platform/utilities; l'
alias bill='cd ~/Documents/bill/bigcentric; l'
alias online='g ~/Documents/python_online/python_online'
alias aws2='ssh cho@ec2-184-72-238-1.compute-1.amazonaws.com'
alias aws='ssh cho@184.72.238.1'
alias restart='sudo service apache2 restart'
alias error='sudo bash -c "cd /var/log/apache2; clear; ls -al; bash"'
# might need sudo for this
alias windows='cd /media/OS/Users/coho; l'
alias gsm='gnome-system-monitor'
# to open pdf etc
alias open='gnome-open'
# show only folders not files
alias ldir="l | grep '^d'"



# alias/functions

# to debug, run with -D and -V
function v () {
	if [ $(vim --serverlist | grep COHO) ]; then
		vim --servername COHO --remote $1
	else
		vim --servername COHO $1
	fi
}


# works for both relative and absolute references
function g () {
	cd "$1";
	l;
}


# put the following line into /etc/inputrc
# to make bash case insensitive
# set completion-ignore-case on
