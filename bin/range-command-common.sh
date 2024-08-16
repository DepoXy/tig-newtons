# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/tig-newtons#🍎
# License: MIT. Please find more in the LICENSE file.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

range_command_print_start_match () {
  local start_match

  local start_rev="$(range_command_print_chosen_rev)"
  if [ -z "${start_rev}" ]; then
    start_rev="$(range_command_print_start_rev)"
  fi

  if [ -n "${start_rev}" ]; then
    # Note normally rebase todo lines are formatted with short SHAs, e.g.,
    #   pick b2d75b5 <commit message>
    # But range-command-apply-rebase configs rebase to use long SHAs with
    #   rebase.instructionFormat=%H
    # So the todo format we're examing uses long SHAs (and short), e.g.,
    #   pick b2d75b5 b2d75b5d82ff4329d427fd0b8724abe185067593
    start_match="/ ${start_rev}\$/"
  else
    start_match='//'
  fi

  printf "%s" "${start_match}"
}

range_command_print_until_match () {
  local until_match

  local until_rev="$(range_command_print_chosen_or_until_rev)"

  if [ -n "${until_rev}" ]; then
    until_match="/ ${until_rev}\$/"
  else
    until_match='//'
  fi

  printf "%s" "${until_match}"
}

range_command_print_target_match () {
  local target_match

  local target_rev="$(range_command_print_target_rev)"

  if [ -n "${target_rev}" ]; then
    target_match="/ ${target_rev}\$/"
  else
    # Note this matches twice in the awk, just how it flows.
    target_match='/^$/'
  fi

  printf "%s" "${target_match}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

range_command_print_chosen_rev () {
  local chosen_tag="$(range_command_print_chosen_tag)"

  range_command_print_tag_object "${chosen_tag}"
}

range_command_print_start_rev () {
  local start_tag="$(range_command_print_start_tag)"

  range_command_print_tag_object "${start_tag}"
}

range_command_print_until_rev () {
  local until_tag="$(range_command_print_until_tag)"

  range_command_print_tag_object "${until_tag}"
}

range_command_print_target_rev () {
  local target_tag="$(range_command_print_target_tag)"

  range_command_print_tag_object "${target_tag}"
}

range_command_print_chosen_or_until_rev () {
  local until_rev="$(range_command_print_chosen_rev)"
  if [ -z "${until_rev}" ]; then
    until_rev="$(range_command_print_until_rev)"
  fi

  printf "%s" "${until_rev}"
}

# ***

range_command_print_tag_object () {
  local tag_name="$1"

  local object_id
  object_id="$(git rev-parse "refs/tags/${tag_name}" 2> /dev/null)"

  # Git echoes the query if no match, so check exit status.
  if [ $? -eq 0 ]; then
    printf "%s" "${object_id}"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# - Perhaps one day we'll PR tig to highlight the first commit selected,
#   but for now we'll use a temporary tag to mark the first selection.
#   (This also lets us store a reference to the first commit selected,
#    but we could alternatively use a file under .git/, so using a tag
#    vs. meta file is more about showing user their selection than it
#    is about needing to cache the first commit reference.)
#   - There are emoji racing flags, but not the green starting flag.
#     - So what's a good, catchy symbol to use?
#     - Note that tig doesn't show all emoji characters, or at least
#       that's my experience on Linux Mint 19.3 (which is weird,
#       because I see these same symbols fine in gVim and bash).
#     - Looking at the green emojis and flags:
#         git tag -f "🚩🍏🪴🌱🐲🐉🦕🦚💚🫑🥒🥦🔋📗💵💹🧪♎✅✳️-❇️-🈯🟢-🟩🏁🎌🏴🏳-🏳️"
#                     ^^^^  ^^^^^^^^  ^^  ^^^^^^^^^^^^  ^^^^^^^^^^     ^^^^^^^^^^^
#       The ^^-underscored emoji appear in tig,
#       and any emoji followed by a dash appears only uses a single
#       character width in tig though the emoji is 2 em, so it bleeds.
#     - Though maybe the "red flag" emoji isn't the worst, it does
#       draw the eye better than green, methinks.

# FIXME/2023-02-15 16:08: PICK-HERE tag? START-RANGE?
# - You could even swap START/UNTIL if user tags in reverse order...

# FIXME: Rename fcn. to match tag name.
range_command_print_chosen_tag () {
  local chosen_tag="🚩-SELECTED-REV-🚩--🍏-PPID-$(tig_pid)-🍏"

  printf "%s" "${chosen_tag}"
}

range_command_print_start_tag () {
  local start_tag="🚩-START-HERE-🚩--🍏-PPID-$(tig_pid)-🍏"

  printf "%s" "${start_tag}"
}

range_command_print_until_tag () {
  local until_tag="🏁-UNTIL-HERE-🏁--🍏-PPID-$(tig_pid)-🍏"

  printf "%s" "${until_tag}"
}

range_command_print_target_tag () {
  local target_tag="🏁-TARGET-REV-🏁--🍏-PPID-$(tig_pid)-🍏"

  printf "%s" "${target_tag}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Get tig process ID, considering this process hierarcy:
#   gggpid: tig  # ggg, aka Good Grief, and Game.
#   ggpid: tig config shell command
#   gpid: ~/.kit/git/tig-newtons/bin/range-command-apply-rebase
#   ppid: git
#   pid: <this command> [sourced via range-seditor-bubble-up | range-seditor-bubble-down]
# - Also, ps prepends leading spaces; use `tr` to remove them.
# - MEH: We could double-check it's tig, e.g., for me,
#     [ "$(cat /proc/${gggpid}/cmdline)" = "tig"]
#   but who knows what the user calls their's, or if they used options.
#   (E.g., if you run `tig refs`, cmdline file contains "tigrefs".)
#   - If you need to debug, try this (see also `ps aux | grep ${gpid}`):
#       >&2 echo -e "\n\ngpid ${gpid}\n" && >&2 cat /proc/${gpid}/cmdline
#       >&2 echo -e "\n\nggpid ${ggpid}\n" && >&2 cat /proc/${ggpid}/cmdline
#       >&2 echo -e "\n\ngggpid ${gggpid}\n" && >&2 cat /proc/${gggpid}/cmdline
tig_pid () {
  local gpid="$(ps -o ppid= -p ${PPID} | tr -d " ")"
  local ggpid="$(ps -o ppid= -p ${gpid} | tr -d " ")"
  local gggpid="$(ps -o ppid= -p ${ggpid} | tr -d " ")"

  printf "%s" "${gggpid}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

TNEWTONS_CRUMB_PATH=".git/tig-newtons-range-command"

range_command_print_command () {
  if [ -f "${TNEWTONS_CRUMB_PATH}" ]; then
    cat "${TNEWTONS_CRUMB_PATH}"
  else
    # For 'pick' and 'latest' actions, which don't call
    # set_command_crumb.
    printf "%s" "pick"
  fi
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

PROG_NAME="range-command-common.sh"

# Alert if not being sourced in Bash, or if being executed.
if [ -z "${BASH_SOURCE}" ]; then
  >&2 echo "ERROR: Source this script with Bash [${PROG_NAME}]"

  false
elif [ "$0" = "${BASH_SOURCE[0]}" ]; then
  >&2 echo "ALERT: You’re better off sourcing this file [${PROG_NAME}]"

  false
fi

