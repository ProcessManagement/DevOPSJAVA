set number
set title
set ambiwidth=double
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set backspace=indent,eol,start
set noswapfile
set nobackup
set noundofile
set cursorline
hi clear CursorLine
hi CursorLineNr term=bold cterm=NONE ctermfg=228 ctermbg=NONE

""" NeoBundle """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'sjl/badwolf'
NeoBundle 'Shougo/unite.vim'

call neobundle#end()

NeoBundleCheck

""" Eclim """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype plugin indent on

augroup EclimAu
  autocmd!
  autocmd FileType java nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
  autocmd FileType java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
  autocmd FileType java let g:EclimJavaSearchSingleResult = 'edit'
augroup END

set completeopt=longest,menuone,preview

""" Color Scheme """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
colorscheme badwolf

""" auto make directory """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

""" tab(tc, tx, tn, tp, tn(n=1,2,3,,,,)) """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand('~/.vimrc_tab'))
  source ~/.vimrc_tab
endif

""" key bind """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <C-U><C-B> :Unite buffer<CR>
