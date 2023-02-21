# Supercharged `tig` config

*The [tig](https://github.com/jonas/tig) config that does your laundry.*

*Add the capability of rebase to [tig](https://github.com/jonas/tig). And much more. Using only your config.*

*"I wanted the power of [git-interactive-rebase-tool](https://github.com/MitMaro/git-interactive-rebase-tool) from within [tig](https://github.com/jonas/tig)."*

*Never leave [tig](https://github.com/jonas/tig) again (to run your favorite git commands).*

## Features

'Generic' view bindings (that work from any view):

| Binding  | Description |
| -------: | :---------- |
| `<C-r>`  | Run [interactive-rebase-tool](https://github.com/MitMaro/git-interactive-rebase-tool) from revision under cursor (and quit tig if conflicts or rebase doesn't complete) |
|     `&`  | Reword revision under cursor |
|     `*`  | Edit revision under cursor (and quit tig) |
|     `+`  | Fixup staged to revision under cursor (and quit tig if conflicts) |
| `<C-t>`  | Create a WIP commit with uncommitted changes |
|     `^`  | Pop youngest (latest) commit if WIP commit |
|     `x`  | Copy SHA from revision under cursor to clipboard |
|     `T`  | Show datetime format and make date column wider, e.g., `2023-01-15 15:23` |
|     `R`  | Show relative format and make date column narrower, e.g., `3 hour` |
|     `v`  | Open line under cursor in gVim (prefers [`gvim-open-kindness`](https://github.com/landonb/home-fries/blob/release/bin/gvim-open-kindness) if installed) |
|     `V`  | Moved built-in `:show-version` from `v` to `V`, to make our gVim command easier to use |
|     `e`  | Like `v`, but opens line under cursor in terminal EDITOR |
|     `P`  | Copy file path to clipboard |
|     `.`  | Temporarily shells-out (shows terminal session; useful for reviewing previous command output) |
|     `C`  | Runs `git commit -v` |
| `<C-o>`  | Drop the selected revision |

'Main' and 'diff' view bindings:

| Binding  | Description |
| -------: | :---------- |
|     `!`  | Make the selected revision the most recent revision (aka, bubble-up) |

'Main' and 'diff' view bindings you can use to move one or more commits,
and optionally squash or fixup those commits:

| Binding  | Description |
| -------: | :---------- |
|     `[`  | Selects a single commit for the `\` command (sets a special "🚩-SELECTED-REV-🚩" tag) or to mark the start of range of commits (use `]` to mark the other end of the range) |
|     `]`  | After `[`, use to mark a range of commits for the `\` command (removes the "🚩-SELECTED-REV-🚩" tag and uses "🚩-START-HERE-🚩" and "🚩-UNTIL-HERE-🚩" tags to mark the range) |
|     `{`  | Removes all special tags (i.e., "cancel" the `[` and `]` commands) |
|     `\`  | Selects the target commit and performs an action (see the list that follows) on the single `[` commit, or on the range specified by `[` and `]` |

`\` command actions:

- These actions work on a single commit, or on a range of commits,
  using the target commit for reference.

- The special tags are necessary to tell the sequence editor what to
  do (we could alternatively use a temporary file under the local
  `.git/` directory, but using tags lets the user see what commit(s)
  they selected).

- To act on one commit, first use the `[` command to select a commit,
  then select the target commit and press `\` to perform one of the
  following actions.

- To act on a range of commits, first use the `[` command to select
  one end of then range, then use `]` to select the other end. Finally,
  select the target commit and press `\` to perform one of the
  following actions:

| Action   | Description |
| -------: | :---------- |
|      `p` | Cherry pick the selected commit or range of commits (the target commit is ignored) |
|      `b` | Move the selected commit or range of commits (chronologically) before target commit |
|      `a` | Move the selected commit or range of commits (chronologically) after target commit |
|      `t` | Move the selected commit or range of commits (chronologically) to be latest commits |
|      `s` | Squash the selected commit or range of commits into the target commit |
|      `f` | Fixup the selected commit or range of commits into the target commit |

- Note that, except for cherry-pick, the previous actions only work on the
  current branch.

  - E.g., if you run `tig some-other-branch`, you can only cherry-pick from
    that branch; you cannot move, squash, or fixup commits.

Masked bindings:

- The `^` mapping masks tig's built-in `:toggle rev-filter` binding [but I tested `rev-filter` and it changes nothing for me, so I'm not remapping the command elsewhere, like I did with `V`/`:show-version`]

- The `C` mapping masks tig's built-in `?git cherry-pick %(commit)` binding.
  - Use the `\` action to cherry-pick; and use `C` to call `git commit -v`.

- The `v` mapping masks tig's built-in `:show-version` binding, which is
  re-bound to `V` (so that we can use `v` to open the line under the cursor
  in gVim).

## Defaults

| Setting | Description |
| :------ | :---------- |
| `set commit-order = topo` | Order commits topologically |
| `set horizontal-scroll = 25%` | Scroll 25% of the view width |
| `set blame-options = -C -C -C` | Blame lines from other files |
| `set reference-format = (branch) <tag> [remote]` | Show branch names in `()` and tag names in `<>` |
| `set line-graphics = utf-8` | Choose UTF-8 glyphs for the revision history/ancestry marks |
| `set ignore-case = smart-case` | Naturally |
| `set blame-view = date:default author:abbreviated file-name:auto id:yes,color line-number:yes,interval=5 text` | Configure blame view columns |
| `set diff-options = --src-prefix=a/ --dst-prefix=b/` | Undoes [git-smart](https://github.com/landonb/git-smart#💡) `.gitconfig` setting that breaks `tig-newtons` 'v' command |

<!-- Markdown tables do not support multiline cells, nor code blocks.
     Here's the closest I could get:

| `set blame-view = date:default \`<br>`      author:abbreviated \`<br>`      file-name:auto \`<br>`      id:yes,color \`<br>`      line-number:yes,interval=5 text` | Configure blame view columns |
-->

## Usage

### Option 1 — Specify at runtime

```sh
  XDG_CONFIG_HOME=path/to/tig-newtons/tig/config tig
```

### Option 2 — Make your default config

```sh
  mkdir -p ~/.config/tig
  ln -s /path/to/tig-newtons/tig/config ~/.config/tig/config
```

### Option 3 — Source from your own config

Edit `~/.config/tig/config` and add:

```config
  source /path/to/tig-newtons/tig/config
```

## Setup

If you want to use certain bindings (like `!` bubble-up, or most of the
rebase commands), you'll need to install tig-newtons to a specific path:

```sh
  ~/.kit/git/tig-newtons
```

Or you'll need to use the `TIGNEWTONSPATH` environ, e.g.,

```sh
  TIGNEWTONSPATH=path/to/tig-newtons tig
```

### EDITOR

If you'd like to use Vim as your editor with a minimal config that includes
some convenience functions — like `<Ctrl-s>` to save your commit message and
exit Vim in one fell swoop — set the `TN_OPTION_EDITOR_VIM` environ, e.g.,

```sh
  export TN_OPTION_EDITOR_VIM=true
  tig
```

Or:

```sh
  TN_OPTION_EDITOR_VIM=true tig
```

Please inspect
[bin/editor-vim-0-0-insert-minimal.vimrc](bin/editor-vim-0-0-insert-minimal.vimrc)
to see the special Vim commands you can use.

## Bibliography

```sh
  man tig
  man tigrc
  man tigmanual
```
https://jonas.github.io/tig/doc/tigrc.5.html

https://github.com/jonas/tig/blob/master/tigrc

## Find Your Awesome

`tig-newtons` maintained by DepoXy dev
environment orchestration project

https://github.com/depoxy/depoxy#🍯 _[COMING 2023!]_

