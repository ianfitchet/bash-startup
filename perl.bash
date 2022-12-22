
case "${OS_NAME}" in
SunOS)

    perl_setup ()
    {
	typeset dist="$1"

	std_paths -d prepend ${prefix}${dist}

	feature_description="use perl from ${prefix}${dist}"
	feature_version="${dist}"
    }
    
    newest_release /usr/local/perl- perl_setup

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
    feature_description="n/a"
    ;;
esac

if type -p perl >/dev/null 2>&1 ; then
    {
	feature_description="Perl"
	typeset l v
	read l
	read v
	
	case "${v}" in
	*perl,*)
	    v="${v##*perl, v}"
	    v="${v%% *}"
	    ;;
	*)
	    v="${v##* (v}"
	    v="${v%%) *}"
	    ;;
	esac
	feature_version="${v}"
    } < <(perl -v)
fi

provide perl "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
