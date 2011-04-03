case "${OS_NAME}" in
SunOS)
    emacs_setup ()
    {
	typeset dist="$1"

	std_paths -d prepend ${prefix}${dist}

	feature_description="use emacs from ${prefix}${dist}"
	feature_version="${dist}"
    }

    newest_release /usr/local/emacs- emacs_setup
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

provide emacs "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
