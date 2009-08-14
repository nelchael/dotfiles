" vim: ft=vim

syntax on
filetype on
filetype indent on
filetype plugin on
runtime ftplugin/man.vim
set encoding=iso8859-2
set fileencodings^=iso8859-2
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
set lcs=tab:>.,eol:$
set nu
set showcmd
set statusline=%<%f\ (%{&encoding})\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set sw=4
set termencoding=iso8859-2
set textwidth=2048
set ts=4
set viminfo='1000,f1,:1000,/1000
set whichwrap+=<,>,[,]
set wildignore=*.o,*~,*.la,*.*lo*,*.aux
set wildmenu
set wmh=0
set nofsync
set autowrite
set foldenable

if v:version >= 700
	set nuw=5
endif

if has("gui_running")
	colorscheme lingodirector
	set guioptions-=T
	set guioptions-=m
	if v:version >= 700
		set cursorline
	endif
else
	if &term =~ "linux"
		colorscheme default
	else
		set t_Co=256
		colorscheme inkpot
		set mouse=ni
	endif
endif

abbrev #d #define
abbrev #i #include

command! -bang -nargs=? W w<bang> <args>

map <F5> :w<CR>:make<CR>
imap <F5> <ESC>:w<CR>:make<CR>i

map <F1> :!man <cWORD><CR>
imap <F1> <ESC>:!man <cWORD><CR>i

map Z :set list!<CR>

map <silent> <C-b> :%s/[\t ]\+$//<CR>

imap <C-e> <ESC><C-e>a
imap <C-y> <ESC><C-y>a

map <F2> :bn<CR>
map <F3> :bp<CR>

map <C-j> <ESC>ddpk

au BufNewFile,BufRead *.vm setlocal filetype=html
au BufNewFile,BufRead *.qrc setlocal filetype=xml
au BufNewFile,BufRead *.pro setlocal filetype=make
au BufNewFile,BufRead *.proto setlocal filetype=proto
au FileType xhtml,html,php,xml,xsd,ebuild,jsp,java,vim,cpp,c,h,tex,plaintex,xslt,python,po,htmldjango setlocal fileencoding=utf-8 encoding=utf-8 fileencodings=utf-8,default
au BufRead */package.mask setlocal textwidth=75 fileencoding=utf-8 encoding=utf-8 fileencodings=utf-8,default
au BufRead */ChangeLog setlocal textwidth=75 fileencoding=utf-8 encoding=utf-8 fileencodings=utf-8,default
au BufRead *.pdf setlocal fileencoding=utf-8 encoding=utf-8 fileencodings=utf-8,default
au BufRead *.sql setlocal fileencoding=utf-8 encoding=utf-8 fileencodings=utf-8,default
au BufRead */hgrc setlocal filetype=dosini
au FileType tex,plaintex setlocal textwidth=100
au BufReadCmd *.jar,*.war,*.ear call zip#Browse(expand("<amatch>"))
au BufReadPre *.pdf set ro
au BufReadPost *.pdf silent %!pdftotext -nopgbrk "%" -
au BufReadPost *.xnots setlocal fileencoding=utf-8 encoding=utf-8 filetype=xnots
au FileType help nmap <buffer> <Return> <C-]>
au FileType man nmap <buffer> <Return> <C-]>
au FileType help nmap <buffer> <BS> <C-T>
au FileType man nmap <buffer> <BS> <C-T>

vnoremap < <gv
vnoremap > >gv

map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

map! <c-CR> <c-n>

map <F9> :%!xmllint --format -<CR>

let g:secure_modelines_allowed_items = [
			\ "textwidth",		"tw",
			\ "filetype",		"ft",
			\ "nowrap",			"wrap",
			\ "spell",			"spelllang",
			\ "encoding",		"enc",
			\ "fileencoding",	"fenc",
			\ "foldmethod",		"fdm"
			\ ]
let g:secure_modelines_verbose = 0

if filereadable("/home/nelchael/bin/list-unzip")
	let g:zip_unzipcmd = "/home/nelchael/bin/list-unzip"
endif

if filereadable("/home/nelchael/.vimrc-site")
	source /home/nelchael/.vimrc-site
endif
