case "${OS_NAME}" in
SunOS)

    sbcl_setup ()
    {
	typeset dist="$1"

    	std_paths -d prepend ${prefix}${dist}
	export SBCL_HOME=${prefix}${dist}/lib/sbcl

	feature_description="use SBCL from ${prefix}${dist}"
	feature_version="${dist}"
    }

    newest_release /usr/local/sbcl- sbcl_setup
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

provide sbcl "${feature_description}" "${feature_version}"
unset feature_description feature_version dists prefix

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
