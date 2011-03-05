
case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/tcl* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*tcl}") )
	std_paths -d append /usr/local/tcl${dists[0]}

	feature_description="use TCL from /usr/local/tcl${dists[0]}"
	feature_version="${dists[0]}"
    fi
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
