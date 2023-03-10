# Copyright (c) 2011 Run Scripts Limited
#
# Licensed under the Apache License, Version 2.0 (the "License"); you
# may not use this file except in compliance with the License.  You
# may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

# 
# path-functions.bash -- a set of shell functions for manipulating
# paths of various kinds
#
# For a detailed explanation see:
# http://www.runscripts.com/support/guides/scripting/bash/path-functions
#
# These should be portable across Bash 2, 3, 4

######################################################################
# 
# path_modify [options] VAR VAL ACT WRT SEP
#
# Modify a path in various ways (append, prepend, remove, replace,
# etc.).  It handles paths with whitespace and various kinds of
# separators (Unix's :, Windows' ;).

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# VAL - the path element(s) to be added, SEP separated

# ACT - the action to be performed: 
#       first|start  - prepend VAL
#       last|end     - append VAL
#       verify       - apply the conditional operator
#       after|before - insert VAL after/before WRT
#       replace      - replace WRT with VAL
#       remove       - remove WRT

# WRT - the element in the path to be operated on

# SEP - the element separator (defaults to `:')

# [options]:

#  -1 - do the operation once (replace/remove); unique entry (first/last/before/after)
#  -d - apply the exists and is a directory operator
#  -e - apply the exists operator
#  -f - apply the exists and is a file operator

path_modify ()
{
    typeset opt_op opt_once

    OPTIND=1
    typeset opt
    while getopts "1def" opt ; do
	case "${opt}" in
	1)
	    opt_once=1
	    ;;
	d|e|f)
            opt_op=${opt}
            ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    typeset var="$1"
    typeset val="$2"
    typeset act="$3"
    typeset wrt="$4"
    typeset sep="${5:-:}"

    if [[ "${opt_once}" ]] ; then
	case "${act}" in
	first|start|last|end|after|before)
	    if path_contains "${var}" "${val}" "${sep}" ; then
		path_remove "${var}" "${val}" "${sep}"
	    fi
	;;
	esac
    fi

    typeset OIFS
    OIFS="${IFS}"

    IFS="${sep}"
    typeset origdirs
    origdirs=( ${!var} )

    typeset newdirs
    newdirs=( ${val} )

    if [[ ${opt_op} ]] ; then
	typeset n
	typeset maxn=${#newdirs[*]}
    
	for (( n=0 ; n < ${maxn} ; n++ )) ; do

	    # if ... ; then
	    # where ... is a case statement!

	    # We have to do this complex statement because we're using
	    # [[ which insists on conditional operators being unquoted
	    # (and certainly not the result of variable expansion).

	    # If we were using the non-preferred [ (or test) then we
	    # could have simply said:

	    # if [ -${opt_op} "${newdirs[n]}" ]

	    # although we definitely have to double quote the
	    # ${newdirs[n]} expression

	    if 
		case "${opt_op}" in
		d) [[ ! -d "${newdirs[n]}" ]] ;;
		e) [[ ! -e "${newdirs[n]}" ]] ;;
		f) [[ ! -f "${newdirs[n]}" ]] ;;
		esac 
	    then
		unset newdirs[n]
	    fi
	done
    fi

    if [[ ${#newdirs[*]} -eq 0 ]] ; then
	case "${act}" in
	verify|replace|remove)
	    ;;
	*)
	    IFS="${OIFS}"
	    return 0
	    ;;
	esac
    fi

    typeset vardirs
    vardirs=()

    case "${act}" in
    first|start)
	vardirs=( "${newdirs[@]}" "${origdirs[@]}" )
	;;
    last|end)
	vardirs=( "${origdirs[@]}" "${newdirs[@]}" )
	;;
    verify)
	vardirs=( "${newdirs[@]}" )
	;;
    after|before|replace|remove)
	typeset todo=1
	typeset o
	typeset maxo=${#origdirs[*]}

	for (( o=0 ; o < ${maxo} ; o++ )) ; do
	    if [[ "${todo}" && "${origdirs[o]}" = "${wrt}" ]] ; then
		case "${act}" in
		after)
		    vardirs=( "${vardirs[@]}" "${origdirs[o]}" "${newdirs[@]}" )
		    ;;
		before)
		    vardirs=( "${vardirs[@]}" "${newdirs[@]}" "${origdirs[o]}" )
		    ;;
		replace)
		    vardirs=( "${vardirs[@]}" "${newdirs[@]}" )
		    ;;
		remove)
		    ;;
		esac

		if [[ "${opt_once}" ]] ; then
		    todo=
		fi
	    else
		vardirs=( "${vardirs[@]}" "${origdirs[o]}" )
	    fi
	done
	;;
    *)
	vardirs=( "${origdirs[@]}" )
	;;
    esac

    read ${var} <<< "${vardirs[*]}"

    IFS="${OIFS}"
}

######################################################################
# 
# path_append [options] VAR VAL SEP
#
# A wrapper to path_modify's append function.

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# VAL - the path element(s) to be added, SEP separated

# SEP - the element separator (defaults to `:')

# [options]:

#  -1 - make the new entry unique
#  -d - apply the exists and is a directory operator
#  -e - apply the exists operator
#  -f - apply the exists and is a file operator

