# The BBS theme, by Aaron Bieber (https://github.com/aaronbieber).
#
# Inspired by my formative BBS and IRC years, based on the Fino and Jonathan 
# themes from oh-my-zsh.

# The precmd hook is called by zsh before the prompt is displayed, so we can 
# manipulate values that might change, like your working directory, git 
# repository status, username (if you use `su`), and the size of the terminal 
# window.
function theme_precmd {
  # This is used to filter out escape sequences when calculating string length
  # (from http://stackoverflow.com/questions/10564314/
  # count-length-of-user-visible-string-for-zsh-prompt)
  local zero='%([BSUbfksu]|([FB]|){*})'

  # Figure out how many columns we have available for pretty lines. This is the 
  # screen width minus the box corners and spaces, then divided by three so we 
  # can build three parts.
  COLS=$(( ($COLUMNS - 9) / 3 ))

  # The middle part is left black, but zsh always rounds division so we 
  # actually can't be sure that all three segments will be the same width. We 
  # will use $COLS for the left and right bits and recalculate the middle bit 
  # by subtraction.
  COLS_MIDDLE=$COLS
  COLS_MIDDLE=$(( (($COLUMNS - 9) - ($COLS * 2)) - 10 ))
  # If we wind up with less than zero, we have no space left, so leave it out.
  if [ $COLS_MIDDLE -lt 0 ]; then
    COLS_MIDDLE=0
  fi

  # This is the actual top line. I know, kind of complicated. Sorry.
  PR_TOP_LINE='%F{256}┌─%F{245}─%F{240}─%{${(l:$COLS::─:)}%}%F{237}───╶╶'

  # Now build up the data segments for the actual prompt line.
  PR_RETURN_STATUS="%(?:%F{040}☼:%F{202}%}☹%f%b)"
  PR_USER="%F{075}`whoami` "
  PR_BOX="%F{024}❱ %F{075}`hostname` "
  PR_PWD=`pwd`
  # Replace your home path with "~" to shorten it.
  PR_PWD="%F{024}❱ %F{226}%B${PR_PWD/$HOME/~}%b%f"
  PR_GIT_INFO=`git_prompt_info`

  # This is now the full data line.
  PR_DATA_LINE="$PR_USER$PR_BOX$PR_PWD$PR_GIT_INFO"
  # Get its screen length by filtering out escape sequences.
  PR_DATA_LINE_LEN=${#${(S%%)PR_DATA_LINE//$~zero/}}

  # If the window is too narrow to fit everything, hide the box name. We 
  # presume that you can temporarily remember what computer you're using.
  if [ $(( $PR_DATA_LINE_LEN + 8 )) -gt $COLUMNS ]; then
    PR_DATA_LINE="$PR_USER$PR_PWD$PR_GIT_INFO"
    # Recalculate the length now that we removed a piece.
    PR_DATA_LINE_LEN=${#${(S%%)PR_DATA_LINE//$~zero/}}
  fi

  # Figure out how far it is from the end of the data line to the right edge of 
  # the terminal. We subtract a bit to account for box edges and the couple of 
  # spaces zsh leaves on the right side (so our box edge lines up with 
  # RPROMPT).
  PR_PAD=$(( $COLUMNS - $PR_DATA_LINE_LEN - 7 ))
  PR_RIGHT_END='${(l:$PR_PAD:: :)}%F{256}│'

  # Set up the whole prompt string.
  PR_PROMPT='${(e)PR_TOP_LINE}
%F{256}│%F{245} $PR_RETURN_STATUS  $PR_DATA_LINE
%F{256}╰─%F{245}─%F{239}╶%f '

  # Calculate how long to make the bottom right edge of the box and generate 
  # it, then set it in the RPROMPT string.
  RIGHT_LINE_LEN=$(( $COLS_MIDDLE / 2 ))
  RIGHT_LINE=${(l:$RIGHT_LINE_LEN::─:)}
}

setopt prompt_subst
autoload colors zsh/terminfo

# Set the prompts to the variables that will be  calculated in the precmd 
# function.
PROMPT='${(e)PR_PROMPT}'
#RPROMPT='${(e)PR_RPROMPT}'

# Set up these various git prompt plug-in strings to match the rest of the 
# prompt.
ZSH_THEME_GIT_PROMPT_PREFIX=" %F{024}⭠%f %F{075}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{202}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{040}✔"

# Load hook support and set up the precmd hook.
autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd

# Set up Vi mode indicator. Taken from Github here:
# /robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh
# This doesn't seem to affect anything if Vi mode is not turned on, so I think
# it's safe to leave in the theme all the time.
################################################################################

# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[white]%}-- NORMAL --%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi

# vim: set et ts=2 sw=2 ft=zsh:
