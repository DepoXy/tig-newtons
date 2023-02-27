#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/depoxy/tig-newtons#🍎
# License: MIT. Please find more in the LICENSE file.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

customize () {
  cd "$(dirname "$0")"

  export TIGNEWTONSPATH="$(pwd)"

  cat "tig/config.customize" | envsubst
}

# ***

check_deps () {
  hint_envsubst_deb () { >&2 echo "  sudo apt-get install gettext"; }
  hint_envsubst_brew () { >&2 echo "  brew install gettext"; }
  os_is_macos () { [ "$(uname)" = 'Darwin' ]; }

  if ! command -v envsubst > /dev/null; then
    >&2 echo 'ERROR: Requires `envsubst`'
    >&2 echo '- Hint: Install `gettext`, e.g.:'
    os_is_macos && hint_envsubst_brew || hint_envsubst_deb 

    exit 1
  fi
}

main () {
  check_deps
  customize "$@"
}

main "$@"

