
case "${OS_NAME}" in
SunOS)

    tcl_setup ()
    {
	typeset dist="$1"

	std_paths -d prepend ${prefix}${dist}

	feature_description="use TCL from ${prefix}${dist}"
	feature_version="${dist}"
    }

    newest_release /usr/local/tcl tcl_setup
    ;;
*)
    feature_description="n/a"
    ;;
esac

if type -p tclsh >/dev/null 2>&1 ; then
    {
	feature_description="Tcl"
	typeset v
	read v

	feature_version="${v}"
    } < <(tclsh <<<"puts \$tcl_version")
fi

provide tcl "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
