if empty(globpath(&rtp, 'autoload/denops.vim'))
  finish
endif

" バージョンチェックを無効にする
let g:denops_disable_version_check=1
