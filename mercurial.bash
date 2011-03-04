case "${OS_NAME}" in
SunOS)
    typeset dists=( /usr/local/mercurial-* )
    dists=( $(order "${dists[@]##*-}") )
    std_paths -d append /usr/local/mercurial-${dists[0]}
    ;;
esac

provide mercurial

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
