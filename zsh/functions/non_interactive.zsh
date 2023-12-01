# Place any functions here that aren't specifically interactive.
# These could be shorthand commands, general automations, or anything
# that runs without human input.


basejump () {
  cd "$HOMEBASE"
}

zsrc () {
  # Shorthand for sourcing the .zshrc file
  source ~/.zshrc
}

cat () {
  # Replace cat with bat.
  bat "$@";
}

ls () {
  # Replace ls with exa.
  exa "$@"
}

tailscale () {
  # Shorthand for tailscale.
  /Applications/Tailscale.app/Contents/MacOS/Tailscale "$@"
}

fftab () {
  open -a Firefox "$1"
}

ffsearch () {
  # May want to make this grab all arguments and join them with
  # spaces. That's easier to type.
  open -a Firefox "https://duckduckgo.com/?q=$*"
}

hn () {
  fftab "https://news.ycombinator.com"
}

parse_git_branch () {
  # Extract the current git branch for pretty-printing if one exists.
  # If there is no git project here, the output is just piped to /dev/null.
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

backup_base () {
  TMP_DIR=$(mktemp -d)
  DATE_STR=$(date "+%Y_%m_%d_%H_%M_%S")
  BACKUP_PATH="$TMP_DIR/base_$DATE_STR.zip"
  COPY_TARGET="/Users/s1931396/OneDrive - 7-Eleven, Inc/home/backups/"
  zip -vr "$BACKUP_PATH" "$HOMEBASE" -x "*.DS_Store" -x "$HOMEBASE/.private/*"
  mv "$BACKUP_PATH" "$COPY_TARGET"
}
