if [[ ! -o interactive ]]; then
    return
fi

compctl -K _gs gs

_gs() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(gs commands)"
  else
    completions="$(gs completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