path_append ()
{
    typeset opt_flags opt_op_flags

    OPTIND=1
    typeset opt
    while getopts "1def" opt ; do
	case "${opt}" in
	1)
	    opt_flags=-${opt}
	    ;;
	d|e|f)
	    opt_op_flags=-${opt}
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    path_modify ${opt_flags} ${opt_op_flags} "$1" "$2" last '' "${3:-:}"
}

path_append_unique ()
{
    path_append -1 "$@"
}

######################################################################
# 
# path_prepend [options] VAR VAL SEP
#
# A wrapper to path_modify's prepend function.

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# VAL - the path element(s) to be added, SEP separated

# SEP - the element separator (defaults to `:')

# [options]:

#  -1 - make the new entry unique
#  -d - apply the exists and is a directory operator
#  -e - apply the exists operator
#  -f - apply the exists and is a file operator

path_prepend ()
{
    typeset opt_flags opt_op_flags

    OPTIND=1
    typeset opt
    while getopts "1def" opt ; do
	case "${opt}" in
	1)
	    opt_flags=-${opt}
	    ;;
	d|e|f)
	    opt_op_flags=-${opt}
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    path_modify ${opt_flags} ${opt_opflags} "$1" "$2" first '' "${3:-:}"
}

path_prepend_unique ()
{
    path_prepend -1 "$@"
}

######################################################################
# 
# path_verify [options] VAR SEP
#
# A wrapper to path_modify's verify function.

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# SEP - the element separator (defaults to `:')

# [options]:

#  -d - apply the exists and is a directory operator
#  -e - apply the exists operator
#  -f - apply the exists and is a file operator

path_verify ()
{
    typeset opt_flags

    OPTIND=1
    typeset opt
    while getopts "def" opt ; do
	case "${opt}" in
	d|e|f)
	    opt_flags=-${opt}
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    path_modify ${opt_flags} "$1" "${!1}" verify '' "${2:-:}"
}

######################################################################
# 
# path_replace [options] VAR OLD NEW SEP
#
# A wrapper to path_modify's replace function.

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# OLD - the path element to be replaced

# NEW - the path element(s) to be added, SEP separated

# SEP - the element separator (defaults to `:')

# [options]:

#  -1 - do the operation once

path_replace ()
{
    typeset opt_flags

    OPTIND=1
    typeset opt
    while getopts "1" opt ; do
	case "${opt}" in
	1)
	    opt_flags=-1
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    path_modify ${opt_flags} "$1" "$3" replace "$2" "${4:-:}"
}

path_replace_first ()
{
    path_replace -1 "$@"
}

######################################################################
# 
# path_remove [options] VAR OLD SEP
#
# A wrapper to path_modify's remove function.

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# OLD - the path element to be removed

# SEP - the element separator (defaults to `:')

# [options]:

#  -1 - do the operation once

path_remove ()
{
    typeset opt_flags

    OPTIND=1
    typeset opt
    while getopts "1" opt ; do
	case "${opt}" in
	1)
	    opt_flags=-1
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    path_modify ${opt_flags} "$1" '' remove "$2" "${3:-:}"
}

path_remove_first ()
{
    path_remove -1 "$@"
}

######################################################################
# 
# path_contains VAR VAL SEP
#
# Returns true if $VAR contains VAL

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# VAL - the path element(s) to be checked for

# SEP - the element separator (defaults to `:')

path_contains ()
{
    typeset var=$1
    typeset val=$2
    typeset sep="${3:-:}"
    
    case "${sep}${!var}${sep}" in
    *"${sep}${val}${sep}"*)
	return 0
	;;
    esac

    return 1
}

######################################################################
# 
# path_trim VAR SEP
#
# Remove duplicate elements in a path after the first

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# SEP - the element separator (defaults to `:')

path_trim ()
{
    typeset var=$1
    typeset sep="${2:-:}"
    
    typeset OIFS
    OIFS="${IFS}"

    IFS="${sep}"
    typeset origdirs
    origdirs=( ${!var} )

    IFS="${OIFS}"

    typeset o
    typeset maxo=${#origdirs[*]}
    typeset seen=
    for (( o=0 ; o < ${maxo} ; o++ )) ; do
	case "${sep}${seen}${sep}" in
	*"${sep}${origdirs[o]:-.}${sep}"*)
	    unset origdirs[o]
	    ;;
	*)
	    seen="${seen+${seen}${sep}}${origdirs[o]:-.}"
	    ;;
	esac
    done

    IFS="${sep}"
    read ${var} <<< "${origdirs[*]}"

    IFS="${OIFS}"
}

######################################################################
# 
# std_paths ACT VAL SEP
#
# Call the function path_ACT for PATH with VAL/bin and MANPATH with
# VAL/man (or VAL/share/man) if either exists.

# ACT - the suffix of the path function, eg. append to give
# path_append

# VAL - the top of the distribution tree, eg. /usr/local to add
# /usr/local/bin to PATH and either of /usr/local/man or
# /usr/local/share/man to MANPATH if either exists.

# SEP - the element separator (defaults to `:')

