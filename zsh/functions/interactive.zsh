# This file is an easily source-able collection of _interactive_ functions.
# Anything that opens an editor, requires input, or is otherwise dependent
# on human interaction should be placed here.


zconf () {
  # Edit the ~/.zshrc file and immediately source it after exiting.
  hx ~/.zshrc 
  source ~/.zshrc
}

zenv () {
  hx ~/.zshenv
  source ~/.zshenv
}

zfint () {
  hx "$ZCONFIG_PATH/functions/interactive.zsh"
  source "$ZCONFIG_PATH/functions/interactive.zsh"
}

zfnint () {
  hx "$ZCONFIG_PATH/functions/non_interactive.zsh"
  source "$ZCONFIG_PATH/functions/non_interactive.zsh"
}

hxconf () {
  # Open the helix config file.
  hx ~/.config/helix/config.toml
}

hxlang () {
  # Open the helix languages config file.
  hx ~/.config/helix/languages.toml
}

dn () {
  # Create a new daily note if one doesn't exist and open it in helix.
  DN_NAME=`date "+%Y_%h_%d.md"`
  DN_PATH="$NOTES_PATH/daily/$DN_NAME"
  # Check if file exists.
  if [ ! -f "$DN_PATH" ]
  then
    # If it does not, create it and give it a heading with
    # the current date.
    # touch $DN_PATH
    date "+# %A, %B %d, %Y%n" > $DN_PATH
  fi
  hx $DN_PATH
}

nn () {
  # Create a new note. You don't have to give the md extension if you
  # don't want to.
  if [[ ! "$1" =~ \.md$ ]]
  then
    NOTE_NAME="$1.md"
  else
    NOTE_NAME="$1"
  fi
  hx --working-dir "$NOTES_PATH" "$NOTE_NAME"
}

fn () {
  # I'm not sure I love the look of this, but it is functional, and that's good enough
  # for now.
  rg --color=always --line-number --no-heading --smart-case "${*:-}" "$NOTES_PATH" |
  fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become(hx {1} +{2})'
}

ff_refresh () {
  # Only works on macOS.
  osascript <<EOF
activate application "Firefox"
tell application "System Events" to keystroke "r" using command down
EOF
}

pandoc_md_to_html () {
  # Takes as input a /path/to/file with no extension
  PATH_NO_EXT="$1"
  TITLE=`basename $PATH_NO_EXT`
  pandoc -s "$PATH_NO_EXT.md" -o "$PATH_NO_EXT.html" --metadata title=$TITLE
}

pandoc_md_to_html_and_refresh () {
  pandoc_md_to_html "$1"
  ff_refresh
}

html_on_save () {
  # Needs a better name
  # Always expects .md files. Currently no error handling for anything else.
  BASE_NAME=`basename $1 .md`
  DIR_NAME=`dirname $1`
  PATH_NO_EXT="$DIR_NAME/$BASE_NAME"
  echo $PATH_NO_EXT
  pandoc_md_to_html $PATH_NO_EXT
  PATH_WITH_HTML="$PATH_NO_EXT.html"
  FULL_HTML_PATH=`readlink -f $PATH_WITH_HTML`
  fftab "file://$FULL_HTML_PATH"
  fswatch -0 "$1" | xargs -0 -n 1 -I {} zsh -c pandoc_md_to_html_and_refresh "$PATH_NO_EXT"
}
