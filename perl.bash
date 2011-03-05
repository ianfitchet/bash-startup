
case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/perl-* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d prepend /usr/local/perl-${dists[0]}

	feature_description="use perl from /usr/local/perl-${dists[0]}"
	feature_version="${dists[0]}"
    fi

    # perl has good stuff in its bin directory which Sun don't copy to /usr/bin...

    case "$(type -p perl)" in
    /usr/bin/perl)
	typeset perl_root
	perl_root=$(perl -MConfig -e 'print $Config{prefixexp};')
	std_paths append $perl_root
	
	feature_description="${feature_description:+${feature_description}; }add Perl's bin directory to the PATH"
	;;
    esac
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

if type -p perl >/dev/null 2>&1 ; then
    {
	typeset l v
	read l
	read v
	
	v="${v##*perl, v}"
	v="${v%% *}"
	feature_version="${v}"
    } < <(perl -v)
fi

provide perl "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