# [options]:

#  -1 - make the new entry unique
#  -d - apply the exists and is a directory operator
#  -e - apply the exists operator
#  -f - apply the exists and is a file operator

std_paths ()
{
    typeset opt_flags opt_op_flags

    OPTIND=1
    typeset opt
    while getopts "1def" opt ; do
	case "${opt}" in
	1)
	    opt_flags=-${opt}
	    ;;
	d|e|f)
	    opt_op_flags=-${opt}
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    typeset act="$1"
    typeset val="$2"
    typeset sep="${3:-:}"
    
    typeset OIFS
    OIFS="${IFS}"

    IFS="${sep}"
    typeset newdirs
    newdirs=( ${val} )

    IFS="${OIFS}"

    typeset dir
    for dir in "${newdirs[@]}" ; do
	path_${act} ${opt_flags} ${opt_op_flags} PATH "${dir}/bin" "${sep}"
	typeset md
	for md in man share/man ; do 
	    if [[ -d "${dir}/${md}" ]] ; then
		path_${act} ${opt_flags} ${opt_op_flags} MANPATH "${dir}/${md}" "${sep}"
	    fi
	done
    done
}

std_paths_unique ()
{
    std_paths -1 "$@"
}

######################################################################
# 
# all_paths ACT VAL SEP
#
# Call the function path_ACT for PATH with VAL/bin, LD_LIBRARY_PATH
# with VAL/lib if it exists and MANPATH with VAL/man (or
# VAL/share/man) if either exists.

# ACT - the suffix of the path function, eg. append to give
# path_append

# VAL - the top of the distribution tree, eg. /usr/local to add
# /usr/local/bin to PATH, /usr/local/lib to LD_LIBRARY_PATH if it
# exists and either of /usr/local/man or /usr/local/share/man to
# MANPATH if either exists.

# SEP - the element separator (defaults to `:')

# [options]:

#  -1 - make the new entry unique
#  -d - apply the exists and is a directory operator
#  -e - apply the exists operator
#  -f - apply the exists and is a file operator

all_paths ()
{
    typeset opt_flags opt_op_flags

    OPTIND=1
    typeset opt
    while getopts "1def" opt ; do
	case "${opt}" in
	1)
	    opt_flags=-${opt}
	    ;;
	d|e|f)
	    opt_op_flags=-${opt}
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    typeset act="$1"
    typeset val="$2"
    typeset sep="${3:-:}"
    
    typeset OIFS
    OIFS="${IFS}"

    IFS="${sep}"
    typeset newdirs
    newdirs=( ${val} )

    IFS="${OIFS}"

    typeset dir
    for dir in "${newdirs[@]}" ; do
	path_${act} ${opt_flags} ${opt_op_flags} PATH "${dir}/bin" "${sep}"
	for md in man share/man ; do 
	    if [[ -d "${dir}/${md}" ]] ; then
		path_${act} ${opt_flags} ${opt_op_flags} MANPATH "${dir}/${md}" "${sep}"
	    fi
	done
	if [[ -d "${dir}/lib" ]] ; then
	    path_${act} ${opt_flags} ${opt_op_flags} LD_LIBRARY_PATH "${dir}/lib" "${sep}"
	fi
    done
}

all_paths_unique ()
{
    all_paths -1 "$@"
}

######################################################################
# 
# pathname_flatten VAR SEP
#
# Normalize the path by removing . and .. elements as appropriate

# VAR - the name of the path to be manipulated, eg. PATH, CLASSPATH

# SEP - the element separator (defaults to `:')

pathname_flatten ()
{
    typeset val=$1
    typeset sep="${2:-/}"
    
    typeset OIFS
    OIFS="${IFS}"

    IFS="${sep}"
    typeset origpath
    origpath=( ${val} )

    IFS="${OIFS}"
    
    typeset newpath
    newpath=()

    typeset p
    typeset maxp=${#origpath[*]}
    typeset seen=
    for (( p=0 ; p < ${maxp} ; p++ )) ; do
	case "${origpath[p]}" in
	'')
	    # ///foo -> ( '' '' '' foo )
	    # but we still need the first!
	    if [[ $p -eq 0 ]] ; then
		newpath=( '' )
	    fi
	    ;;
	.)
	    ;;
	..)
	    if [[ $p -eq 0 ]] ; then
		# .. at the start cannot be flattened
		newpath=( "${newpath[@]}" "${origpath[p]}" )
	    else
	        # remove the last element
		if [[ ${#newpath[*]} -gt 1 ]] ; then
		    unset newpath[$((${#newpath[*]} - 1))]
		fi
	    fi
	    ;;
	*)
	    newpath=( "${newpath[@]}" "${origpath[p]}" )
	    ;;
	esac
    done

    # If all we are left with in newpath is '' (ie /) then the IFS
    # trick fails us, we need to handle this case specially

    if [[ ${#newpath[*]} -eq 1 && "${newpath[0]}" = "" ]] ; then
	echo /
    else
	IFS="${sep}"
	echo "${newpath[*]}"
	IFS="${OIFS}"
    fi
}

provide path-functions "functions to manipulate PATHs"
