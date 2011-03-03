
case "${OS_NAME}-${OS_REVISION[1]}" in
SunOS-10)
    std_paths -d append /usr/local/mercurial-1.7.5
    ;;
esac

provide mercurial

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
