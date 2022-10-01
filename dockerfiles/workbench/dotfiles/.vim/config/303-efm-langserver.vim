if empty(globpath(&rtp, 'autoload/efm_langserver_settings.vim'))
  finish
endif

" debug
" let g:efm_langserver_settings#debug = 5 " ログを有効にする
" let g:efm_langserver_settings#debug_file = expand('~/.shared_cache/.vim/efm-langserver.log') " ログの出力先
