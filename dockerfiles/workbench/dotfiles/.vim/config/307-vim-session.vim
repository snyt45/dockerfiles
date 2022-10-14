if empty(globpath(&rtp, 'autoload/xolox/session.vim'))
  finish
endif

let g:session_directory = '~/.shared_cache/.vim/sessions' " session保存ディレクトリの設定
let g:session_autosave = 'yes'                            " vimを閉じる時に自動保存
let g:session_autoload = 'yes'                            " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
let g:session_autosave_periodic = 1                       " 1分間に1回自動保存
