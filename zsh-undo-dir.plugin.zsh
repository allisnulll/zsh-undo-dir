#!/usr/bin/env zsh

undo_dir_hist=($PWD)
redo_dir_hist=()
max=16
skip_hook=0

function quiet_cd() {
    builtin cd $1

    for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
        [[ $+functions[$f] -ne 0 ]] && $f &>/dev/null || true
    done

    zle .reset-prompt
    zle -R
}

autoload -U add-zsh-hook
add-zsh-hook chpwd on_cwd_change
function on_cwd_change() {
    if [[ $skip_hook == 1 || $PWD == ${undo_dir_hist[-1]} ]]; then
        return
    fi

    undo_dir_hist+=$PWD

    if [[ $PWD == ${redo_dir_hist[-1]} ]]; then
        shift -p redo_dir_hist
    else
        redo_dir_hist=()
    fi

    if [[ ${#undo_dir_hist[@]} -gt $max ]]; then
        shift undo_dir_hist
    fi
}

function undo_dir() {
    if [[ -n ${undo_dir_hist[@]} ]]; then
        redo_dir_hist+=${undo_dir_hist[-1]}
        shift -p undo_dir_hist
        quiet_cd ${undo_dir_hist[-1]}
    fi
}

function redo_dir() {
    if [[ -n ${redo_dir_hist[@]} ]]; then
        undo_dir_hist+=${redo_dir_hist[-1]}
        shift -p redo_dir_hist
        quiet_cd ${undo_dir_hist[-1]}
    fi
}

zle -N undo_dir
zle -N redo_dir

bindkey -M emacs "^o" undo_dir
bindkey -M vicmd "^o" undo_dir
bindkey -M viins "^o" undo_dir
bindkey -M emacs "^[[1;2R" redo_dir
bindkey -M vicmd "^[[1;2R" redo_dir
bindkey -M viins "^[[1;2R" redo_dir
