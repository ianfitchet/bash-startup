case "${OS_NAME}" in
SunOS)
    mercurial_setup ()
    {
	typeset dist="$1"

	std_paths -d prepend ${prefix}${dist}

	feature_description="use hg from ${prefix}${dist}"
	feature_version="${dist}"
    }

    newest_release /usr/local/mercurial- mercurial_setup
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
