
if flag_set_p "i" ; then
    vcss=()

    if type -p git > /dev/null ; then
	git_version=( $(git --version) )

	# Discover the git completion subdirectory first
	# usually /usr/share/doc/git*/contrib/completion
	# FreeBSD /usr/local/share/git-core/contrib/completion/git-prompt.sh
	# Mac OS  $(xcode-select -p)/usr/share/git-core

	# Ubuntu uses /usr/share/bash-completion/completions/git directly

	gcds=( /usr/share/doc/git{,-${git_version[2]},-core}/contrib/completion )
	case "${OS_NAME}" in
	FreeBSD)
		gcds+=( /usr/local/share/git-core/contrib/completion )
		;;
	NetBSD)
		gcds+=( /usr/pkg/share/examples/git )
		;;
	Darwin)
		gcds+=( $(xcode-select -p)/usr/share/git-core )
		;;
	esac

	for git_completion in ${gcds[*]} ; do
	    git_bash_completion=${git_completion}/git-completion.bash
	    if [[ -f ${git_bash_completion} ]] ; then
		. ${git_bash_completion}
		break
	    fi
	done

	# Ubuntu /usr/lib/git-core/git-sh-prompt
	for git_prompt in ${git_completion}/git-prompt.sh /usr/lib/git-core/git-sh-prompt ; do
	    if [[ -f ${git_prompt} ]] ; then
		. ${git_prompt}
		export GIT_PS1_SHOWDIRTYSTATE=1
		export GIT_PS1_SHOWUPSTREAM="auto"
		vcss+=(git)
		break
	    else
		__git_ps1 () { : ; }
	    fi
	done
    fi

    if type -p hg > /dev/null ; then
	vcss+=(hg)
    fi

    feature_description="${vcss[*]} prompts"

    VCS () {
	if [[ -d .hg || -d ../.hg || -d ../../.hg ]] ; then
	    hg_rev=$(hg tip --template '{rev}/{branch} {tags}' 2>/dev/null)
	    hg_bookmarks=$(hg bookmarks 2>/dev/null | awk '/\*/ {print $2}')
	    echo "${hg_rev+ $(tty_effect green ${hg_rev})}${hg_bookmarks+ $(tty_effect magenta ${hg_bookmarks})}"
	else
	    #git_ps1=$(__git_ps1 "%s")
	    #echo "${git_ps1+ $(tty_effect green ${git_ps1})}"
	    __git_ps1 " ${tty_effect_green}%s${tty_effect_offattr}"
	fi
    }
else
    feature_description="n/a"
fi

provide vcs-prompt "${feature_description}"
unset vcss feature_description

# Local Variables:
# mode: Shell-script
# End:
