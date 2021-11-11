" vim:fileencoding=utf-8:foldmethod=marker
" :help zo/zc ==> see fold unfold command

"" TODO: LeaderF gtags not work, goalng lint

syntax enable
filetype plugin indent on

set nocompatible
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nobackup
set noswapfile
set ai
set autoread
set number
set hlsearch
set ruler
set autochdir
set paste
set ignorecase
set smartcase
set backspace=indent,eol,start
set background=dark
set ff=unix
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" After set background
highlight Comment ctermfg=green

" map leader to Space
let mapleader = " " 

" Change cursor to underline in insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e

if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=120
  endfunction
endif

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" Set working directory
nnoremap <leader>p :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Use q to close window in normale mode
noremap q <C-w>q

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>a

": changemewtf/not_plugins {{{

" FINDING FILES:

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

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
let g:go_gopls_enabled = 0
let g:go_list_type = "quickfix"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

augroup go

  au!
  au FileType go nmap <leader>t  <Plug>(go-test)

augroup END

": }}}

": Leaderf {{{

" TODO install
" !git clone https://github.com/Yggdroot/LeaderF.git ~/.vim/pack/plugins/start/LeaderF

" Open Leaderf in popup window and preview the result
"let g:Lf_WindowPosition = 'popup'
"let g:Lf_PreviewInPopup = 1
" Disable icons
let g:Lf_ShowDevIcons = 0
" Gtags, auto generate
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_Gtagslabel = 'native-pygments'
let g:Lf_RootMarkers = ['.git', '.hg', '.svn', 'go.mod']
" Don't use separator in statueline
let g:Lf_StlSeparator = { 'left': '', 'right': '' }

noremap <leader>x :Leaderf command<CR>
noremap <leader>i :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>s :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
noremap <leader>r :Leaderf rg<CR>
noremap <leader>? :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>. :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>, :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

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
