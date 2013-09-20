# The BBS theme, by Aaron Bieber (https://github.com/aaronbieber).
#
# Inspired by my formative BBS and IRC years, based on the Fino and Jonathan 
# themes from oh-my-zsh.

function theme_precmd {
  COLS=$(( ($COLUMNS - 9) / 3 ))
  COLS_MIDDLE=$COLS

  return_status="%(?:%f⓪:%B%F{red}%}⏎%f%b)"

  # Scale the middle column to fill in a gap causing by division rounding.
  if [ $(( $COLS * 3 )) -lt $(( $COLUMNS - 9 )) ]; then
    COLS_MIDDLE=$(( $COLS + $(( $COLS - ($COLUMNS - 9) )) ))
  fi

  RIGHT_LINE_LEN=$(( $COLS_MIDDLE / 2 ))
  RIGHT_LINE=${(l:$RIGHT_LINE_LEN::─:)}

  PR_LINE='%F{245}─%F{240}─%{${(l:$COLS::─:)}%}%F{237}%{${(l:$COLS_MIDDLE::─:)}%}%F{240}%{${(l:$COLS::─:)}%}%F{245}──%F{256}─┐'
  PR_TOP_LINE="%F{white}┌─$PR_LINE"
  PR_BOTTOM_LINE="%F{256}└─$PR_LINE"

  PR_USER=`whoami`
  PR_BOX=`hostname`
  PR_PWD=`pwd`
  PR_PWD=${PR_PWD/$HOME/\~}
  PR_GIT_INFO=`git_prompt_info`
  PR_GIT=`print -P $PR_GIT_INFO`

  PR_LEN=$(( 15 + ${#PR_USER} + ${#PR_BOX} + ${#PR_PWD} ))
  if [ "$PR_GIT_INFO" != "" ]; then
    PR_LEN=$(( $PR_LEN + (${#PR_GIT} - 32) ))
  fi
  PR_PAD=$(( $COLUMNS - $PR_LEN ))

  PR_RIGHT_END='${(l:$PR_PAD:: :)}$FG[256]│'
}

function setprompt {
  setopt prompt_subst
  autoload colors zsh/terminfo

  local current_dir='${PWD/#$HOME/~}'
  local git_info='$(git_prompt_info)'

  PROMPT='${(e)PR_TOP_LINE}
%{$FG[256]%}│$FG[245] $return_status  %{$FG[040]%}$PR_USER%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$PR_BOX%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}$PR_PWD%{$reset_color%}$PR_GIT_INFO${(e)PR_RIGHT_END}
%{$FG[256]%}╰─$FG[245]─$FG[239]╶%f '

  RPROMPT='%F{239} ╴ ╴╴$RIGHT_LINE%F{245}─%f┘'

  ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[202]%}✘"
  ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[040]%}✔"
}

function theme_preexec {
}

setprompt

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
add-zsh-hook preexec theme_preexec

# vim: set et ts=2 sw=2 ft=zsh:
