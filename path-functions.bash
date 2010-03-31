
# Copyright 2010 Run Scripts Limited <support@runscripts.com>

path_append ()
{
    typeset v=$1
    typeset p="$2"
    typeset sep=:
    
    typeset in
    eval in=( $(IFS=${sep} ; set -- ${p} ; for d in "$@" ; do echo \"$d\" ; done) )

    typeset d
    for d in "${in[@]}" ; do
	if [ -d "${d}" ] ; then
	    eval ${v}=\"${!v+${!v}${sep}}${d}\"
	fi
    done
}

path_prepend ()
{
    typeset v=$1
    typeset p="$2"
    typeset sep=:
    
    typeset in
    eval in=( $(IFS=${sep} ; set -- ${p} ; for d in "$@" ; do echo \"$d\" ; done) )

    typeset d
    for d in "${in[@]}" ; do
	if [ -d "${d}" ] ; then
	    eval ${v}=\"${d}${!v+${sep}${!v}}\"
	fi
    done
}

path_remove ()
{
    typeset v=$1
    typeset p="$2"
    typeset sep=:
    
    typeset in
    eval in=( $(IFS=${sep} ; set -- ${!v} ; for d in "$@" ; do echo \"$d\" ; done) )

    typeset i
    typeset max=${#in[*]}
    for (( i=0 ; i < ${max} ; i++ )) ; do
	if [ "${in[$i]}" = "$p" ] ; then
	    unset in[$i]
	fi
    done

    eval ${v}=\"$(IFS=${sep}; echo "${in[*]}")\"
}

path_trim ()
{
    typeset v=$1
    typeset sep=:
    
    typeset in
    eval in=( $(IFS=${sep} ; set -- ${!v} ; for d in "$@" ; do echo \"$d\" ; done) )

    typeset i
    typeset max=${#in[*]}
    typeset seen=
    for (( i=0 ; i < ${max} ; i++ )) ; do
	case "${sep}${seen}${sep}" in
	*"${sep}${in[$i]}${sep}"*)
	    unset in[$i]
	    ;;
	*)
	    seen="${seen+${seen}${sep}}${in[$i]}"
	    ;;
	esac
    done

    eval ${v}=\"$(IFS=${sep}; echo "${in[*]}")\"
}

std_paths ()
{
    typeset a="$1"
    typeset p="$2"
    typeset sep=:
    
    typeset in
    eval in=( $(IFS=${sep} ; set -- ${p} ; for d in "$@" ; do echo \"$d\" ; done) )

    typeset d
    for d in "${in[@]}" ; do
	path_${a} PATH "${d}/bin"
	path_${a} MANPATH "${d}/man"
    done
}

all_paths ()
{
    typeset a="$1"
    typeset p="$2"
    typeset sep=:
    
    typeset in
    eval in=( $(IFS=${sep} ; set -- ${p} ; for d in "$@" ; do echo \"$d\" ; done) )

    typeset d
    for d in "${in[@]}" ; do
	path_${a} PATH "${d}/bin"
	path_${a} MANPATH "${d}/man"
	path_${a} LD_LIBRARY_PATH "${d}/man"
    done
}

provide path-functions
