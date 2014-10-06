
set nocp hid bg=dark ai ar aw si is ic sc lz vb t_vb= vi='50,\"10000
set su=~,.bak,.swp,.o,.lo,.la,.aux,.log,.out,.dvi,.ps,.pdf,.blg,.bbl
set tw=80 ts=8 sts=8 sw=8 noet sbr=… lcs=eol:¬,tab:▸\ ,trail:●,extends:…

nmap <leader>m :!make<CR>
nmap <leader>l :set list!<CR>
nmap <leader>n :set number!<CR>
nmap <leader>h :set hlsearch!<CR>
nmap <leader>v :edit $MYVIMRC<CR>
nmap <leader>w :set wrap! lbr!<CR>

set pastetoggle=<F5>
nmap <leader>p :set paste!<CR>
nmap <leader>s :call Preserve("%s/\\s\\+$//e")<CR>
nmap <leader>i :call Preserve("gg=G")<CR>

" moving between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

vnoremap < <gv
vnoremap > >gv

if has("syntax")
	hi NonText    ctermfg=darkgray
	hi SpecialKey ctermfg=darkgray
	hi Special term=bold cterm=bold ctermfg=red
	hi Type    term=bold cterm=bold ctermfg=green
	hi PreProc term=bold cterm=bold ctermfg=blue
endif

if has("autocmd")
	autocmd FileType html,css   setlocal ts=2 sts=2 sw=2 et
	autocmd FileType make       setlocal ts=8 sts=8 sw=8 noet
	autocmd FileType c,cpp      setlocal ts=4 sts=4 sw=4 noet
	autocmd FileType python     setlocal ts=4 sts=4 sw=4 noet
	autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noet
	autocmd FileType fortran    setlocal tw=72 ts=8 sts=8 sw=8 noet
	autocmd FileType tex,latex  setlocal tw=80 ts=2 sts=2 sw=2 et nosi

	" automatically remove trailing whitespace for code
	autocmd BufWritePre *.h,*.c,*.cc,*.cpp,*.py,*.f :%s/\s\+$//e
endif

function! Preserve(command)
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	execute a:command
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction
