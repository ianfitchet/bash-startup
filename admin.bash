
case "${OS}" in
SunOS)
    path_append PATH /usr/sbin
    ;;
Linux)
    path_append PATH /usr/sbin
    path_append PATH /sbin
    ;;
esac

provide admin

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
