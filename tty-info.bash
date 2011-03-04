
if flag_set_p "i" ; then
    typeset tty=$(tty)
    typeset HOST="${HOSTNAME%%.*}"

    bold=
    offattr=

    tty_effect ()
    {
	typeset effect="tty_effect_$1"
	shift

	echo "${!effect}$@${tty_effect_offattr}"
    }
    
    if type tput >/dev/null 2>&1 ; then
	typeset effect effects
	effects=( blink bold dim sitm rev invis smso ssubm ssupm smul )

	typeset ei maxei
	maxei=${#effects[*]}

	for ((ei=0; ei < maxei; ei++)) ; do
	    typeset e
	    if e="$(tput ${effects[ei]})" ; then
		read tty_effect_${effects[ei]} <<< "$e"
	    else
		unset effects[ei]
	    fi
	done

	# if we can't turn things off then make sure we don't turn
	# anything on in the first instance
	if ! tty_effect_offattr="$(tput sgr0)" ; then
	    for effect in "${effects[@]}" ; do
		unset tty_effect_${effect}
	    done
	    unset tty_effect_offattr
	else
	    typeset fd
	    fd=

	    for effect in "${effects[@]}" ; do
		fd="${fd:+${fd}/}$(tty_effect ${effect} ${effect})"
	    done
	    FEATURE_DESCRIPTION="tty attributes: ${fd}"
	fi
    fi

    typeset _up
    _up=()
    if type uptime >/dev/null 2>&1 ; then
	typeset _uptime
	_uptime=$(uptime)

        #  12:08pm  up 6 day(s), 14:44,  1 user,  load average: 0.05, 0.05, 0.05
	_uptime=${_uptime//,*}

	_up=( ${_uptime} )

        # first element is the current time
	unset _up[0]
    fi

    echo "${HOST}'s ${tty} has TERM=${bold}${TERM}${tty_effect_offattr} ${_up[@]+${_up[@]} }${DISPLAY:-no X11}"
else
    FEATURE_DESCRIPTION="(interactive only)"
fi

provide tty-info

# Local Variables:
# mode: Shell-script
# End:
