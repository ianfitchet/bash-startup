
if flag_set_p "i" ; then
    tty=$(tty)
    HOST="${HOSTNAME%%.*}"
    bold="$(tput bold)"		# enter_bold_mode
    offattr="$(tput sgr0)"	# exit_attribute_mode

    # if we can't turn things off then make sure we don't turn
    # anything on in the first instance
    if [ $? -ne 0 ] ; then
	bold=""
	offattr=""
    fi

    set -- $(uptime | sed -e 's/,.*//')
    shift

    echo "${HOST}'s ${tty} has TERM=${bold}${TERM}${offattr} $* ${DISPLAY:-no X11}"
fi
		
provide tty-info

# Local Variables:
# mode: Shell-script
# End:
