
require path-functions

flag_set_p ()
{
    case "$-" in
    *$1*)
	return 0
	;;
    *)
	return 1
	;;
    esac
}

provide bashrc

# Local Variables:
# mode: Shell-script
# buffer-file-coding-system: undecided-unix
# End:
