
if flag_set_p "i" ; then
    typeset tty=$(tty)
    typeset HOST="${HOSTNAME%%.*}"

    tty_effect ()
    {
	typeset effect="tty_effect_$1"
	shift

	echo "${!effect}$@${tty_effect_offattr}"
    }
    
    if type tput >/dev/null 2>&1 ; then
	typeset colour colours
	colours=( black red green yellow blue magenta cyan white )

	typeset cattr cattrs
	cattrs=( setaf setab )

	typeset ci maxci
	maxci=${#cattrs[*]}

	for ((ci=0; ci < maxci; ci++)) ; do
	    typeset e effectname
	    capname="${cattrs[ci]}"

	    # FreeBSD's terminfo(1) manpage knows about the "modern"
	    # capnames but uses the older Tcapnames.
	    case "${OS_NAME}" in
		FreeBSD)
		    case "${capname}" in
			setaf) capname=AF ;;
			setab) capname=AB ;;
		    esac
		    ;;
	    esac

	    typeset colouri
	    for ((colouri=0; colouri < ${#colours[*]}; colouri++)) ; do
		colour=${colours[colouri]}
		if e="$(tput ${capname} ${colouri})" ; then

		    case "${cattrs[ci]}" in
		    setaf) effectname=${colour} ;;
		    setab) effectname=bg_${colour} ;;
		    esac

		    read tty_effect_${effectname} <<< "$e"
		else
		    unset cattrs[ci]
		fi
	    done
	done

	typeset effect effects
	effects=( blink bold dim sitm rev invis smso ssubm ssupm smul )

	typeset ei maxei
	maxei=${#effects[*]}

	for ((ei=0; ei < maxei; ei++)) ; do
	    typeset e
	    capname="${effects[ei]}"

	    # FreeBSD's terminfo(1) manpage knows about the "modern"
	    # capnames but uses the older Tcapnames.
	    case "${OS_NAME}" in
		FreeBSD)
		    case "${capname}" in
			blink) capname=mb ;;
			bold)  capname=md ;;
			dim)   capname=mh ;;
			sitm)  capname=ZH ;;
			rev)   capname=mr ;;
			invis) capname=mk ;;
			smso)  capname=so ;;
			ssubm) capname=ZN ;;
			ssupm) capname=ZO ;;
			smul)  capname=us ;;
		    esac
		    ;;
	    esac
	    if e="$(tput ${capname})" ; then
		read tty_effect_${effects[ei]} <<< "$e"
	    else
		unset effects[ei]
	    fi
	done

	# if we can't turn things off then make sure we don't turn
	# anything on in the first instance
	capname=sgr0
	case "${OS_NAME}" in
	    FreeBSD)
		capname=me
		;;
	esac
	if ! tty_effect_offattr="$(tput ${capname})" ; then
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

	    typeset cfd
	    cfd=
	    for colour in "${colours[@]}" ; do
		cfd="${cfd:+${cfd}/}$(tty_effect ${colour} ${colour})"
	    done
	    feature_description="tty attributes: ${fd} ${cfd}"
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

    typeset display
    if [[ $DISPLAY ]] ; then
	display="$(tty_effect bg_magenta $(tty_effect white ${DISPLAY}))"
    else
	display="$(tty_effect red $(tty_effect bold no X11))"
    fi
    echo "${HOST}'s ${tty} has TERM=$(tty_effect bold ${TERM}) ${_up[@]+${_up[@]} }${display}"
else
    feature_description="(interactive only)"
fi

provide tty-info "${feature_description}"
unset feature_description

# Local Variables:
# mode: Shell-script
# End:
