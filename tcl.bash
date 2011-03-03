
case "${OS_NAME}" in
SunOS)
    std_paths -d append /usr/local/tcl8.5.8
    ;;
esac

provide tcl

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
