cite 'about-plugin'
about-plugin 'Bash history save and synchronization'

# quick way to synchronize history with other bash sessions
# from https://superuser.com/a/602405
function histsync () {
	about 'save and synchronize history'
	example '$ histsync'
	group 'histsync'

	history -a && history -c && history -r
}
