case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/mercurial-* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d prepend /usr/local/mercurial-${dists[0]}

	FEATURE_DESCRIPTION="use hg from /usr/local/mercurial-${dists[0]}"
    fi
    ;;
*)
    FEATURE_DESCRIPTION="(Solaris)"
    ;;
esac

provide mercurial

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
