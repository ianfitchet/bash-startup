
require path-functions

_uname ()
{
    set -- $(uname -mrps)
    OS="$1"
    REV="$2"

    case "${OS}" in
    SunOS)
	ARCH="$4"
	;;
    Linux)
	ARCH="$3"
	;;
    esac
}

_uname

case "${OS}" in
SunOS)
    std_paths append /usr

    typeset d
    for d in opt usr ; do
	if [ -d /${d}/sfw ] ; then
	    std_paths append /${d}/sfw
	fi
    done

    export OPENWINHOME=/usr/openwin
    std_paths append ${OPENWINHOME}
    std_paths append /usr/dt

    std_paths append /usr/local

    if [ -d /usr/local/emacs-23.1 ] ; then
	std_paths append /usr/local/emacs-23.1
    fi

    ;;
Linux)
    std_paths append /usr
    path_append MANPATH /usr/share/man

    std_paths prepend /usr/local
    
    std_paths append /usr/X11R6
    ;;
esac

provide bash_profile
