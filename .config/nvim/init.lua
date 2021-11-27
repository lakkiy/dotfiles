local g = vim.g
local o = vim.o
local cmd = vim.cmd
local map = function(key)
	-- get the extra options
	local opts = {noremap = true, silent = true}
	for i, v in pairs(key) do
		if type(i) == 'string' then opts[i] = v end
	end

	-- basic support for buffer-scoped keybindings
	local buffer = opts.buffer
	opts.buffer = nil

	if buffer then
		vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
	else
		vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
	end
end

-----------------------------------------------------------
-- General
-----------------------------------------------------------
cmd [[highlight Comment ctermfg=green]] 
o.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'
o.clipboard = 'unnamedplus' -- copy/paste to system clipboard
o.swapfile = false -- don't use swap file

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
o.number = true -- show line number

-----------------------------------------------------------
-- Key Mapping 
-----------------------------------------------------------
-- use space as a the leader key
g.mapleader = ' '

-- clear search highlighting
map {'n', '<Leader>c', ':nohl<CR>'}

-- q to quit window
map {'n', 'q', '<C-w>q'}

-- close all windows and exit from neovim
map {'n', '<Leader>q', ':qa<CR>'}

-- set working directory
map {'n', '<Leader>p', ':lcd %:p:h<CR>'}

-- Opens an edit command with the path of the currently edited file filled in
map {'n', '<Leader>e', ':e <C-R>=expand("%:p:h") . "/" <CR>'}

-- center screen on next/previous selection
map {'n', 'n', 'nzzzv'}
map {'n', 'N', 'Nzzzv'}
map {'n', '<C-o>', '<C-o>zz'}
map {'n', '<C-i>', '<C-i>zz'}
map {'n', '<C-]>', '<C-]>zz'}
map {'n', '<C-t>', '<C-t>zz'}
map {'n', '<C-f>', '<C-f>zz'}
map {'n', '<C-b>', '<C-b>zz'}

-- Emacs like inline move
map {'i', '<C-a>', '<Home>'}
map {'i', '<C-e>', '<End>'}
map {'i', '<C-b>', '<Left>'}
map {'i', '<C-f>', '<Right>'}

-- window split and move
map {'n', '<Leader>h', ':<C-u>split<CR>'}
map {'n', '<Leader>v', ':<C-u>vsplit<CR>'}
map {'n', '<C-j>', '<C-w>j'}
map {'n', '<C-k>', '<C-w>k'}
map {'n', '<C-l>', '<C-w>l'}
map {'n', '<C-h>', '<C-w>h'}

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- disable builtins plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
    "matchparen"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-----------------------------------------------------------
-- Packer
-----------------------------------------------------------
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
	use {
		-- python3 -m pip install --user --upgrade pynvim
		'Yggdroot/LeaderF',
		run = ':LeaderfInstallCExtension'
		--setup = function()
		--	g.Lf_ShowDevIcons = 0		
		--	g.Lf_GtagsAutoGenerate = 1
		--	g.Lf_Gtagslabel = 'native-pygments'
		--	g.Lf_RootMarkers = {'.git', '.hg', '.svn', 'go.mod'}
		--	g.Lf_StlSeparator = {left = '', right = ''}
		--	-- <Leader>f and <Leader>b is set as default
		--	map {'n', '<Leader>x', ':Leaderf command<CR>'}
		--	map {'n', '<Leader>i', ':<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>'}
		--	map {'n', '<Leader>s', ':<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>'}
		--	map {'n', '<Leader>r', ':Leaderf rg<CR>'}
		--	map {'n', '<Leader>?', ':<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>'}
		--	map {'n', '<Leader>.', ':<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>'}
		--	map {'n', '<Leader>,', ':<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>'}
		--end
	}

	use {
		'fatih/vim-go',
		run = ':GoUpdateBinaries',
		ft = {'go'}
		--setup = function() 
		--	g.go_fmt_command = 'goimports'
		--	g.go_fmt_fail_silently = 1
		--	g.go_addtags_transform = 'camelcase'
		--	g.go_gopls_enabled = 0
		--end
	}

	if packer_bootstrap then
		require('packer').sync()
	end
end)
