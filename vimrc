" Guilherme Amadio's vimrc

" basic configuration
set hidden nocompatible autoindent autowrite ruler
set bg=dark tw=95 ts=8 sts=8 sw=8 noexpandtab
set suffixes=~,.bak,.swp,.o,.lo,.la,.aux,.log,.out,.dvi,.pdf,.ps,.blg,.bbl
set cinkeys=0{,0},:,0#,!<Tab>,!^F
set vb t_vb= showbreak=…

" some handy shortcuts
nmap <leader>n :set number!<CR>
nmap <leader>h :set hlsearch!<CR>
nmap <leader>v :edit $MYVIMRC<CR>

set pastetoggle=<F6>
nmap <leader>p :set paste!<CR>

" these only work in utf8, beware
set listchars=tab:▸\ ,eol:¬
nmap <leader>l :set list!<CR>
nnoremap <leader>s :call <SID>strip()<CR>

" shortcuts to edit files in new split windows or tabs
map <leader>ew :e    <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp   <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp  <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

if has("syntax")
	syntax on
	filetype on
endif

if has("autocmd")
	autocmd FileType latex      setlocal tw=95 ts=2 sts=2 sw=2 expandtab
	autocmd FileType make       setlocal tw=95 ts=8 sts=8 sw=8 noexpandtab
	" This C style is better, but it may be hard to read other people's code
	autocmd FileType c,cpp      setlocal tw=95 ts=2 sts=2 sw=2 expandtab
	autocmd FileType python     setlocal tw=95 ts=4 sts=4 sw=4 noexpandtab
	autocmd FileType html,css   setlocal tw=95 ts=2 sts=2 sw=2 expandtab
	autocmd FileType javascript setlocal tw=95 ts=4 sts=4 sw=4 noexpandtab

	" small fix for colorscheme on LaTeX files (not needed anymore)
	" autocmd FileType *.tex hi Special term=bold cterm=bold ctermfg=red
endif

" remove trailing white spaces, good for coding
function! <SID>strip()
    " save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    " restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
