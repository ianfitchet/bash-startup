
# Copyright 2010, 2011 Run Scripts Limited <support@runscripts.com>

# Based on Noah Friedman's require.bash in the Bash examples

export -n FEATURE_NAMES FEATURE_DESC FEATURE_INDEX
FEATURE_INDEX=${FEATURE_INDEX:=0}
export -n FEATURE_SUFFIXES
{
    typeset bv
    for (( bv=${BASH_VERSINFO[0]} ; bv > 1 ; bv-- )) ; do
	FEATURE_SUFFIXES[${#FEATURE_SUFFIXES[*]}]=.bash${bv}
    done

    unset bv
}
FEATURE_SUFFIXES[${#FEATURE_SUFFIXES[*]}]=.bash
	
featurep ()
{
    case " ${FEATURE_NAMES[*]} " in
    *" $1 "*)
	return 0
	;;
    esac
       
    return 1
}

features ()
{
    typeset opt_kind
    opt_kind=s

    OPTIND=1
    typeset opt
    while getopts "sl" opt ; do
	case "${opt}" in
	s|l)
	    opt_kind=${opt}
	    ;;
	?)
            error "Unexpected argument"
            ;;
	esac
    done

    shift $(( $OPTIND - 1 ))

    case "${opt_kind}" in
    s)
	echo "${FEATURE_NAMES[*]}"
	;;
    l)
	typeset fi maxfi

	maxfi=${#FEATURE_NAMES[*]}

	typeset maxlf lf
	maxlf=0

	for ((fi=0; fi < maxfi; fi++)) ; do
	    lf=${#FEATURE_NAMES[fi]}
	    if [[ $lf -gt $maxlf ]] ; then
		maxlf=${lf}
	    fi
	done

	for ((fi=0; fi < maxfi; fi++)) ; do
	    printf "%-*s - %s\n" $maxlf "${FEATURE_NAMES[fi]}" "${FEATURE_DESC[fi]}"
	done
	;;
    esac
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

    for (( si=0 ; si < ${#FEATURE_SUFFIXES[*]} ; si++ )) ; do

	typeset suffix=${FEATURE_SUFFIXES[${si}]}

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
    FEATURE_NAMES[FEATURE_INDEX]="$1"
    FEATURE_DESC[FEATURE_INDEX]="${FEATURE_DESCRIPTION}"

    FEATURE_INDEX=$(( FEATURE_INDEX + 1 ))
}

if [[ "${BASH_VERSINFO[0]}" -ge 3 || ("${BASH_VERSINFO[0]}" -eq 2 && "${BASH_VERSINFO[1]%[a-z]}" -ge 4) ]] ; then

    feature_require_completion ()
    {
	typeset cmd="$1"
	typeset word="$2"
	typeset prec="$3"

	typeset OIFS="${IFS}"
	IFS=:
	typeset fpath
	fpath=( ${FPATH} )
	IFS="${OIFS}"

	typeset features
	features=()

	typeset fd
	for fd in "${fpath[@]}" ; do
	    typeset poss_features
	    poss_features=()

	    typeset s
	    for s in "${FEATURE_SUFFIXES[@]}" ; do
		typeset glob
		glob=( "${word}"*${s} )

		if [[ -e "${glob[0]}" ]] ; then
		    poss_features=( "${poss_features[@]}" "${glob[@]%.bash*}" )
		fi
	    done

	    typeset pfi pfm
	    pfm=${#poss_features[*]}
	    
	    for ((pfi=0 ; pfi < pfm; pfi++)) ; do
		typeset fv
		fv="${poss_features[pfi]##*.bash}"

		if [[ $fv && $fv -gt ${BASH_VERSINFO[0]} ]] ; then
		    unset poss_features[pfi]
		fi
	    done

	    features=( "${features[@]}" "${poss_features[@]}" )
	done

	COMPREPLY=( "${features[@]}" )
    }

    complete -F feature_require_completion require

fi

FEATURE_DESCRIPTION="require/provide functionality"

provide require

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: undecided-unix
# End:
