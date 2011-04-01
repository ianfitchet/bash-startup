
case "${OS_NAME}" in
SunOS)
    typeset dists prefix

    prefix=/usr/local/perl-

    dists=( ${prefix}* )
    dists=( $(order "${dists[@]##*-}") )

    typeset i
    for ((i=0; i < ${#dists[*]}; i++)) ; do
	if [[ -d "${prefix}${dists[i]}" ]] ; then
	    std_paths -d prepend ${prefix}${dists[i]}

	    feature_description="use perl from ${prefix}${dists[i]}"
	    feature_version="${dists[i]}"
	    break
	fi
    done

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
