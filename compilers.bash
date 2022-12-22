
case "${OS_NAME}" in
SunOS)
    std_paths -d append /opt/SUNWspro
    std_paths append /usr/ccs

    feature_description="add Sun compilers to the PATH"
    ;;
*)
    feature_description="n/a"
    ;;
esac

# determining the compiler version is surprisingly tricky
if type -p cc >/dev/null 2>&1 ; then
    feature_description=cc
    cc_version=$(cc --version | head -1)
elif type -p gcc >/dev/null 2>&1 ; then
    feature_description=gcc
    cc_version=$(gcc --version | head -1)
elif type -p gcc-8 >/dev/null 2>&1 ; then
    feature_description=gcc-8
    cc_version=$(gcc-8 --version | head -1)
fi

if [[ ${cc_version} =~ ^g?cc[^\ ]*\ \([^\)]+\)\ ([[:alnum:].]+) ]] ; then
    feature_version=${BASH_REMATCH[1]}
    feature_description="gcc ${version%%.*}"
elif [[ ${cc_version} =~ gcc[^\ ]+\ \(GCC\)\ ([[:alnum:].]+) ]] ; then
    feature_version=${BASH_REMATCH[1]}
    feature_description="gcc ${version%%.*}"
elif [[ ${cc_version} =~ \ clang\ version\ ([[:alnum:].]+) ]] ; then
    feature_version=${BASH_REMATCH[1]}
    feature_description="clang ${version%%.*}"
fi

provide compilers "${feature_description}" "${feature_version}"
unset feature_description feature_version

# Local Variables:
# mode: Shell-script
# coding: undecided-unix
# End:
