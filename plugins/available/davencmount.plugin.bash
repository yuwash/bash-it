cite 'about-plugin'
about-plugin 'mount davfs2 and encfs as configured in ~/.davencmount'

function _mounted () {
	if ! [[ -z $2 ]]
	then echo _mounted ignoring surplus arguments $2 ..
	fi
	line=`grep "$1" /etc/mtab` && echo already mounted: $line
}


function davencmount () {
	about 'mount as configured in ~/.davencmount'
	example '$ davencmount mytarget'
	group 'davencmount'

	unmount=''
	for target in "$@"
	do if [[ $target = -u ]]
	then
		unmount='yes'
	else if [[ -z $unmount ]]
	then 
		grep "^$target\>" $HOME/.davencmount | while read entry
		do etmp="`envsubst <<<"$entry"`" && read -a earr <<<"$etmp"
			if [[ -z "${earr[1]}" ]]
			then echo error at $entry; return 1
			fi
			if [[ "${earr[1]}" = encfs ]]
			then _mounted "${earr[-1]}" || { encfs ${earr[@]:2} < /dev/tty; }
			else _mounted "${earr[-1]}" || { mount ${earr[@]:1} < /dev/tty; }
			fi || { 
				ret=$?
				echo failed at $target ${earr[@]:1}
				return $?
			}
		done
	else
		grep "^$target\>" $HOME/.davencmount | tac - | while read entry
		do etmp="`envsubst <<<"$entry"`" && read -a earr <<<"$etmp"
			if [[ -z "${earr[1]}" ]]
			then echo error at $entry; return 1
			fi
			if [[ "${earr[1]}" = encfs ]]
			then _mounted "${earr[-1]}" && { fusermount -u "${earr[-1]}" < /dev/tty; }
			else _mounted "${earr[-1]}" && { fusermount -u "${earr[-1]}" < /dev/tty; }
			fi || echo skipping unmounting possibly failed $target ${earr[-1]}
		done
	fi
	unmount=''
	fi
	done
}
