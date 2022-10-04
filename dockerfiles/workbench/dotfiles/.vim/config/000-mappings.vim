" usage: Keymap {modes} {lhs} {rhs}
" ref: https://zenn.dev/kawarimidoll/articles/513d603681ece9
function! s:keymap(modes, ...) abort
  let arg = join(a:000, ' ')
  for mode in split(a:modes, '.\zs')
    if index(split('nvsxoilct', '.\zs'), mode) < 0
      echoerr 'Invalid mode is detected: ' . mode
      continue
    endif
    execute mode .. 'noremap' arg
  endfor
endfunction
command! -nargs=+ Keymap call s:keymap(<f-args>)

let mapleader = "\<Space>"
let maplocalleader = "/"

Keymap n j <Plug>(accelerated_jk_gj)
Keymap n k <Plug>(accelerated_jk_gk)
Keymap n <C-j> 5j
Keymap n <C-k> 5k
Keymap n <silent> <Esc><Esc> :<C-u>nohlsearch<CR><Esc> " 文字列検索のハイライトオフ
Keymap n PP "0p " ヤンクレジスタを使って貼り付け
Keymap n <Leader><C-g> :<C-u>echo "copied fullpath: " . expand('%:p') \| let @"=expand('%:p') \| call system('clip.sh -i', @")<CR> " カレントバッファのファイルパスをクリップボードにコピー
Keymap n q <Nop> " よくミスタイプするのでマクロ記録しないようにする

" ヤンクした内容をクリップボードにコピー
augroup Yank
  au!
  autocmd TextYankPost * :call system('clip.sh -i', @")
augroup END

Keymap i <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
Keymap i <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
Keymap i <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" fzfでカレントディレクトリ配下のgit管理ファイル検索
command! -bang -nargs=? GFilesCwd
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == '?' ? { 'dir': getcwd(), 'placeholder': '' } : { 'dir': getcwd() }), <bang>0)
