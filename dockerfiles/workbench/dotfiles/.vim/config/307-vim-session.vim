if empty(globpath(&rtp, 'autoload/xolox/session.vim'))
  finish
endif

let g:session_directory = '~/.shared_cache/.vim/sessions' " session保存ディレクトリの設定
let g:session_autosave = 'yes'
let g:session_autoload = 'prompt'
