
case "${OS_NAME}" in
SunOS)
    typeset dists
    dists=( /usr/local/tcl* )
    if [[ -d "${dists[0]}" ]] ; then
	dists=( $(order "${dists[@]##*-}") )
	std_paths -d append /usr/local/tcl${dists[0]}

	FEATURE_DESCRIPTION="use TCL from /usr/local/tcl${dists[0]}"
    fi
    ;;
*)
    FEATURE_DESCRIPTION="(Solaris)"
    ;;
esac

provide tcl

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
