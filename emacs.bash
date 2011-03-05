case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/emacs-* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d prepend /usr/local/emacs-${dists[0]}

	FEATURE_DESCRIPTION="use emacs from /usr/local/emacs-${dists[0]}"
	FEATURE_VERSION="${dists[0]}"
    fi
    ;;
*)
    FEATURE_DESCRIPTION="(Solaris)"
    ;;
esac

provide emacs

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
