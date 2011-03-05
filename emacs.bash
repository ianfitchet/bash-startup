case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/emacs-* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d prepend /usr/local/emacs-${dists[0]}

	feature_description="use emacs from /usr/local/emacs-${dists[0]}"
	feature_version="${dists[0]}"
    fi
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
