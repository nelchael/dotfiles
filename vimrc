" vim: ft=vim

if has('win32') || has('win64')
	set runtimepath^=~/.vim
endif

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
set viminfo=h,'500,f1,:500,/500,s250,<500,n$HOME/.viminfo
set wrap smoothscroll
set whichwrap+=<,>,[,]
set wildignore=*.o,*~,*.la,*.*lo*,*.aux,*.d,*.pyc,*.pyo
set wildmenu
set wildmode=list:longest
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
set noshowmode
set novisualbell

" Tweak some settings if we have GUI running:
if has("gui_running")
	colorscheme desert
	silent! colorscheme inkpot
	set guioptions-=T
	set guioptions-=m
	set mousemodel=popup
	if has("win32") || has("win64")
		set guifont=Source_Code_Pro:h11
	else
		set guifont=Source\ Code\ Pro\ 11
	endif
	set belloff=all
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
imap <C-f> <C-x><C-o>

imap <S-Insert> <MiddleMouse>
imap <C-@> <C-N>
imap <C-Space> <C-N>

map <F2> :bn<CR>
map <F3> :bp<CR>

function! SmartFormatter()
	if &l:filetype == 'xml'
		%!xmllint --format -
	endif
	if &l:filetype == 'json'
		%!jq -SM .
	endif
endfunction

map <F9> :call SmartFormatter()<CR>

vnoremap < <gv
vnoremap > >gv

" File type mappings:
au BufNewFile,BufRead *.desc setlocal filetype=conf
au BufNewFile,BufRead *.gradle setlocal filetype=groovy
au BufNewFile,BufRead */hgrc setlocal filetype=dosini
au BufNewFile,BufRead *.pro setlocal filetype=make
au BufNewFile,BufRead *.qrc setlocal filetype=xml
au BufNewFile,BufRead *.repo setlocal filetype=dosini
au BufNewFile,BufRead *.vm setlocal filetype=html
au BufNewFile,BufRead */Pipfile.lock setlocal filetype=json
au BufNewFile,BufRead */Pipfile setlocal filetype=toml
au BufNewFile,BufRead *.toml setlocal filetype=toml
au BufNewFile,BufRead */poetry.lock setlocal filetype=toml
au BufNewFile,BufRead *.tf setlocal filetype=terraform expandtab

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

" Configure enhanced Python syntax:
let g:python_highlight_all = 1

" vim-highlightedyank configuration:
let g:highlightedyank_highlight_duration = -1

" Configure lightline:
" (statusline is configured above anyway for systems without lightline)
let g:lightline = {
	\ 'colorscheme': 'jellybeans',
	\ 'active': {
	\	'left': [ [ 'mode', 'paste' ],
	\			  [ 'readonly', 'filename', 'modified' ],
	\			  [ 'gitbranch' ] ]
	\ },
	\ 'component_function': {
	\   'modified': 'LightlineCF_Modified',
	\   'readonly': 'LightlineCF_Readonly',
	\   'filename': 'LightlineCF_Filename',
	\   'fileformat': 'LightlineCF_Fileformat',
	\   'filetype': 'LightlineCF_Filetype',
	\   'fileencoding': 'LightlineCF_Fileencoding',
	\   'mode': 'LightlineCF_Mode',
	\	'gitbranch': 'LightlineCF_Branch',
	\ },
	\ 'component_visible_condition': {
	\   'readonly': '(&filetype != "help" && &readonly)',
	\   'modified': '(&filetype != "help" && (&modified || !&modifiable))',
	\ },
\ }

function! LightlineCF_Modified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
function! LightlineCF_Readonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
endfunction
function! LightlineCF_Filename()
	return '' != expand('%:f') ? expand('%:f') : '[No Name]'
endfunction
function! LightlineCF_Fileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction
function! LightlineCF_Filetype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction
function! LightlineCF_Fileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction
function! LightlineCF_Mode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
function! LightlineCF_Branch()
	let branch_name = gitbranch#name()
	return branch_name == 'master' || branch_name == '' ? '' : '' . branch_name
endfunction

" Check for nicer zip output:
if filereadable(expand("~/bin/list-unzip"))
	let g:zip_unzipcmd = expand("~/bin/list-unzip")
endif

" Templates:
if filereadable(expand("~/.vim/templates/python.py"))
	au BufNewFile *.py 0r ~/.vim/templates/python.py
endif

" Windows specific settings:
if has("win32") || has("win64")
	language English
	let $LANG = 'en'
	set noswapfile
endif

" Check for site-local settings:
if filereadable(expand("~/.vimrc-site"))
	source ~/.vimrc-site
endif
