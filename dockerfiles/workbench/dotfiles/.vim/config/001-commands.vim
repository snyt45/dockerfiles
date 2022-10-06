" カレントバッファのファイルパスをクリップボードにコピー
command! CopyFilePath :echo "copied fullpath: " . expand('%:p') | let @"=expand('%:p') | call system('clip.sh -i', @")

" fzfでカレントディレクトリ配下のgit管理ファイル検索
command! -bang -nargs=? GFilesCwd
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == '?' ? { 'dir': getcwd(), 'placeholder': '' } : { 'dir': getcwd() }), <bang>0)
