  set lines=50 columns=110
  set nocp
  set magic
  syn on
  set number
  set hlsearch
  set nocindent
  set smartindent
  set backspace=2
  set expandtab sw=4 ts=4
  set laststatus=2
  set ruler
  map <S-Insert> "*p
  set guifont=Monospace\ 10
  noremap % %v
  vnoremap // y/<C-R>"<CR>
