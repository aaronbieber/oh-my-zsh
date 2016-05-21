#!/bin/zsh -f

function theme_precmd {
  # Current working directory
  pwd=`pwd`

  # Trim leading forward slash
  pwd="${pwd##/}"

  # Split into an array of directory names
  path_parts=("${(@s./.)pwd}")
  # Get the length of the list
  path_parts_len=$#path_parts
  # Rebuild the list without the last part
  path_parts_short=("${(@)path_parts[1,$path_parts_len-1]}")

  path_line=""
  for part in $path_parts_short; do
    # Append the first two letters of each part to the path string
    path_line="$path_line/${part[1,2]}"
  done
  # Add the last element (the current directory name) in full
  path_line="$path_line/${path_parts[$path_parts_len]}"
}

PROMPT='%F{cyan}%m:%F{green}$path_line$(git_prompt_info)%F{256} %# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{094} $fg_bold[red]✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{094} $fg_bold[green]✔%{$reset_color%}"

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
