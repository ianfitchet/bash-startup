
case "${OS_NAME}" in
SunOS)
    std_paths -d prepend /usr/gnu

    gnutoolchain_setup ()
    {
	typeset dist="$1"

	std_paths -d prepend ${prefix}${dist}

	feature_description="use GNU tool chain from ${prefix}${dist}"
	feature_version="${dist}"
    }

    newest_release /usr/gcc/ gnutoolchain_setup
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

provide gnutoolchain "${feature_description}"
unset feature_description

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
