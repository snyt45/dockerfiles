if empty(globpath(&rtp, 'autoload/which_key.vim'))
  finish
endif

set timeoutlen=100

let g:which_key_ignore_outside_mappings = 1 " 辞書にないマッピングは非表示にする
let g:which_key_sep = '→'
let g:which_key_use_floating_win = 0

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key s
" window
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map_window = { 'name' : '+window' }
call which_key#register('s', 'g:which_key_map_window')
nnoremap s :<c-u>WhichKey 's'<CR>
vnoremap s :<c-u>WhichKeyVisual 's'<CR>

let g:which_key_map_window.s    = [':sp'              , 'split horizontaly']
let g:which_key_map_window.v    = [':vs'              , 'split verticaly']
let g:which_key_map_window.h    = ['<C-w>h'           , 'focus left']
let g:which_key_map_window.j    = ['<C-w>j'           , 'focus down']
let g:which_key_map_window.k    = ['<C-w>k'           , 'focus up']
let g:which_key_map_window.l    = ['<C-w>l'           , 'focus right']
let g:which_key_map_window.H    = ['<C-w>H'           , 'move left']
let g:which_key_map_window.J    = ['<C-w>J'           , 'move down']
let g:which_key_map_window.K    = ['<C-w>K'           , 'move up']
let g:which_key_map_window.L    = ['<C-w>L'           , 'move right']
let g:which_key_map_window['<'] = [':vert resize -15 ', 'resize left']
let g:which_key_map_window['>'] = [':vert resize +15' , 'resize right']
let g:which_key_map_window['-'] = [':resize -15'      , 'resize down']
let g:which_key_map_window['+'] = [':resize +15'      , 'resize up']

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key t
" tabs
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map_tabs = { 'name' : '+tabs' }
call which_key#register('t', 'g:which_key_map_tabs')
nnoremap t :<c-u>WhichKey 't'<CR>
vnoremap t :<c-u>WhichKeyVisual 't'<CR>

let g:which_key_map_tabs.n = [':tabedit'      , 'new']
let g:which_key_map_tabs.t = [':tab split'    , 'split']
let g:which_key_map_tabs.h = [':tabprev'      , 'focus left']
let g:which_key_map_tabs.l = [':tabnext'      , 'focus right']
let g:which_key_map_tabs.H = ['<C-w>:-tabmove', 'move left']
let g:which_key_map_tabs.L = ['<C-w>:+tabmove', 'move right']

