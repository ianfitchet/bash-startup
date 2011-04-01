
case "${OS_NAME}" in
SunOS)
    typeset dists prefix

    prefix=/usr/local/tcl


    dists=( ${prefix}* )
    dists=( $(order "${dists[@]##*tcl}") )

    typeset i
    for ((i=0; i < ${#dists[*]}; i++)) ; do
	if [[ -d "${prefix}${dists[i]}" ]] ; then
	    std_paths -d append ${prefix}${dists[i]}

	    feature_description="use TCL from ${prefix}${dists[i]}"
	    feature_version="${dists[i]}"
	    break
	fi
    done
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

provide tcl "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
