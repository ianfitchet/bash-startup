
case "${OS_NAME}" in
SunOS)
    path_append PATH /usr/sbin
    ;;
Linux)
    path_append PATH /usr/sbin
    path_append PATH /sbin
    ;;
Darwin)
    path_append PATH /usr/sbin
    path_append PATH /sbin
    ;;
CYGWIN_NT-5.1)
    path_append PATH /usr/sbin
    ;;
esac

FEATURE_DESCRIPTION="add admin commands to the PATH"

provide admin

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
