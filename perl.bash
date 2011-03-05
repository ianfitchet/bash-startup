
case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/perl-* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d prepend /usr/local/perl-${dists[0]}

	FEATURE_DESCRIPTION="use perl from /usr/local/perl-${dists[0]}"
	FEATURE_VERSION="${dists[0]}"
    fi

    # perl has good stuff in its bin directory which Sun don't copy to /usr/bin...

    case "$(type -p perl)" in
    /usr/bin/perl)
	typeset perl_root
	perl_root=$(perl -MConfig -e 'print $Config{prefixexp};')
	std_paths append $perl_root
	
	FEATURE_DESCRIPTION="${FEATURE_DESCRIPTION:+${FEATURE_DESCRIPTION}; }add Perl's bin directory to the PATH"
	;;
    esac

    if type -p perl >/dev/null 2>&1 ; then
	{
	    typeset l v
	    read l
	    read v
	    
	    v="${v##*perl, v}"
	    v="${v%% *}"
	    FEATURE_VERSION="${v}"
	} < <(perl -v)
    fi
    ;;
*)
    FEATURE_DESCRIPTION="(Solaris)"
    ;;
esac

provide perl

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