" ----------------------------------------------------------------------------------------------------------------------
" Leader key map bindings
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map = {}
call which_key#register('<Space>', 'g:which_key_map')
nnoremap <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <leader> :<c-u>WhichKeyVisual '<leader>'<CR>

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>b
" buffer
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.b = {
  \ 'name' : '+buffer'                                         ,
  \ 'b'    : [':FzfPreviewBuffersRpc'                          , 'buffers'],
  \ 'o'    : [':FzfPreviewFromResourcesRpc buffer project_mru' , 'project mru'],
  \ 'n'    : [':bnext'                                         , 'next'],
  \ 'p'    : [':bprevious'                                     , 'previous'],
  \ 'd'    : [':bd'                                            , 'destroy'],
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>f
" file
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.f = {
  \ 'name'  : '+file'                                          ,
  \ 'e'     : [':Fern . -reveal=%'                             , 'open explorer'],
  \ 't'     : [':Fern . -drawer -stay -keep -toggle -reveal=%' , 'toggle filetree'],
  \ 'f'     : [':FzfPreviewProjectGrepRpc .'                   , 'grep'],
  \ 'p'     : [':FzfPreviewFromResourcesRpc project_mru git'   , 'project mru'],
  \ 'j'     : [':FzfPreviewJumpsRpc'                           , 'jumplist'],
  \ '/'     : [':FzfPreviewLinesRpc --add-fzf-arg=--no-sort'   , 'line'],
  \}

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>F
" fold
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.F = {
  \ 'name' : '+fold'              ,
  \ 'O'    : [':set foldlevel=20' , 'open all'],
  \ 'C'    : [':set foldlevel=0'  , 'close all'],
  \ 'c'    : [':foldclose'        , 'close'],
  \ 'o'    : [':foldopen'         , 'open'],
  \ '1'    : [':set foldlevel=1'  , 'level1'],
  \ '2'    : [':set foldlevel=2'  , 'level2'],
  \ '3'    : [':set foldlevel=3'  , 'level3'],
  \ '4'    : [':set foldlevel=4'  , 'level4'],
  \ '5'    : [':set foldlevel=5'  , 'level5'],
  \ '6'    : [':set foldlevel=6'  , 'level6']
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>g
" git
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.g = {
  \ 'name' : '+git'                          ,
  \ 'a'    : [':FzfPreviewGitActionsRpc'     , 'action'],
  \ 'l'    : [':FzfPreviewGitCurrentLogsRpc' , 'current logs'],
  \ 'b'    : [':Git blame'                   , 'blame'],
  \ 'j'    : [':GitGutterPrevHunk'           , 'pevious hunk'],
  \ 'k'    : [':GitGutterNextHunk'           , 'next hunk'],
  \ 'p'    : [':GitGutterPreviewHunk'        , 'preview hunk'],
  \ 's'    : [':GitgutterStageHunk'          , 'stage hunk'],
  \ 't'    : [':GitGutterToggle'             , 'toggle gitgutter'],
  \ 'u'    : [':GitGutterUndoHunk'           , 'undo hunk']
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>M
" markdown
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.M = {
  \ 'name' : '+markdown'     ,
  \ 'm'    : [':MakeTable'   , 'make table'],
  \ 'M'    : [':MakeTable!'  , 'make table!'],
  \ 'u'    : [':UnmakeTable' , 'unmake table'],
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>l
" lsp
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.l = {
  \ 'name' : '+lsp'                     ,
  \ 'a'    : [':LspCodeAction'          , 'code action'],
  \ 'd'    : [':LspDocumentDiagnostics' , 'diagnostics'],
  \ 'f'    : [':LspDocumentFormat'      , 'format'],
  \ 'h'    : [':LspHover'               , 'hover'],
  \ 'l'    : [':LspCodeLens'            , 'code Lens'],
  \ 'r'    : [':LspRename'              , 'rename symbol'],
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>lg
" goto
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.l.g = {
  \ 'name' : '+goto'               ,
  \ 'd'    : [':LspDefinition'     , 'goto definition'],
  \ 'y'    : [':LspTypeDefinition' , 'goto type definition'],
  \ 'i'    : [':LspImplementation' , 'goto implementation'],
  \ 'r'    : [':LspReferences'     , 'goto references'],
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <Leader>p
" package
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_map.p = {
  \ 'name' : '+package'       ,
  \ 'c'    : [':PlugClean'    , 'clean'],
  \ 'd'    : [':PlugDiff'     , 'diff'],
  \ 'i'    : [':PlugInstall'  , 'install'],
  \ 's'    : [':PlugSnapshot' , 'snapshot'],
  \ 'S'    : [':PlugStatus'   , 'status'],
  \ 'u'    : [':PlugUpgrade'  , 'upgrade'],
  \ 'U'    : [':PlugUpdate'   , 'update'],
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" LocalLeader key map bindings
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_local_map = {}
call which_key#register(',', 'g:which_key_local_map')
nnoremap <localleader> :<c-u>WhichKey '<localleader>'<CR>
vnoremap <localleader> :<c-u>WhichKeyVisual '<localleader>'<CR>

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <localleader>g
" quickfix
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_local_map.g = {
  \ 'name' : '+quickfix'               ,
  \ 'n'    : [':cn'                    , 'next line'],
  \ 'p'    : [':cnf'                   , 'previous line'],
  \ 'N'    : [':cp'                    , 'next file'],
  \ 'P'    : [':cpf'                   , 'previous file'],
  \ 'o'    : [':cwindow'               , 'open'],
  \ 'c'    : [':cclose'                , 'close'],
  \ 'q'    : [':FzfPreviewQuickFixRpc' , 'search'],
  \ }

" ----------------------------------------------------------------------------------------------------------------------
" Prefix Key <localleader>f
" floaterm
" ----------------------------------------------------------------------------------------------------------------------
let g:which_key_local_map.f = {
  \ 'name' : '+floaterm'                                                    ,
  \ 't'    : [':FloatermNew --autoclose=2 --height=0.9 --width=0.9'         , 'terminal'],
  \ 'g'    : [':FloatermNew --autoclose=2 --height=0.9 --width=0.9 lazygit' , 'lazygit'],
  \ }
