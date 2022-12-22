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
    feature_description="Emacs"
    ;;
esac

if type -p emacs >/dev/null 2>&1 ; then
    {
	typeset v
	read v

	feature_description="${v% *}"
	feature_version="${v##* }"
    } < <(emacs --version | head -1)
fi

provide emacs "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
