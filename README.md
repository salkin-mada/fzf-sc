# fzf-sc

![Fuzzy scales](assets/fzfsc-fuzzyscales.gif)

Use the power of [fzf](https://github.com/junegunn/fzf) to get the best out of [SuperCollider](https://supercollider.github.io/):

Fuzzy search basically anything in SuperCollider and execute SuperCollider code with the result of that search.

## Requirements

- [nvim-fzf](https://github.com/vijaymarupudi/nvim-fzf)(recommended) or [fzf.vim](https://github.com/junegunn/fzf.vim)
- [scnvim](https://github.com/davidgranstrom/scnvim)
- Nvim >= v0.7

## Installation

### packer.nvim

```lua
use {
	'madskjeldgaard/fzf-sc',
	after = "scnvim",
	config = function()
		require'fzf-sc'.setup({ 
			search_plugin = "nvim-fzf", 
			options = {
				height = 50,
				width = 33,
				-- row = 4,
				-- col = 4,
				relative = 'editor',
				border = false,
				fzf_binary = "fzf" -- Or "skim"
			}
		})
	end,
	requires = {
		'vijaymarupudi/nvim-fzf',
		'davidgranstrom/scnvim'
	}
}
```

### vim-plug
For vim-plug users, add this to your init.vim:

`Plug 'madskjeldgaard/fzf-sc'`

Then run `:PlugInstall`.

## Setup

Somewhere in your config file for neovim, add `lua require'fzf-sc'.setup()` if you're using `init.vim` or `require'fzf-sc'.setup()` for init.lua.

### Configuration

fzf-sc may be configured by supplying a table to the setup function in a lua file:

```lua
require'fzf-sc'.setup({
	-- Set to "nvim-fzf" if you have that plugin installed
	search_plugin = "fzf.vim" 
})
```

## Available commands
`:FzfSC`

Fuzzy search the fuzzy finders. Gets list of all fuzzy search commands. Choose one and execute it.

To see the rest, type `:FzfSC<tab>` on the command line to autocomplete the available commands.

Invoking the commands directly works like this. An example using the `scales` finder:

```bash
:FzfSC play_scales
```

## Make your own fuzzy finder

To make your own finder, you need two things: Some supercollider code that generates an array and a callback (can be either SuperCollider or Lua). The callback is a piece of code that takes the result of your choice and does something with it. 

### Using a supercollider callback

Here is an example of getting all quarks as input and then installing the chosen item in the return code. The return code is a string where `%s` is replaced with the result of the fuzzy search, eg in the example below it will be the name of the quark the user chooses.

By adding your finder to `fzf-sc/finders`, it will automatically show up when you run `:FzfSC` as well as in autocompletion when typing `:FzfSC <tab>`.

```lua
require"fzf-sc/finders".my_quark_installer = 
function()
	local sc_code = [[Quarks.fetchDirectory; Quarks.all.collect{|q| q.name}]];
	local supercollider_callback = [[Quarks.install("%s");]];

	require"fzf-sc/utils".fzf_sc_eval(sc_code, supercollider_callback)
end
```

### Using a lua callback

Instead of using SuperCollider in the callback, it is also possible to pass your choice from the fuzzy list to a lua function and make use of Neovim's lua api.

```lua
require"fzf-sc/finders".my_quark_browser = 
function()

	-- Get a list of all quark folders in your system and convert them to full paths
	local sc_code = [[PathName(Quarks.folder).folders.collect{|folder| folder.fullPath}
]];

	-- This callback opens the chosen folder in a new tab
	local callback = function(val) 
		vim.cmd("tabnew " ..val) 
	end

	require"fzf-sc/utils".fzf_sc_eval(sc_code, callback)
end
```

### More inspiration 

For more inspiration [see this file](lua/fzf-sc/finders.lua). 

## Contributing a finder

Finders are defined in [this file](lua/fzf-sc/finders.lua). 

If you feel like contributing a finder, that's where to do it. Just add a function like the ones in that file and it will automatically show up as an option for a command when autocompleting `:FzfSC<tab>` or just running `:FzfSC`.
