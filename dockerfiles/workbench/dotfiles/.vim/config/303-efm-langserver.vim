if empty(globpath(&rtp, 'autoload/efm_langserver_settings.vim'))
  finish
endif

" debug
" let g:efm_langserver_settings#debug = 5 " ログを有効にする
" let g:efm_langserver_settings#debug_file = expand('~/.shared_cache/.vim/efm-langserver.log') " ログの出力先

" https://github.com/nakatanakatana/dotfiles
" for efm-langserver-settings
" let s:efm_args = []
" if efm_langserver_settings#config_enable()
"   let s:efm_args = extend(s:efm_args, ['-c', efm_langserver_settings#config_path()])
" endif
" 
" if efm_langserver_settings#debug_enable()
"   let s:efm_args = extend(s:efm_args, ['-logfile', efm_langserver_settings#debug_path()])
"   let s:efm_args = extend(s:efm_args, ['-loglevel', efm_langserver_settings#debug_enable()])
" endif

" let g:lsp_settings = {
"   \ 'efm-langserver': {
"     \ 'disabled': v:false,
"     \ 'args': s:efm_args,
"     \ 'allowlist': efm_langserver_settings#whitelist(),
"     \ 'blocklist': efm_langserver_settings#blacklist(),
"     \ }
"   \ }

" efm-langserverが未インストールの場合インストールする
" function! s:check_install_efm_langserver()
"   if !filereadable(expand(g:lsp_settings_servers_dir . '/efm-langserver/efm-langserver'))
"     LspInstallServer efm-langserver
"   endif
" endfunction

" augroup vimrc_check_install_efm_langserver
"     autocmd!
"     autocmd User lsp_setup call s:check_install_efm_langserver()
" augroup END
