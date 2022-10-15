if empty(globpath(&rtp, 'autoload/xolox/session.vim'))
  finish
endif

let g:session_directory = '~/.shared_cache/.vim/sessions' " session保存ディレクトリの設定
let g:session_autosave = 'no'                             " vimを閉じる時に自動保存しない
let g:session_autoload = 'no'                             " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開かない
