
case "${OS}" in
SunOS)
    std_paths prepend /usr/local/tcl8.5.8
    ;;
esac

provide tcl

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
