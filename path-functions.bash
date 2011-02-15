
# Copyright 2010 Run Scripts Limited <support@runscripts.com>

path_append ()
{
    typeset var=$1
    typeset val="$2"
    typeset sep="${3:-:}"
    
    typeset dirs
    eval dirs=( $(IFS=${sep} ; set -- ${val} ; for dir in "$@" ; do echo \"${dir}\" ; done) )

    typeset dir
    for dir in "${dirs[@]}" ; do
	eval ${var}=\"${!var+${!var}${sep}}${dir}\"
    done
}

path_prepend ()
{
    typeset var=$1
    typeset val="$2"
    typeset sep="${3:-::}"
    
    typeset dirs
    eval dirs=( $(IFS=${sep} ; set -- ${val} ; for dir in "$@" ; do echo \"${dir}\" ; done) )

    typeset dir
    for dir in "${dirs[@]}" ; do
	eval ${var}=\"${dir}${!var+${sep}${!var}}\"
    done
}

path_remove ()
{
    typeset var=$1
    typeset val="$2"
    typeset sep="${3:-:}"
    
    typeset dirs
    eval dirs=( $(IFS=${sep} ; set -- ${!var} ; for dir in "$@" ; do echo \"${dir}\" ; done) )

    typeset i
    typeset max=${#dirs[*]}
    for (( i=0 ; i < ${max} ; i++ )) ; do
	if [ "${dirs[$i]}" = "${val}" ] ; then
	    unset dirs[$i]
	fi
    done

    eval ${var}=\"$(IFS=${sep}; echo "${dirs[*]}")\"
}

path_trim ()
{
    typeset var=$1
    typeset sep="${2:-:}"
    
    typeset dirs
    eval dirs=( $(IFS=${sep} ; set -- ${!var} ; for dir in "$@" ; do echo \"${dir}\" ; done) )

    typeset i
    typeset max=${#dirs[*]}
    typeset seen=
    for (( i=0 ; i < ${max} ; i++ )) ; do
	case "${sep}${seen}${sep}" in
	*"${sep}${dirs[$i]}${sep}"*)
	    unset dirs[$i]
	    ;;
	*)
	    seen="${seen+${seen}${sep}}${dirs[$i]}"
	    ;;
	esac
    done

    eval ${var}=\"$(IFS=${sep}; echo "${dirs[*]}")\"
}

std_paths ()
{
    typeset act="$1"
    typeset val="$2"
    typeset sep="${3:-:}"
    
    typeset dirs
    eval dirs=( $(IFS=${sep} ; set -- ${val} ; for dir in "$@" ; do echo \"${dir}\" ; done) )

    typeset dir
    for dir in "${dirs[@]}" ; do
	path_${act} PATH "${dir}/bin"
	typeset md
	for md in man share/man ; do 
	    if [ -x "${dir}/${md}" ] ; then
		path_${act} MANPATH "${dir}/${md}"
	    fi
	done
    done
}

all_paths ()
{
    typeset act="$1"
    typeset val="$2"
    typeset sep="${3:-:}"
    
    typeset dirs
    eval dirs=( $(IFS=${sep} ; set -- ${val} ; for dir in "$@" ; do echo \"${dir}\" ; done) )

    typeset dir
    for dir in "${dirs[@]}" ; do
	path_${act} PATH "${dir}/bin"
	for md in man share/man ; do 
	    if [ -x "${dir}/${md}" ] ; then
		path_${act} MANPATH "${dir}/${md}"
	    fi
	done
	path_${act} LD_LIBRARY_PATH "${dir}/lib"
    done
}

provide path-functions
