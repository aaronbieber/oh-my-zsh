# The BBS theme, by Aaron Bieber (https://github.com/aaronbieber).
#
# Inspired by my formative BBS and IRC years, based on the Fino and Jonathan 
# themes from oh-my-zsh.

function theme_precmd {
  COLS=$(( ($COLUMNS - 9) / 3 ))
  COLS_MIDDLE=$COLS

  RETURN_STATUS="%(?:%F{040}☼:%F{202}%}☹%f%b)"

  # Scale the middle column to fill in a gap causing by division rounding.
  COLS_MIDDLE=$(( (($COLUMNS - 9) - ($COLS * 2)) - 10 ))
  if [ $COLS_MIDDLE -lt 0 ]; then
    COLS_MIDDLE=0
  fi

  RIGHT_LINE_LEN=$(( $COLS_MIDDLE / 2 ))
  RIGHT_LINE=${(l:$RIGHT_LINE_LEN::─:)}

  PR_LINE='%F{245}─%F{240}─%{${(l:$COLS::─:)}%}\
%F{237}───╶╶%{${(l:$COLS_MIDDLE:: :)}%}%F{237}╴╴───\
%F{240}%{${(l:$COLS::─:)}%}%F{245}──%F{256}─┐'
  PR_TOP_LINE="%F{256}┌─$PR_LINE"
  PR_BOTTOM_LINE="%F{256}└─$PR_LINE"

  PR_USER=`whoami`
  PR_BOX=`hostname`
  PR_PWD=`pwd`
  PR_PWD=${PR_PWD/$HOME/\~}
  PR_GIT_INFO=`git_prompt_info`
  PR_GIT=`print -P $PR_GIT_INFO`

  PR_LEN=$(( 13 + ${#PR_USER} + ${#PR_BOX} + ${#PR_PWD} ))
  if [ "$PR_GIT_INFO" != "" ]; then
    PR_LEN=$(( $PR_LEN + (${#PR_GIT_INFO} - 25) ))
  fi
  PR_PAD=$(( $COLUMNS - $PR_LEN ))

  PR_RIGHT_END='${(l:$PR_PAD:: :)}%F{256}│'
}

function setprompt {
  setopt prompt_subst
  autoload colors zsh/terminfo

  local current_dir='${PWD/#$HOME/~}'
  local git_info='$(git_prompt_info)'

  PROMPT='${(e)PR_TOP_LINE}
%F{256}│%F{245} $RETURN_STATUS  %F{075}$PR_USER\
%F{024} ❱ %F{075}$PR_BOX\
%F{024} ❱ %F{226}%B$PR_PWD%b%f\
$PR_GIT_INFO\
${(e)PR_RIGHT_END}
%F{256}╰─%F{245}─%F{239}╶%f '

  RPROMPT='%F{239} ╴ ╴╴$RIGHT_LINE%F{245}─%F{256}┘'

  ZSH_THEME_GIT_PROMPT_PREFIX=" %F{024}⭠%f %F{075}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
  ZSH_THEME_GIT_PROMPT_DIRTY=" %F{202}✘"
  ZSH_THEME_GIT_PROMPT_CLEAN=" %F{040}✔"
}

function theme_preexec {
}

setprompt

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
add-zsh-hook preexec theme_preexec

# vim: set et ts=2 sw=2 ft=zsh:
