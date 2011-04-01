case "${OS_NAME}" in
SunOS)
    typeset dists prefix

    prefix=/usr/local/sbcl-

    dists=( ${prefix}* )
    dists=( $(order "${dists[@]##*-}") )

    typeset i
    for ((i=0; i < ${#dists[*]}; i++)) ; do
	if [[ -d "${prefix}${dists[i]}" ]] ; then
	    std_paths -d append ${prefix}${dists[i]}
	    export SBCL_HOME=${prefix}${dists[i]}/lib/sbcl

	    feature_description="use SBCL from ${prefix}${dists[i]}"
	    feature_version="${dists[i]}"
	    break
	fi
    done
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
