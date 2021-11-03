Creating Your New Colorscheme With Lush
=================================

To create a Vim colorscheme in Lush you will:

1. Copy the lush-template
2. Create your colorscheme
    1. Import an existing non-lush colorscheme
3. Add your colorscheme to nvim
4. (optional) Export your colorscheme for distribution to non-Neovim clients.

See also, Advanced Usage and `:h lush` for more detailed documentation.

## 1. Copy the lush-template repo

Lush provides a starter structure that contains some boilerplate files and
(most) of the default highlight groups that you may wish to edit.

First, clone down a copy of the template from
[rktjmp/lush-template](https://github.com/rktjmp/lush-template) while also
picking a name for your colorscheme; don't worry, it's easy to change this later.

```sh
git clone git@github.com:rktjmp/lush-template.git <your_theme_name>
cd <your_theme_name>
```

Next we have to update some of the boilrplate files to match your new themes
name. You can copy and paste the script below into a zsh/bash prompt or perform
the steps manually.

```sh
sh << "EOF"
  git reset --soft 9069669
  git add .
  git commit --amend --no-edit
  LUSH_NAME=$(basename $(pwd))
  GIT_NAME=$(git config user.name)
  YEAR=$(date +"%Y")
  mv colors/lush_template.vim colors/$LUSH_NAME.vim
  mv lua/lush_theme/lush_template.lua lua/lush_theme/$LUSH_NAME.lua
  if command -v sed &> /dev/null; then
    sed -i "s/lush_template/$LUSH_NAME/g" colors/$LUSH_NAME.vim
    sed -i "s/COPYRIGHT_NAME/$GIT_NAME/g" LICENSE
    sed -i "s/COPYRIGHT_YEAR/$YEAR/g" LICENSE
    git add .
    git commit -m "Configure template for $LUSH_NAME, please enjoy using Lush!"
  else
    echo "Could not find sed, please manually replace 'lush_template' with '$LUSH_NAME' in colors/$LUSH_NAME.vim, and update the LICENCE file."
  fi
EOF
```

Lets examine the provided structure:

```
cool_name/
  |-lua/
    |-lush_theme/
      |-cool_name.lua # contains your lush spec, this is what we'll edit next
  |-colors/
    |-cool_name.vim   # used to load your colorscheme into neovim
  |-lush_build.lua    # used to export your colorscheme, we'll look at this later
```

## 2. Create your colorscheme

Open your `lua/lush_theme/*.lua` file and run `:Lushify`.

> Be sure to check out the the tutorial if you haven't yet (`:LushRunTutorial`)
> or see the [docs (:h lush)](doc/lush.txt) more details. Also see the examples
> folder in the main repository.

> You may prefer to disable LSP/Linters while editing your lush spec, as they can
> have trouble parsing the meta programming, or disable `undefined global`
> warninngs if your LSP supports annotations. For example, sumneko's
> lua-language-server accepts:
>
> ```lua
> ---@diagnostic disable: undefined-global
> local colorscheme = lush(function()
> -- your colorscheme here...
> ```

A simple lush-spec would look like this, though lush-template comes with a more
comprehesive list of groups.

```lua
-- In cool_name/lua/lush_theme/cool_name.lua

-- require lush
local lush = require('lush')
locah hsl = lush.hsl

-- lush() will parse the spec and
-- return a table containing all color information.
-- We return it for use in other files.
return lush(function()
  return {
    -- Define Vim's Normal highlight group.
    -- You can provide values with hsl/hsluv or anything that responds to `tostring`
    Normal { bg = hsl(208, 90, 30), fg = "#A3CFF5" },

    -- Make whitespace slightly darker than normal.
    -- you must define Normal before deriving from it.
    Whitespace { fg = Normal.fg.darken(40) },

    -- Make comments look the same as whitespace, but with italic text
    Comment { Whitespace, gui="italic" },

    -- Clear all highlighting for CursorLine
    CursorLine { },
  }
end)
```

### 2.1 Import an existing non-lush colorscheme

Lush includes a build in commnad to extract the currently loaded colorscheme,
and generate a `lush_spec` for it. This generated spec will be "greedy", it
will contain all currently applied highlight groups which will make it somewhat
disorganised and loud, but it may be useful as a starting point.

To import the curretly applied highlights, simply open a new file and run
`:LushImport`. The generated spec will be placed in the `z` register which you
can paste with `"zp`.

## 3. Add your colorscheme to nvim

Lush themes (like most vim colorschemes) act as plugins, so we have to add our
colorscheme to neovim's runtime before we can load it. Most people will do this via
a package manager.

Assuming your colorscheme is in `~/projects/cool_name`:

```lua
-- when using packer-nvim
use '~/projects/cool_name'
```

Afterwards we can apply the colorscheme like any other:

```viml
colorscheme cool_name
```

## 4. (optional) Export your colorscheme for distribution to non-Neovim clients.

Lush provides a highly extensible export system, called
[LushBuild](lush_build.md). It provides some built in tools to export your
colorscheme to:

- VimL (for use with Vim, or Neovim)
- Lua, with extension hooks to provide end-user configuration
- Various terminal emulators

Beyond these, you can easily extend LushBuild to export to any format you need.

See the associated [LushBuild](BUILD.md) guide for more information.