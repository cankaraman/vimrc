" install youcompleteme later
" Download vim-plug and pathogen when vim runs for the very first time {{{
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!mkdir -p .vim/autoload && curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
if empty(glob("~/.vim/autoload/pathogen.vim"))
    execute '!mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim'
endif
"TODO install Ag if it's not installed
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
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'michaeljsmith/vim-indent-object'
Plug 'bkad/CamelCaseMotion'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'justinmk/vim-sneak'
Plug 'adelarsq/vim-matchit'
Plug 'sheerun/vim-polyglot'
call plug#end()
execute pathogen#infect()
call pathogen#helptags()
"}}}

" experimental settings

" search/replace visual selection
vnoremap / "zy/<c-r>z
vnoremap <C-g> "zy:%s/<c-r>z//gc<left><left><left>
cabbrev git Git

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction


" global/{match}/normal @{register}
" gn next word operator

"e.g.
" onoremap in( :<c-u>normal! f(vi(<cr>
" onoremap il( :<c-u>normal! F(vi(<cr>
" let g:coc_snippet_next = '<C-k>'
" let g:coc_snippet_next = '<C-j>'


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
set hidden
set splitright
set pastetoggle=<F2>
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
hi SpellBad cterm=underline
"}}}

"mappings for all filetypes {{{
iabbrev retrun return
cnoremap <c-h> <left>
cnoremap <c-l> <right>
" delete the first space
nnoremap <silent> d<space> :<c-u>call <SID>DeleteSpace()<cr>
function! s:DeleteSpace()
    " accept the match under cursor with 'c' flag
    call search('\v ', 'c')
    execute "normal! x"
endfunction

" paste unnamed register in the insert & command mode
inoremap <c-v> <c-r>"
cnoremap <c-v> <c-r>"

" till the end of the line
nnoremap L g_
onoremap L g_
" till the begining of the line
nnoremap H ^
onoremap H ^

" Map F4 key to toggle spell checking
noremap <F4> :setlocal spell! spelllang=en_us<CR>

"make Y same as D&C
nnoremap Y yg_
" nnoremap V vg_

"search and replace
nnoremap <C-f> /
nnoremap <C-b> :nohlsearch<CR>
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
" nnoremap ü <C-]> 

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

"quick vimrc edit
nnoremap <leader>v :split $MYVIMRC<CR>
augroup myvimrc
    autocmd!
    autocmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc source $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup end
"source vimrc manualy
nnoremap <leader>sv :source $MYVIMRC<cr>
"}}}

"autocmds filetype & others {{{
"---------------------------------------------------------------------------------------------------
augroup filetype_javascript
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <leader>r :execute '!node' shellescape(@%, 1)<cr>
    "lint and save
    autocmd FileType javascript nnoremap <leader>l :ALEFix<cr>
    autocmd FileType javascript setlocal tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
augroup end

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
    " autocmd FileType html nnoremap <buffer> <leader>b :Bracey<cr>
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
"autopairs {{{
" don't let auto-pairs use <c-h> in insert mode
if !exists('g:AutoPairsMapCh')
  let g:AutoPairsMapCh = 0
end
" }}}
"vim sneak {{{
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
omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S
" disable vSneak_S for vim-surround vS
vmap <nop> <Plug>Sneak_S
" }}}
"CamelCaseMotion{{{
nmap w <Plug>CamelCaseMotion_w
nmap b <Plug>CamelCaseMotion_b
nmap e <Plug>CamelCaseMotion_e
" }}}
"NERDtree {{{
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
" }}}
"gruvbox theme {{{
let g:gruvbox_italic=1
colorscheme gruvbox
hi! link Operator GruvboxRed
" }}}
"FZF{{{
"Ag search mappings {{{
"select all with ctrl-a
command! -bang -nargs=* Ag
\ call fzf#vim#ag(<q-args>, '', { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)
nnoremap <leader>g :Ag<cr>
nnoremap gs :set operatorfunc=<SID>SearchWithAg<cr>g@
vnoremap gs :<c-u>call <SID>SearchWithAg(visualmode())<cr>
function! s:SearchWithAg(type)
    " echom "hey"
    let l:saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    execute "Ag " . expand(@@)
    " echom "Ag " . expand(@@)
    let @@ = l:saved_unnamed_register
endfunction
" }}}
nnoremap <leader>o :Files<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""' "need to install silversearcher-ag
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction
let g:fzf_action = {
            \ 'ctrl-q': function('s:build_quickfix_list'),
            \ 'ctrl-i': 'split',
            \ 'ctrl-s': 'vsplit' }
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History:<CR>
" }}}
" old plugin settings{{{
" make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"Bracey HTML mappings
" let g:bracey_server_port = 6001
" let g:bracey_refresh_on_save =1
"}}}

"}}}

" added functionlities {{{
augroup quit_quickfix
    au!
    au BufEnter * call MyLastWindow()
augroup end

function! MyLastWindow()
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
      quit
    endif
  endif
endfunction
" }}}

"------end-of-vimrc-----------------
""vimscript topics to study {{{
" setlocal foldmethod=indent
" setlocal foldlevel=1
" gv visual | z= spelling | \r \e expr-quote
"
" help various-motions
" help sign-support
" help virtualedit
" help map-alt-keys
" help error-messages
" help development
" help tips
" help 24.8
" help 24.9
" help usr_12.txt
" help usr_26.txt
" help usr_32.txt
" help usr_42.txt
" }}}

