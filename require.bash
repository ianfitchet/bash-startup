
# Copyright 2010, 2011 Run Scripts Limited <support@runscripts.com>

# Based on Noah Friedman's require.bash in the Bash examples

export -n FEATURES
feature_sep=:
export -n SUFFIXES
{
    typeset bv
    for (( bv=${BASH_VERSINFO[0]} ; bv > 1 ; bv-- )) ; do
	SUFFIXES[${#SUFFIXES[*]}]=.bash${bv}
    done

    unset bv
}
SUFFIXES[${#SUFFIXES[*]}]=.bash
	
featurep ()
{
    case "${feature_sep}${FEATURES}${feature_sep}" in
    *"${feature_sep}$1${feature_sep}"*)
	return 0
	;;
    esac
       
    return 1
}

find_feature ()
{
    typeset feature=$1

    typeset OIFS="${IFS}"

    typeset si

    typeset fpath
    IFS=:
    fpath=( ${FPATH} )
    IFS="${OIFS}"

    for (( si=0 ; si < ${#SUFFIXES[*]} ; si++ )) ; do

	typeset suffix=${SUFFIXES[${si}]}

	typeset d
	for d in "${fpath[@]}" ; do
	    if [[ -r "$d/${feature}${suffix}" ]] ; then
		echo "$d/${feature}${suffix}"
		return 0
	    fi
	done
    done

    return 1
}

require ()
{
    typeset feature status=0

    local FPATH="${FPATH}"

    typeset opt
    while getopts "d:" opt ; do
	case "${opt}" in
	d)
	    FPATH="${OPTARG}"
	    ;;
	?)
	    error "require: getopts"
	    ;;
	esac
    done

    shift $(( ${OPTIND} - 1 ))

    for feature in "$@" ; do
	if ! featurep ${feature} ; then

	    typeset feature_file

	    if feature_file=$(find_feature ${feature}) ; then
		source "${feature_file}"

		if ! featurep ${feature} ; then
		    warn "feature '${feature}' not provided"
		    status=1
		fi
	    else
		warn "feature '${feature}' not found"
		status=1
	    fi
	fi
    done

    return $status
}

provide ()
{
    FEATURES=${FEATURES+${FEATURES}:}$1
}

provide require

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: undecided-unix
# End:
