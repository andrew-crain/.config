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
  tmp_dir=$(mktemp -d)
  date_str=$(date "+%Y_%m_%d_%H_%M_%S")
  tmp_backup_file="$tmp_dir/base_$date_str.zip"
  zip -vr "$tmp_backup_file" "$HOMEBASE" -x "*.DS_Store" -x "$HOMEBASE/.private/*"
  mv "$tmp_backup_file" "$BACKUP_FOLDER"
}

mv_to_docs () {
  year=$(date "+%Y")
  docs_path_with_year="$DOCS_PATH/$year"
  filename=$(basename "$1")
  mv "$1" "$docs_path_with_year/$1"
}

to_pdf () {
  # Requires pdflatex
  path_without_ext=${1%.*}
  pandoc $1 -t pdf -o "$path_without_ext.pdf"
}

to_html () {
  path_without_ext=${1%.*}
  filename=$(basename $path_without_ext)
  pandoc $1 -s -t html -o "$path_without_ext.html" --katex
}

gh_link_as_https () {
  gh_url=$(git config --get remote.origin.url)
  truncated_gh_url=${gh_url#*\:}
  echo "https://github.com/$truncated_gh_url"
}
