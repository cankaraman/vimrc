" Downloa vim-plug and pathogen when vim runs for the very first time {{{
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!mkdir -p .vim/autoload && curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
if empty(glob("~/.vim/autoload/pathogen.vim"))
    execute '!mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim'
endif
"}}}
" Plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'michaeljsmith/vim-indent-object'
Plug 'bkad/CamelCaseMotion'
Plug 'SirVer/ultisnips'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', {'on': 'Files'}
Plug 'ycm-core/YouCompleteMe'
Plug 'jiangmiao/auto-pairs'
Plug 'gryf/pylint-vim', {'for': 'python'}
" Plug 'maxbrunsfeld/vim-yankstack'
Plug 'justinmk/vim-sneak'
Plug 'turbio/bracey.vim'
Plug 'adelarsq/vim-matchit'
" Plug 'jvanja/vim-bootstrap4-snippets', { 'for': 'html' }
" Plug 'tpope/vim-vinegar'
call plug#end()
execute pathogen#infect()
call pathogen#helptags()
"}}}
" all sets {{{
let &number = 1
set formatoptions+=j " Delete comment character when joining commented lines
set history=1000
set ttimeout
set ttimeoutlen=100
set scrolloff=1
set tabpagemax=50
set autoread
set incsearch
set hlsearch
set showmatch		" Show matching brackets.
set ignorecase
set smartcase	
set mouse=a
set showcmd
set background=dark
syntax on
set encoding=utf-8
filetype indent plugin on
set tags=tags
" set hidden "to quit unclosed buffers wtih :q
set splitright
set pastetoggle=<F2>
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" autocmd FileType * call <SID>def_base_syntax() " autocmd Syntax may be better
" function! s:def_base_syntax()
"   " Simple example
"   syntax match commonOperator "\(+\|=\|-\|\^\|\*\)"
"   hi link commonOperator Special
" endfunction
"}}}
"mappings for all filetypes {{{
"---------------------------------------------------------------------------------------------
"experimental key mappings
" till the end of the line
nnoremap L g_
onoremap L g_
" till the begining of the line
nnoremap H ^
onoremap H ^

nnoremap <F5> :buffers<CR>:buffer<Space>

" Map w!! to write file with sudo, when forgot to open with sudo.
cnoremap w!! w !sudo tee % >/dev/null

" Map F4 key to toggle spell checking
noremap <F4> :setlocal spell! spelllang=en_us<CR>

"make Y and V same as D&C
nnoremap Y yg_
" nnoremap V vg_

"search and replace
nnoremap <C-f> /
nnoremap <C-x> :nohlsearch<CR>
nnoremap <C-g> :%s//gc<left><left><left>

"copy to clipboard
vnoremap <C-c> "+y

"custom key mappings
"for turkish q only
nnoremap + $
vnoremap + $
onoremap + $
"move around
nnoremap ö <C-o>
nnoremap ç <C-i>
nnoremap şş :bn<CR>
nnoremap şi :bp<CR>
"jump to definition
nnoremap ü <C-]> 

inoremap jk <ESC><right>
vnoremap . :norm.<CR>

" nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>a <ESC>gg<S-v>G
"paste without yanking the seleceted text
vnoremap p "_dP

"free special input map first
inoremap <C-k> <nop>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-k> <Up>

"split mappings & settings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

