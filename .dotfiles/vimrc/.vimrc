" -------------------------------------------------
" Basic Vim settings
" -------------------------------------------------
set nocompatible          " Use modern Vim defaults
filetype plugin indent on " Detect filetypes + load plugins
syntax on                 " Enable syntax highlighting

" -------------------------------------------------
" UI / Appearance
" -------------------------------------------------
set number                " Show line numbers
" set relativenumber        " Relative numbers (optional but handy)
set cursorline            " Highlight the current line
set termguicolors         " True‑color support (required for Tokyo Night)

" -------------------------------------------------
" Editing behavior
" -------------------------------------------------
set expandtab             " Convert tabs to spaces
set shiftwidth=4          " Indent size
set tabstop=4             " Tab width
set smartindent           " Auto‑indent new lines
set autoindent
set backspace=indent,eol,start " Make backspace behave intuitively
set wrap                  " Wrap long lines (toggle with :set nowrap)

" -------------------------------------------------
" Searching
" -------------------------------------------------
set ignorecase            " Case‑insensitive search...
set smartcase             " …unless uppercase letters are used
set incsearch             " Show matches while typing
set hlsearch              " Highlight all matches

" -------------------------------------------------
" Performance tweaks
" -------------------------------------------------
set hidden                " Allow switching buffers without saving
set updatetime=300        " Faster swap file writes / CursorHold events
set lazyredraw            " Redraw only when needed (speedier macros)

"color tokyonight
color nord
