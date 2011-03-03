
if flag_set_p "i" ; then
    typeset tty=$(tty)
    typeset HOST="${HOSTNAME%%.*}"

    bold=
    offattr=

    if type tput >/dev/null 2>&1 ; then
	bold="$(tput bold)"	# enter_bold_mode
	offattr="$(tput sgr0)"	# exit_attribute_mode

	# if we can't turn things off then make sure we don't turn
	# anything on in the first instance
	if [[ $? -ne 0 ]] ; then
	    bold=
	    offattr=
	fi
    fi

    typeset _up=()
    if type uptime >/dev/null 2>&1 ; then
	typeset _uptime
	_uptime=$(uptime)

        #  12:08pm  up 6 day(s), 14:44,  1 user,  load average: 0.05, 0.05, 0.05
	_uptime=${_uptime//,*}

	_up=( ${_uptime} )

        # first element is the current time
	unset _up[0]
    fi

    echo "${HOST}'s ${tty} has TERM=${bold}${TERM}${offattr} ${_up[@]+_up[@] }${DISPLAY:-no X11}"
fi
		
provide tty-info

# Local Variables:
# mode: Shell-script
# End:
