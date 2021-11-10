" vim:fileencoding=utf-8:foldmethod=marker
" :help zo ==> see fold unfold command

set tabstop=4
set shiftwidth=4
set expandtab
set ai
set number
set hlsearch
set ruler
set autochdir
set nocompatible
set backspace=indent,eol,start

highlight Comment ctermfg=green
syntax enable
filetype plugin indent on

let mapleader = " " " map leader to Space

": changemewtf/not_plugins {{{

" FINDING FILES:

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer


" TAG JUMPING:

" This will check the current folder for tags file and keep going one directory up all the way to the root folder.
" So you can be in any sub-folder in your project and it'll be able to find the tags files.
set tags+=tags;/

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack

" THINGS TO CONSIDER:
" - This doesn't help if you want a visual list of tags


" AUTOCOMPLETE:

" The good stuff is documented in |ins-completion|

" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option

" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list


" FILE BROWSING:

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings

": }}}

": Copy to system clipboard {{{ 
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif
": }}}

": Emacs like inline move {{{
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
": }}}

": Center screen on next/previous selection {{{
nnoremap n nzz
nnoremap N Nzz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz
": }}}

": Plugins(maybe) {{{

": {{{ vim-go
" !git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_addtags_transform = "camelcase"
": }}}

": Leaderf {{{
" !git clone https://github.com/Yggdroot/LeaderF.git ~/.vim/pack/plugins/start/LeaderF
map <leader>f :Leaderf file<CR>
map <leader>s :Leaderf line<CR>
map <leader>b :Leaderf buffer<CR>
map <leader>i :Leaderf function<CR>
map <leader>r :Leaderf rg<CR>
map <leader>x :Leaderf command<CR>

" Open Leaderf in popup window and preview the result
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
" Disable icons
let g:Lf_ShowDevIcons = 0
": }}}

": }}}

": Syntax highlighting for fish {{{
if exists('b:current_syntax')
    finish
endif

syntax case match

syntax keyword fishKeyword begin function end
syntax keyword fishConditional if else switch
syntax keyword fishRepeat while for in
syntax keyword fishLabel case

syntax match fishComment /#.*/
syntax match fishSpecial /\\$/
syntax match fishIdentifier /\$[[:alnum:]_]\+/
syntax region fishString start=/'/ skip=/\\'/ end=/'/
syntax region fishString start=/"/ skip=/\\"/ end=/"/ contains=fishIdentifier
syntax match fishCharacter /\v\\[abefnrtv *?~%#(){}\[\]<>&;"']|\\[xX][0-9a-f]{1,2}|\\o[0-7]{1,2}|\\u[0-9a-f]{1,4}|\\U[0-9a-f]{1,8}|\\c[a-z]/
syntax match fishStatement /\v;\s*\zs\k+>/
syntax match fishCommandSub /\v\(\s*\zs\k+>/

syntax region fishLineContinuation matchgroup=fishStatement
            \ start='\v^\s*\zs\k+>' skip='\\$' end='$'
            \ contains=fishSpecial,fishIdentifier,fishString,fishCharacter,fishStatement,fishCommandSub,fishComment

highlight default link fishKeyword Keyword
highlight default link fishConditional Conditional
highlight default link fishRepeat Repeat
highlight default link fishLabel Label
highlight default link fishComment Comment
highlight default link fishSpecial Special
highlight default link fishIdentifier Identifier
highlight default link fishString String
highlight default link fishCharacter Character
highlight default link fishStatement Statement
highlight default link fishCommandSub fishStatement

let b:current_syntax = 'fish'
": }}}
