
require path-functions

case "${OS_NAME}" in
SunOS)
    std_paths append /usr

    typeset d
    for d in opt usr ; do
	std_paths -d append /${d}/sfw
    done

    case "${OS_REVISION[1]}" in
    4|6|7|8|9|10)
	export OPENWINHOME=/usr/openwin
	std_paths append ${OPENWINHOME}
	std_paths append /usr/dt
	;;
    *)
	std_paths append /usr/X11R6
	;;
    esac

    std_paths append /usr/local

    require emacs

    ;;
Linux)
    std_paths append /usr

    std_paths prepend /usr/local
    
    std_paths append /usr/X11R6
    ;;
esac

provide bash_profile
