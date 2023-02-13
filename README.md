# Supercharged `tig` config

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
|     `P`  | Copy file path to clipboard |
|     `V`  | Moved built-in `:show-version` from `v` to `V`, to make our gVim command easier to use |

'Main' and 'diff' view bindings:

| Binding  | Description |
| -------: | :---------- |
|     `!`  | Make the selected revision the most recent revision (aka, bubble-up) |

Masked:

- The `^` mapping masks tig's built-in `:toggle rev-filter` binding [but I tested `rev-filter` and it changes nothing for me, so I'm not remapping the command elsewhere, like I did with `V`/`:show-version`]

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

Edit ~/.config/tig/config and add:

```config
  source /path/to/tig-newtons/tig/config
```

## Setup

If you want to use certain bindings (so far just `!` bubble-up),
you'll need to install tig-newtons to a specific path:

```sh
  ~/.kit/git/tig-newtons
```

Or you'll need to use the `TIGNEWTONSPATH` environment, e.g.,

```sh
  TIGNEWTONSPATH=path/to/tig-newtons tig
```

## Bibliography

```sh
  man tig
  man tigrc
  man tigmanual
```
https://jonas.github.io/tig/doc/tigrc.5.html

https://github.com/jonas/tig/blob/master/tigrc

`tig-newtons` maintained by DepoXy dev
environment orchestration project

https://github.com/depoxy/depoxy#🍯 _[COMING 2023!]_

