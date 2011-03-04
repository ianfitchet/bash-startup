
case "${OS_NAME}" in
SunOS)
    std_paths -d append /opt/SUNWspro
    std_paths append /usr/ccs

    FEATURE_DESCRIPTION="add Sun compilers to the PATH"
    ;;
*)
    FEATURE_DESCRIPTION="(Solaris)"
    ;;
esac

provide compilers

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
