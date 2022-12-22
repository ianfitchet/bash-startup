
case "${OS_NAME}" in
SunOS)
    JAVA_HOME=/usr/java
    export JAVA_HOME

    feature_description="Java setup"
    ;;
*)
    feature_description="n/a"
    ;;
esac

if type -p java >/dev/null 2>&1 ; then
    {
	typeset v d

	# openjdk version "1.8.0_322"
	read v
	v="${v#*\"}"
	v="${v%%\"*}"
	feature_version="${v}"

	# OpenJDK Runtime Environment (build 1.8.0_322-b06)
	read d
	feature_description="${d%% (*}"
    } < <(java -version 2>&1)
fi

provide java "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
