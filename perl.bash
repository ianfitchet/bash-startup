
case "${OS_NAME}" in
SunOS)
    # perl has good stuff in its bin directory...
    perl_root=$(perl -MConfig -e 'print $Config{prefixexp};')
    std_paths append $perl_root
    ;;
esac

provide perl

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: iso-latin-1-unix
# End:
