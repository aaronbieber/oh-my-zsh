# The BBS theme, by Aaron Bieber (https://github.com/aaronbieber).
#
# Inspired by my formative BBS and IRC years, based on the Fino and Jonathan 
# themes from oh-my-zsh.

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

function theme_precmd {
  COLS=$(( ($COLUMNS - 9) / 3 ))
  COLS_MIDDLE=$COLS

  # Scale the middle column to fill in a gap causing by division rounding.
  if [ $(( $COLS * 3 )) -lt $(( $COLUMNS - 7 )) ]; then
    COLS_MIDDLE=$(( $COLS + $(( $COLS - ($COLUMNS - 9) )) ))
  fi

  PR_LINE='$FG[245]─$FG[240]─%{${(l:$COLS::─:)}%}$FG[237]%{${(l:$COLS_MIDDLE::─:)}%}$FG[240]%{${(l:$COLS::─:)}%}$FG[245]─$FG[255]─┐'
  PR_TOP_LINE="\$FG[256]┌─$PR_LINE"
  PR_BOTTOM_LINE="\$FG[256]└─$PR_LINE"

  if [ "`id -u`" -eq 0 ]; then
    PR_USER_SYMBOL='♚'
  else
    PR_USER_SYMBOL='♟'
  fi
}

local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi

function setprompt {
  setopt prompt_subst
  autoload colors zsh/terminfo

  local current_dir='${PWD/#$HOME/~}'
  local git_info='$(git_prompt_info)'

  PROMPT='${(e)PR_TOP_LINE}
%{$FG[256]%}│$FG[245] $PR_USER_SYMBOL  %{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}`git_prompt_info`
%{$FG[256]%}╰─$FG[245]─$FG[239]╶%{$reset_color%} $(virtualenv_info)'

  RPROMPT=' $FG[239]╴$FG[245]─%{$reset_color%}┘ '

  ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[202]%}✘"
  ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[040]%}✔"
}

setprompt

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
#add-zsh-hook preexec theme_preexec

# vim: set et ts=2 sw=2 ft=zsh:
