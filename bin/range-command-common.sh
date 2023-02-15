#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/depoxy/tig-newtons#🍎
# License: MIT. Please find more in the LICENSE file.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

range_command_print_target_object () {
  # Get tig process ID, considering this process hierarcy:
  #   gggpid: tig
  #   ggpid: tig config shell command
  #   gpid: ~/.kit/git/tig-newtons/bin/range-command-apply-rebase
  #   ppid: git
  #   pid: <this command> [sourced via range-seditor-bubble-up | range-seditor-bubble-down]
  # - Also, since when does ps prepend leading spaces? Weird. Remove them.
  local gpid="$(ps -o ppid= -p ${PPID} | tr -d ' ')"
  local ggpid="$(ps -o ppid= -p ${gpid} | tr -d ' ')"
  # Aka Good Grief, and Game.
  local gggpid="$(ps -o ppid= -p ${ggpid} | tr -d ' ')"
  local final_tag="🏁-UNTIL-HERE-🏁--🍏-PPID-${gggpid}-🍏"

  local final_commit
  final_commit="$(git rev-parse "refs/tags/${final_tag}" 2> /dev/null)"

  # MEH: We could double-check it's tig, e.g., for me,
  #   [ "$(cat /proc/${gggpid}/cmdline)" = "tig"]
  # but who knows what the user calls their's, or if they used options.
  # (E.g., if you run `tig refs`, cmdline file contains "tigrefs".)
  # - Though it's useful for debugging (see also `ps aux | grep ${gpid}`):
  #     >&2 echo -e "\n\ngpid ${gpid}\n" && >&2 cat /proc/${gpid}/cmdline
  #     >&2 echo -e "\n\nggpid ${ggpid}\n" && >&2 cat /proc/${ggpid}/cmdline
  #     >&2 echo -e "\n\ngggpid ${gggpid}\n" && >&2 cat /proc/${gggpid}/cmdline
  #     >&2 echo -e "\n\nfinal_tag ${final_tag}"
  #     >&2 echo -e "\nfinal_commit ${final_commit}\n"

  # Git echoes the query if no match, so check exit status.
  if [ $? -eq 0 ]; then
    printf "%s" "${final_commit}"
  fi
}

range_command_print_target_match () {
  local final_match

  local final_commit="$(range_command_print_target_object)"

  if [ -n "${final_commit}" ]; then
    # Note normally rebase todo lines are formatted with short SHAs, e.g.,
    #   pick b2d75b5 <commit message>
    # But range-command-apply-rebase configs rebase to use long SHAs with
    #   rebase.instructionFormat=%H
    # So the todo format we're examing uses long SHAs (and short), e.g.,
    #   pick b2d75b5 b2d75b5d82ff4329d427fd0b8724abe185067593
    final_match="/ ${final_commit}\$/"
  else
    # Note this matches twice in the awk, just how it flows.
    final_match='/^$/'
  fi

  printf "%s" "${final_match}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

TNEWTONS_CRUMB_PATH=".git/tig-newtons-range-command"

range_command_print_command () {
  cat "${TNEWTONS_CRUMB_PATH}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

print_todo_maybe () {
  local rebase_todo_path="$1"
  local context="$2"

  ${DX_SHOW_TODO} || return 0

  >&2 echo
  >&2 echo "rebase-todo ${context}:"
  >&2 echo "$(cat "${rebase_todo_path}" | grep -v "^#")"
  >&2 echo
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Complain if executed.
if [ "$0" = "${BASH_SOURCE}" ]; then
  >&2 echo "😶"
fi

