#!/bin/zsh -f
PROMPT='%F{026}%c$(git_prompt_info)%F{256} %# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{166}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{094} %F{160}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{094}"
