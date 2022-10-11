if empty(globpath(&rtp, 'autoload/lightline.vim'))
  finish
endif

if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ],
  \             [ 'vista' ],
  \           ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \   'vista': 'NearestMethodOrFunction',
  \ },
  \ }
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
