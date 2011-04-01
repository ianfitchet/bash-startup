case "${OS_NAME}" in
SunOS)
    typeset dists prefix

    prefix=/usr/local/mercurial-

    dists=( ${prefix}* )
    dists=( $(order "${dists[@]##*-}") )

    typeset i
    for ((i=0; i < ${#dists[*]}; i++)) ; do
	if [[ -d "${prefix}${dists[i]}" ]] ; then
	    std_paths -d prepend ${prefix}${dists[i]}

	    feature_description="use hg from ${prefix}${dists[i]}"
	    feature_version="${dists[i]}"
	    break
	fi
    done
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
