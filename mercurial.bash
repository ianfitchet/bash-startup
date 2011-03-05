case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/mercurial-* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d prepend /usr/local/mercurial-${dists[0]}

	feature_description="use hg from /usr/local/mercurial-${dists[0]}"
	feature_version="${dists[0]}"
    fi
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

if type -p hg >/dev/null 2>&1 ; then
    typeset v
    read v <<< $(hg --version)
    v="${v##*version }"
    v="${v%%)*}"
    feature_version="${v}"
fi

provide mercurial "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
