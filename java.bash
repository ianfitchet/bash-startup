
case "${OS_NAME}" in
SunOS)
    JAVA_HOME=/usr/java
    export JAVA_HOME

    FEATURE_DESCRIPTION="Java setup"
    ;;
*)
    FEATURE_DESCRIPTION="(Solaris)"
    ;;
esac

provide java

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
