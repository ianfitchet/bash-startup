
case "${OS_NAME}" in
SunOS)
    JAVA_HOME=/usr/java
    export JAVA_HOME

    feature_description="Java setup"
    ;;
*)
    feature_description="(Solaris)"
    ;;
esac

if type -p java >/dev/null 2>&1 ; then
    typeset v
    read v <<< $(java -version 2>&1)
    v="${v#*\"}"
    v="${v%%\"*}"
    feature_version="${v}"
fi

provide java "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
