# Supercharged `tig` config 🍎

*The [tig](https://github.com/jonas/tig) config that delights you!*

*The fastest way to rebase using [tig](https://github.com/jonas/tig), or any other tool*

*Fixup, squash, move one, move many, reword, edit, drop, splice, dice, all from tig!*

*"I wanted the power of [git-interactive-rebase-tool](https://github.com/MitMaro/git-interactive-rebase-tool) from within [tig](https://github.com/jonas/tig)."* *— That's why this exists*

*Never leave [tig](https://github.com/jonas/tig) again (to run your favorite git commands)*

* [Features](#features)
* [Defaults](#defaults)
* [Setup](#setup)
* [Troubleshooting "loose objects"](#troubleshooting-loose-objects)

<!--
  https://github.com/ekalinin/github-markdown-toc
  https://github.blog/changelog/2021-04-13-table-of-contents-support-in-markdown-files/
-->

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

## Setup

### Choose a checkout location for this repo

If you want to use certain bindings (including bubble-up `<!>`, and most of
the rebase commands), you'll need to install tig-newtons to a specific path:

    ~/.kit/git/tig-newtons

Or you'll need to use the `TIGNEWTONSPATH` environ, e.g.,

    TIGNEWTONSPATH=path/to/tig-newtons tig

Which you could also export from your Bashrc or similar:

    export TIGNEWTONSPATH=path/to/tig-newtons

### Generate a custom `tig/config` file

The `tig/config` has to use full paths to `source` files,
so you need to generate a custom `tig/config` file.

Run the [customize.sh](customize.sh) command to generate the file.
It uses a template ([tig/config.customize](tig/config.customize))
to generate a similar file that uses your local project's path.

- After cloning the project, change to the root directory and
  create your `tig/config` file:

      cd path/to/tig-newtons
      ./customize.sh > tig/config

### Use your custom `tig/config` when you run `tig`

#### Option 1 — Specify at runtime

    XDG_CONFIG_HOME=path/to/tig-newtons/tig/config tig

#### Option 2 — Make your default config

    mkdir -p ~/.config/tig
    ln -s /path/to/tig-newtons/tig/config ~/.config/tig/config

#### Option 3 — Source from your own config

Edit `~/.config/tig/config` and add:

    source /path/to/tig-newtons/tig/config

### EDITOR

For the rebase range commands, if you'd like to use Vim as your editor with
a minimal config that includes some convenience functions — like `<Ctrl-s>`
to save your commit message and exit Vim in one fell swoop — set the
`TN_OPTION_EDITOR_VIM` environ, e.g.,

    export TN_OPTION_EDITOR_VIM=true
    tig

Or:

    TN_OPTION_EDITOR_VIM=true tig

You can also use the same config for the commit (`C`) and reword (`&`)
commands if you uncomment a few lines in your custom `tig/config`:

    source /home/user/.kit/git/tig-newtons/tig/bind-commit--minimal-editor
    source /home/user/.kit/git/tig-newtons/tig/bind-rebase--minimal-editor

Please inspect
[bin/editor-vim-0-0-insert-minimal.vimrc](bin/editor-vim-0-0-insert-minimal.vimrc)
to see the special Vim commands you can use.

### Gvim-Open-Kindness

The GVim open command (`v`) prefers `gvim-open-kindness`
if available, otherwise it falls back on raw `gvim` calls.

- You can clone and install `gvim-open-kindness` from sources:

  [https://github.com/DepoXy/gvim-open-kindness#🐬](https://github.com/DepoXy/gvim-open-kindness#🐬)

- The `gvim-open-kindness` adds a few niceties, such as fronting
  GVim after opening the file.

  - If `gvim-open-kindness` is not installed, you will have to
    to manually switch to the GVim app if the opened file is
    sent to an existing GVim instance.

Whether or not you install `gvim-open-kindness`, you can use the
`GVIM_OPEN_SERVERNAME` environ to set the GVim `--servername`, e.g.,

    GVIM_OPEN_SERVERNAME="my-gvim-server" tig

## Troubleshooting "loose objects"

Git might complain during garbage collection after you've used
`tig` and `tig-newtons` a lot.

- To be honest, the author has only seen this happen *once* in their
  own experience, but it's documented here should it happen again.

- If you see the following warning after git-commit:

    ```
    warning: The last gc run reported the following.
      Please correct the root cause and remove .git/gc.log
    Automatic cleanup will not be performed until the file is removed.

    warning: There are too many unreachable loose objects;
      run 'git prune' to remove them.
    ```

  There's likely a very reasonable explanation (and Git maybe should
  ease off a bit, especially if you're a *power tigger*).

- Git's problem is `too many unreachable loose objects`.

  - The most well known type of "loose object" is the *dangling commit*.

    This will happen because of rebase — all those original commits that
    were rebased are no longer part of any branch, and are therefore
    considered loose commits, or *dangling* commits.

    <!-- (At least I think it's all rebased commits. It might just be old HEADs. -->

  - There's also another type of loose object, the *dangling blob*.

    A dangling blob is simply a change to staging that is never committed.

    That is, from the first `git-add` until the subsequent `git-commit`,
    all the changes are recorded as blobs.

    So whether you use `git add <file>`, or `git add --patch`, or use
    `tig` to stage line-by-line (`1`), by the chunk-part (`2`), or
    by the chunk (`u`), each of those actions creates a dangling blob.

  - The author uses single-line staging most of the time, and I rebase
    so, so often, that I had 700 dangling commits, and ten times as many
    dangling blobs in the project that
    [I was hacking on](https://github.com/doblabs/easy-as-pypi#🥧)
    when Git barked about "too many loose objects".

    <!--
    (I'm also not sure if "unreachable" and "loose" are mutually *inclusive*,
    i.e., is there a difference between "unreachable" and "loose", or is the
    error describing the same thing?)
    -->

  - To probe your situation, run `git fsck` to see the dangling objects.

    - Use `git show <blob>` to see blobs, and `tig <commit>` to see comits.

- To resolve the situation, run something like this:

  ```
  git prune

  git fsck | wc -l
  # EXPECT: 0

  command rm .git/gc.log

  # Git will eventually run git-gc and be happy
  ```

## Bibliography

    man tig
    man tigrc
    man tigmanual

https://jonas.github.io/tig/doc/tigrc.5.html

https://github.com/jonas/tig/blob/master/tigrc

## More Awesome

`tig-newtons` maintained by DepoXy dev
environment orchestration project

https://github.com/DepoXy/depoxy#🍯

