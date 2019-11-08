set nocompatible
" line numbers
set relativenumber
set number

" searching 
set ignorecase
set smartcase

set autoread
set clipboard=unnamed
" syntax enable
" set tabstop=4
" set cursorline
" filetype indent on
" set wildmenu
" set showmatch
" set showcmd
set hidden

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'digitaltoad/vim-pug'

" Denite pre-reqs
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Shougo/denite.nvim'

"Coc install
" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'dyng/ctrlsf.vim'


" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
call plug#end()

" Finding Files
set path+=**
set wildignore+=**/node_modules/**
set wildignore+=*/dist/*
set wildignore+=*/dist-mapp/*
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Nerdtree config for wildignore
let NERDTreeRespectWildIgnore=1
" Hide dist and node_modules folder
let NERDTreeIgnore=['^node_modules', 'dist']
:map <C-n> :NERDTreeToggle<CR>

let g:airline_powerline_fonts = 1

" Powerline stuff
"let g:Powerline_symbols = 'fancy'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
set encoding=utf-8
" set guifont=Inconsolata\ for\ Powerline:h15
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8
colorscheme night-owl

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" add .js prefix so gf works on node require
set suffixesadd+=.js

" add cursor line highlight
:hi CursorLine   cterm=NONE ctermbg=brown ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=brown ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" Prettier save without @format
let g:prettier#autoformat = 0
let g:prettier#config#parser = 'babylon'
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.html Prettier

" F5 to show all buffers
nnoremap <F5> :buffers<CR>:buffer<Space>

" Switch between angular component and template
map <F4> :e %:p:s,.ts$,.X123X,:s,.html$,.ts,:s,.X123X$,.html,<CR>

" Quickly switch to prev buffer
nnoremap <leader><tab> :b#<cr>

" Javascript snippets
imap cll console.log();<Esc>==f(a

" Coc config
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Denite config
" nmap ; :Denite buffer
nmap <leader>; :Denite buffer -split=floating -winrow=1<CR>
noremap <leader>g :<C-u>Denite grep:. -no-empty <CR>
nmap <leader>t :Denite file/rec -split=floating -winrow=2<CR>

" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Histogram diffs
" Source: https://www.reddit.com/r/vim/comments/cn20tv/tip_histogrambased_diffs_using_modern_vim/
if has('nvim-0.3.2') || has("patch-8.1.0360")
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif


" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction


" ctrlsf settings
nmap     <leader>f <Plug>CtrlSFPrompt