onoremap " i"
onoremap ' i'
onoremap ( i(
onoremap [ i[
onoremap { i{
"feyz almalik
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F(vi(<cr>
augroup markdownExample
    autocmd!
    autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
augroup end

"quick vimrc edit
nnoremap <leader>v :split $MYVIMRC<CR>
augroup myvimrc
    autocmd!
    autocmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc source $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
"source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
"}}}
"autocmds {{{
"---------------------------------------------------------------------------------------------------

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    "always use case sensitive comparison
    autocmd FileType vim inoreabbrev <buffer> == ==#
    autocmd FileType vim inoreabbrev <buffer> != !=#
augroup end

augroup jumpToLastPosition
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif 
augroup end

augroup mips
    au!
    au BufRead,BufNewFile *.asm setlocal filetype=mips
augroup end

augroup filetype_html
    autocmd!
    autocmd FileType html nnoremap <buffer> <leader>r :BraceyReload<cr>
    " autocmd FileType html inoremap <leader>r <Esc>:BraceyReload<cr>a
    autocmd FileType html nnoremap <buffer> <leader>b :Bracey<cr>
    autocmd FileType html setlocal tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
    "js comment in html
    autocmd FileType html nnoremap <buffer> <leader>c I// <esc>
    autocmd FileType nginx setlocal commentstring=#\ %s
augroup end

"python mappings
augroup filetype_python
    autocmd!
    autocmd FileType python nnoremap <buffer> <leader>t :exec '!pytest' shellescape(@%, 1)<cr>
    autocmd FileType python nnoremap <buffer> <leader>r :exec '!python' shellescape(@%, 1)<cr>
    "lint and save
    autocmd FileType python nnoremap <leader>l :PymodeLintAuto<cr>:w<cr> 
    autocmd FileType htmldjango,html inoremap <buffer> {% {%  %}<Left><Left><Left>
    autocmd FileType htmldjango,html inoremap <buffer> {7 {%  %}<Left><Left><Left>
augroup end
" }}}
"plugin related {{{
"---------------------------------------------------------------------------------------------------
" don't let auto-pairs use <c-h>
if !exists('g:AutoPairsMapCh')
  let g:AutoPairsMapCh = 0
end

"vim sneak
nmap , <Plug>Sneak_;
nmap ; <Plug>Sneak_,
let g:sneak#s_next = 1
" 2-character Sneak (default)
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
" visual-mode
xmap s <Plug>Sneak_s
xmap S <Plug>Sneak_S
" operator-pending-mode
omap s <Plug>Sneak_s
omap S <Plug>Sneak_S
" disable vSneak_S for vim-surround vS
vmap <nop> <Plug>Sneak_S

"CamelCaseMotion
nmap w <Plug>CamelCaseMotion_w
nmap b <Plug>CamelCaseMotion_b
nmap e <Plug>CamelCaseMotion_e

"NERDtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '^__pycache__$', '\.bin$', '\.db$']
fun! ToggleNERDTreeWithRefresh()
    :NERDTreeToggle 
    if(exists("b:NERDTreeType") == 1)
        call feedkeys("R")  
    endif   
endf 

nnoremap <silent> <c-n> :call ToggleNERDTreeWithRefresh()<cr>

"vim themes
let g:gruvbox_italic=1
colorscheme gruvbox

"grepper
nnoremap <leader>g :Grepper<cr>
let g:grepper = { 'next_tool': '<c-h>' }
nmap gs  <plug>(GrepperOperator)
vmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)

"FZF
nnoremap <leader>o :Files<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""' "need to install silversearcher-ag
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-i': 'split',
            \ 'ctrl-s': 'vsplit' }

"python mode
let g:pymode_python = 'python3'
let g:pymode_options_colorcolumn = 0
let g:pymode_rope = 1
let g:pymode_rope_regenerate_on_write = 1
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_autoimport = 1
set completeopt=menuone,noinsert
" let g:pymode_rope_rename_bind = '<C-c>r'
let g:pymode_lint_ignore = ["E501","W0611","W0404","E702", "E711"]
let g:pymode_lint_unmodified = 1
" let g:pymode_lint_on_fly = 1
let g:pymode_run = 0
let g:pymode_lint_on_write = 1
let g:pymode_syntax_highlight_equal_operator = 1
let g:pymode_syntax_space_errors = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_autoimport_modules = ['os', 'django']

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"Bracey HTML mappings
" let g:bracey_server_port = 6001
" let g:bracey_refresh_on_save =1
"
"}}}

"--------------------------------------
"vimscript experiments
iabbrev retrun return
hi SpellBad cterm=underline
nnoremap <leader>d :execute "normal! ddi\<c-g>u\edd"<cr>
cnoremap <c-h> <left>
cnoremap <c-l> <right>
" delete first space
nnoremap <silent> d<space> :<c-u>call <SID>DeleteSpace()<cr>
function! s:DeleteSpace()
    " accept the match under cursor with 'c' flag
    call search('\v ', 'c')
    execute "normal! x"
endfunction
 " nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " %:p:h"<cr>:copen 5<cr>:redraw!<cr>
hi! link Operator GruvboxRed
" setlocal foldmethod=indent
" setlocal foldlevel=1
