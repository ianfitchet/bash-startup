
require path-functions

_uname ()
{
    typeset __uname
    __uname=( $(uname -mrps) )

    OS="${__uname[0]}"
    REV="${__uname[1]}"

    case "${OS}" in
    SunOS)
	ARCH="${__uname[3]}"
	;;
    Linux)
	ARCH="${__uname[4]}"
	;;
    esac
}

_uname

case "${OS}" in
SunOS)
    std_paths append /usr

    typeset d
    for d in opt usr ; do
	if [[ -d /${d}/sfw ]] ; then
	    std_paths append /${d}/sfw
	fi
    done

    export OPENWINHOME=/usr/openwin
    std_paths append ${OPENWINHOME}
    std_paths append /usr/dt

    std_paths append /usr/local

    if [[ -d /usr/local/emacs-23.1 ]] ; then
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
