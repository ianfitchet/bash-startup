
case "${OS_NAME}" in
SunOS)
    std_paths -d append /opt/SUNWspro
    std_paths append /usr/ccs

    feature_description="add Sun compilers to the PATH"
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

provide compilers "${feature_description}"
unset feature_description

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
