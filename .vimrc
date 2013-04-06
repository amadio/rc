" Guilherme Amadio's vimrc

" basic configuration
set nocompatible
set hidden autoindent autowrite ruler
set background=dark
set tw=95 ts=8 sts=8 sw=8 noexpandtab
set suffixes=~,.bak,.swp,.o,.lo,.la,.aux,.log,.out,.dvi,.ps,.blg,.bbl
set vb t_vb= showbreak=… listchars=tab:▸\ ,eol:¬
set viminfo='50,\"10000 " make register size very big

" some shortcuts
nmap <leader>l :set list!<CR>
nmap <leader>n :set number!<CR>
nmap <leader>h :set hlsearch!<CR>
nmap <leader>v :edit $MYVIMRC<CR>
nmap <leader>m :!make<CR>

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

if has("autocmd")
	autocmd FileType make       setlocal tw=95 ts=8 sts=8 sw=8 noexpandtab
	autocmd FileType c,cpp      setlocal tw=95 ts=4 sts=4 sw=4 noexpandtab
	autocmd FileType python     setlocal tw=95 ts=4 sts=4 sw=4 noexpandtab
	autocmd FileType fortran    setlocal tw=72 ts=6 sts=6 sw=6 expandtab
	autocmd FileType tex,latex  setlocal tw=95 ts=2 sts=2 sw=2 expandtab
	autocmd FileType html,css   setlocal tw=95 ts=2 sts=2 sw=2 expandtab
	autocmd FileType javascript setlocal tw=95 ts=4 sts=4 sw=4 noexpandtab

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
