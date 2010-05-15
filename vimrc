" vim: ft=vim

syntax on
filetype on
filetype indent on
filetype plugin on
runtime ftplugin/man.vim
set encoding=utf-8
set fileencodings^=utf-8
set autoindent
set background=dark
set backspace=2
set gdefault
set guifont=Consolas\ 10
set history=50
set history=500
set hlsearch
set incsearch
set laststatus=2
set lazyredraw
set listchars=tab:>.,eol:$
set number
set showcmd
set statusline=%n:%<%f\ (%{&filetype},\ %{&encoding})\ %m%r%=(%P)\ line:%4l/%-4L\ col:%-3v
set shiftwidth=4
set termencoding=iso8859-2
set textwidth=2048
set tabstop=4
set viminfo='1000,f1,:1000,/1000
set whichwrap+=<,>,[,]
set wildignore=*.o,*~,*.la,*.*lo*,*.aux,*.d
set wildmenu
set winminheight=0
set nofsync
set autowrite
set foldenable
set scrolloff=4
set hidden
set numberwidth=5
set nomodeline

" Tweak some settings if we have GUI running:
if has("gui_running")
	colorscheme lingodirector
	set guioptions-=T
	set guioptions-=m
	set cursorline
else
	if &term =~ "linux"
		colorscheme default
	else
		set t_Co=256
		colorscheme inkpot
		set mouse=ni
	endif
endif

abbrev #i #include

" W == w
command! -bang -nargs=? W w<bang> <args>

" Some useful key bindings:
map Z :set list!<CR>
map <silent> <C-b> :%s/[\t ]\+$//<CR>

imap <C-e> <ESC><C-e>a
imap <C-y> <ESC><C-y>a

map <F1> :A<CR>
map <F2> :bn<CR>
map <F3> :bp<CR>

map <F9> :%!xmllint --format -<CR>

vnoremap < <gv
vnoremap > >gv

" Set filetype for some file patterns:
au BufNewFile,BufRead *.pro setlocal filetype=make
au BufNewFile,BufRead *.proto setlocal filetype=proto
au BufNewFile,BufRead *.qrc setlocal filetype=xml
au BufNewFile,BufRead *.vm setlocal filetype=html

" Tweak settings for some file types:
au BufRead */ChangeLog setlocal textwidth=75
au BufRead */hgrc setlocal filetype=dosini
au BufRead */package.mask setlocal textwidth=75
au FileType tex,plaintex setlocal textwidth=100

" Remap some keys for man & help:
au FileType help nmap <buffer> <BS> <C-T>
au FileType help nmap <buffer> <Return> <C-]>
au FileType man nmap <buffer> <BS> <C-T>
au FileType man nmap <buffer> <Return> <C-]>

" Configure secure modelines:
let g:secure_modelines_allowed_items = [
			\ "textwidth",		"tw",
			\ "filetype",		"ft",
			\ "nowrap",			"wrap",
			\ "spell",			"spelllang",
			\ "encoding",		"enc",
			\ "fileencoding",	"fenc",
			\ "foldmethod",		"fdm",
			\ "tabstop",		"ts",
			\ "shiftwidth",		"sw"
			\ ]
let g:secure_modelines_verbose = 0

" Check for nicer zip output:
if filereadable(expand("~/bin/list-unzip"))
	let g:zip_unzipcmd = expand("~/bin/list-unzip")
endif

" Check for site-local settings:
if filereadable(expand("~/.vimrc-site"))
	source ~/.vimrc-site
endif
