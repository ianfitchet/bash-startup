
case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/perl-* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d prepend /usr/local/perl-${dists[0]}
    fi

    # perl has good stuff in its bin directory...

    case "$(type -p perl)" in
    /usr/local/perl-*)
	typeset perl_root
	perl_root=$(perl -MConfig -e 'print $Config{prefixexp};')
	std_paths append $perl_root
	;;
    esac
    ;;
esac

provide perl

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
