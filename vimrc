" vim: ft=vim

syntax on
filetype on
filetype indent on
filetype plugin on
runtime ftplugin/man.vim
set encoding=utf-8
set fileencodings=utf-8
set autoindent
set background=dark
set backspace=2
set gdefault
set guifont=Consolas\ 11
set history=500
set hlsearch
set incsearch
set laststatus=2
set listchars=tab:\|\ ,eol:$,trail:_
set number
set showcmd
set statusline=%n:%<%f\ (%{&filetype},\ %{&encoding})\ %M\ %R%=(%P)\ line:%4l/%-4L\ col:%-3v
set titlestring=vim:\ %f\ %M
set shiftwidth=4
set termencoding=utf-8
set textwidth=2048
set tabstop=4
set viminfo='1000,f1,:1000,/1000
set whichwrap+=<,>,[,]
set wildignore=*.o,*~,*.la,*.*lo*,*.aux,*.d,*.pyc,*.pyo
set wildmenu
set winminheight=0
set nofsync
set autowrite
set foldenable
set foldmethod=marker
set scrolloff=4
set hidden
set numberwidth=5
set nomodeline
set debug=beep
set spellsuggest=best,10

" Tweak some settings if we have GUI running:
if has("gui_running")
	colorscheme desert
	silent! colorscheme inkpot
	set guioptions-=T
	set guioptions-=m
	set mousemodel=popup
else
	if &term =~ "linux"
		colorscheme default
	else
		set t_Co=256
		colorscheme desert
		silent! colorscheme inkpot
		set mouse=niv
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

imap <S-Insert> <MiddleMouse>

map <F2> :bn<CR>
map <F3> :bp<CR>

function! SmartFormatter()
	if &l:filetype == 'xml'
		%!xmllint --format -
	endif
	if &l:filetype == 'json'
		%!python -m json.tool
	endif
endfunction

map <F9> :call SmartFormatter()<CR>

vnoremap < <gv
vnoremap > >gv

" File type mappings:
au BufNewFile,BufRead *.desc setlocal filetype=conf
au BufNewFile,BufRead */hgrc setlocal filetype=dosini
au BufNewFile,BufRead *.pro setlocal filetype=make
au BufNewFile,BufRead *.qrc setlocal filetype=xml
au BufNewFile,BufRead *.repo setlocal filetype=dosini
au BufNewFile,BufRead *.vm setlocal filetype=html

" File type dependant settings:
au BufRead */ChangeLog setlocal textwidth=75
au BufRead */known_hosts setlocal nowrap
au BufRead */metadata.xml setlocal textwidth=75
au BufRead */package.mask setlocal textwidth=75
au FileType diff setlocal nofoldenable
au FileType spec setlocal textwidth=80
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
			\ "shiftwidth",		"sw",
			\ "expandtab",		"et"
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
