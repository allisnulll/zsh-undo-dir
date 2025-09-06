#!/usr/bin/env zsh
_UD_UNDO_HIST=($PWD)
_UD_REDO_HIST=()
_UD_MAX=16
_UD_SKIP_HOOK=0

function _quiet_cd() {
    builtin cd $1

    for f in chpwd ${chpwd_functions[@]} precmd ${precmd_functions[@]}; do
        [[ $+functions[$f] != 0 ]] && $f &>/dev/null || true
    done

    zle .reset-prompt
    zle -R
}

function _on_cwd_change() {
    if [[ $_UD_SKIP_HOOK == 1 || $PWD == ${_UD_UNDO_HIST[-1]} ]]; then
        return
    fi

    _UD_UNDO_HIST+=$PWD

    if [[ $PWD == ${_UD_REDO_HIST[-1]} ]]; then
        shift -p _UD_REDO_HIST
    else
        _UD_REDO_HIST=()
    fi

    if (( $#_UD_UNDO_HIST > $_UD_MAX )); then
        shift _UD_UNDO_HIST
    fi
}

function _undo_dir() {
    if (( $#_UD_UNDO_HIST > 1 )); then
        _UD_REDO_HIST+=${_UD_UNDO_HIST[-1]}
        shift -p _UD_UNDO_HIST
        _quiet_cd ${_UD_UNDO_HIST[-1]}
    fi
}

function _redo_dir() {
    if (( $#_UD_REDO_HIST > 0 )); then
        _UD_UNDO_HIST+=${_UD_REDO_HIST[-1]}
        shift -p _UD_REDO_HIST
        _quiet_cd ${_UD_UNDO_HIST[-1]}
    fi
}

function zsh_undo_dir() {
    autoload -U add-zsh-hook
    add-zsh-hook chpwd _on_cwd_change

    zle -N _undo_dir
    zle -N _redo_dir

    bindkey -M emacs "^o" _undo_dir
    bindkey -M vicmd "^o" _undo_dir
    bindkey -M viins "^o" _undo_dir
    bindkey -M emacs "^[[1;2R" _redo_dir
    bindkey -M vicmd "^[[1;2R" _redo_dir
    bindkey -M viins "^[[1;2R" _redo_dir
}

zsh_undo_dir
