"
"" .vimrc




"
""
" === Initialization ==================================================={{{

" --- Skip initialization for vim-tiny or vim-small ----------------------{
" memo: http://qiita.com/b4b4r07/items/f7a4a0461e1fc6f436a4
if !1 | finish | endif
" }


" --- minimum config -----------------------------------------------------{
if &compatible
  set nocompatible               " Be iMproved
endif

" loading issue - https://github.com/vim/vim/issues/3117
" https://github.com/roxma/vim-hug-neovim-rpc/issues/32
if has('python3')
  silent! python3 1
endif
" }


" --- RunTimePath --------------------------------------------------------{
let $MY_VIM_RTP=expand('~/.vim')
"" ___ let $MY_VIM_EXTEND_DIR=expand('~/dot_files/.vimrc.d')
"" ___ "echohl $MY_VIM_RTP
set runtimepath+=$MY_VIM_RTP

if !exists('$HOME')
  let $HOME = expand('~')
endif
" HOME directory.
let t:cwd = getcwd()

" }


" --- ENV Vars: HTTP_PROXY , GIT_SSL -------------------------------------{
"  if use proxy, or close git protcols...( as some develop company e.g: 'AS )
if $HTTP_PROXY
    let $http_proxy=$HTTP_PROXY
    let $https_proxy=$HTTP_PROXY
endif

" if $GIT_SSL_NO_VERIFY
"   let g:neobundle_default_git_protocol='https'
" endif

" }


" --- Profiling ----------------------------------------------------------{
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
    \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif
" }


"
" --- OS Check -----------------------------------------------------------{
let g:is_windows = has('win32') || has('win64')
let g:is_cygwin = has('win32unix')
let g:is_unix = has('unix')
let g:is_mac = !g:is_windows && !g:is_cygwin
    \ && (has('mac') || has('macunix') || has('gui_macvim')
    \ || (!executable('xdg-open') && system('uname') =~? '^darwin'))
" }


" --- Condition Variables ------------------------------------------------{
let g:is_gui = has('gui_running')
let g:is_terminal = !g:is_gui
let g:is_unicode = (&termencoding ==# 'utf-8' || &encoding == 'utf-8') && !(exists('g:discard_unicode') && g:discard_unicode != 0)
" }


"
" --- Funcs: as utils ----------------------------------------------------{
function! MakeIncludePath(path)
  " define delimiter depends on platform
  if has('win16') || has('win32') || has('win64')
    let delimiter = ';'
  else
    let delimiter = ':'
  endif
  let delimiter = ':'
  let pathlist = split($PATH, delimiter)
  if isdirectory(a:path) && (index(pathlist, a:path) == -1)
    let $PATH=a:path.delimiter.$PATH
  endif
endfunction


function! s:sidPrefix()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction


function! s:setDefault(var, val)
  if !exists(a:var) || type({a:var}) != type(a:val)
    silent! unlet {a:var}
    let {a:var} = a:val
  endif
endfunction


function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : { 'on': [], 'for': [] }
endfunction


if has('python3')
  set pyxversion=3
  let g:python3_host_prog = $PYENV_ROOT.'/shims/python3'
  call MakeIncludePath($PYENV_ROOT . '/shims/')
endif

" }}}


"
""
" === Pre Settings ====================================================={{{


" --- ::encoding ------------------------------------------------------{{{{
"
"   see also: http://peacepipe.toshiville.com/2006/04/mac-6-vim-mac.html
"     enc ..... encoding
"     fenc .... fileencoding
"     fencs ... fileencodings
"
"     vim は 'enc' で指定された文字コードをデフォルトとし，
"     ファイルを開く時に 'fencs' で指定された文字コードから順番に
"     'enc' の文字コードへ変換を試み，成功したところでやめる，
"
"     全部失敗したら変換せずに 'enc' の文字コードで開く，という仕様になっている．
"     だから，基本的に 'fencs' の中に 'enc' と同じ文字コードを書くのは無意味なばかりか，
"     'fencs' の途中で 'enc' と同じものが登場すると以降の変換試行が行われない．
"
"     'fenc' は，vim がファイルを読み込む時に自動設定し，そのファイルの文字コードを示す為に使う．
"     つまりユーザーが 'fenc' を設定するのは明示的にエンコーディングを指定して保存したい時のみで，
"     .vimrc で 'fenc' を指定することは無い． ....
"
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,cp932
" set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932

scriptencoding utf-8

" 文字コード判別
" xxx source ${MY_VIM_EXTEND_DIR}/010__encoding_guess.vimrc.elmt

" 改行コードの自動認識
set fileformats=unix,dos,mac

" fix multibyte characters( □, ○, etc... )
if exists('&ambiwidth')
    set ambiwidth=double
endif

" 不可視文字表示設定
augroup highlightIdegraphicSpace
  autocmd!
" autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkMagenta guibg=DarkMagenta
  autocmd Colorscheme * highlight IdeographicSpace cterm=underline ctermfg=lightMagenta guibg=darkgray
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

colorscheme default

" }}}}


" --- Language:: Character Codec --------------------------------------{{{{
if g:is_windows
  " For Windows
  language messages ja_JP
elseif g:is_mac
  " For Mac
  language messages ja_JP.UTF-8
  language ctype ja_JP.UTF-8
  language time C
else
  " For Linux
  language messages C
endif
" }}}}


" --- ::leader  -------------------------------------------------------{{{{
"leaderを,に
let mapleader = ","
let maplocalleader = "\<Space>"
" }}}}

" }}}


"
""
" === Plugin Loading ( vim-plug ) ======================================{{{
"

" hehehe...

" }}}




"
""
" === General::Basis =================================================={{{

" --- Help Message, Boot Message, GVim IME ------------------------------{
" ヘルプ言語指定
"set helplang& helplang=ja,en
set helplang& helplang=en,ja


" 起動時のメッセージを表示しない
"-- set shortmess& shortmess+=I
"set shortmess=aTI


" MacVimやGVimを利用する際にIMEがモードの切替でオフとなる設定
" -- set imdisable

" }


" --- Color Scheme ------------------------------------------------------{
" by color depth
if (has("termguicolors"))
  " using the True Color(24bit)
  set termguicolors
else
  set t_Co=256
endif

set background=dark

" +++ colorscheme tender
" }


" --- Environment -------------------------------------------------------{
" ___ set shell=zsh\ -l
" }


" }}} // End As General::Basis




"
""
" === Main ============================================================{{{

" --- @ Basis -----------------------------------------------------------{

" ヒストリ行数
set history=10000

" 構文ハイライトの有効化
"-- syntax on
syntax enable

" 構文ハイライト範囲を狭める(速度対策)
"   via: https://qiita.com/shotat/items/da0f42ea90610ca0dadb
set synmaxcol=200


" 更新時自動再読込み
set autoread

" 保存してなくてもバッファを切り替えられるように
set hidden

" テキスト整形オプション，マルチバイト系を追加
set formatoptions=lmoq

" ファイル名などの補完モード
set wildmode=list:longest,list:full
" -- set wildmode=longest,list,full

" タイトルをウインドウ枠に表示
set title

" ルーラーを表示
set ruler

" 行番号を表示
set number
set relativenumber

set signcolumn=yes


" 入力モードを表示
set showmode

" 長い行でもなんとかして表示を試みる
set display=lastline

" popup window rows
set pumheight=12


" 特殊文字(Tab文字、行末など不可視文字関連)の見える化。listcharsはlcsでも設定可能。
""trailは行末スペース。
set list

" listで表示される文字のフォーマットを指定する
"#:: set listchars=tab:\ \
"#:: set listchars=eol:$,tab:>\ ,extends:<
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<

" set color
" https://www.reddit.com/r/vim/comments/4hoa6e/what_do_you_use_for_your_listchars/
hi SpecialKey ctermfg=Red guifg=Red


" 括弧入力時の対応する括弧を表示
" ___ :source ${VIMRUNTIME}/macros/matchit.vim
set showmatch
set matchtime=1

" 入力中のコマンドをステータスに表示する
set showcmd

" 自動改行関連
set textwidth=0

" 数値Increment,Decrement において、(8進数評価させず)常に10進数評価させる
set nrformats=

" ESC キーのみ押下時の反応時間
" -- set timeoutlen=1000
set timeoutlen=300

" }


" --- @ スワップ設定 ----------------------------------------------------{
set swapfile
" ___ set directory=${MY_VIM_RTP}/etc/_swap
" }


" --- @ バックアップ設定 ------------------------------------------------{
set nobackup
" 保存時のみバックアップを作成
set writebackup
" バックアップの保存先
" ___ set backupdir=${MY_VIM_RTP}/etc/_backup
" バックアップファイルの拡張子
set backupext=.xbkup
" ファイルのコピーを作成してバックアップにし上書き保存
set backupcopy=yes
" }


" --- @ 保存設定 --------------------------------------------------------{
" 保存時に行末の空白を除去する
" -- autocmd BufWritePre * :%s/\s\+$//ge

" save as root ( with sudo )
" --- cmap w!!! w !sudo tee > /dev/null %
cabbr w!!! w !sudo tee > /dev/null %
"  }


" --- @ Tab ( as key ) --------------------------------------------------{
" タブの代わりに空白文字を挿入する
set expandtab

" Tab文字を画面上の見た目で何文字幅にするか設定
set tabstop=4
" cindentやautoindent時に挿入されるタブの幅
set shiftwidth=4

" Tabキー使用時にTabでは無くホワイトスペースを入れたい時に使用する
" この値が0以外の時はtabstopの設定が無効になる
set softtabstop=0

" 新しい行を作ったときに高度な自動インデントを行う
set smartindent
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
" }


" --- @ Tab ( as marker ) -----------------------------------------------{
" 常にタブラインを表示
set showtabline=2
" }


" --- @ 編集、文書整形関連 ----------------------------------------------{
"   backspaceキーの挙動を設定する
"   indent  : 行頭の空白の削除を許す
"   eol     : 改行の削除を許す
"   start   : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start

" 新しい行を直前の行と同じインデントにせず、オートインデントを使用
set autoindent

" }


" --- @ 折りたたみ、folding ( not use fondCC ) --------------------------{
" -- set foldmethod=manual
" -- set foldmethod=syntax
set foldmethod=marker
set foldlevel=2
set foldcolumn=0
let s:my_flag__fold_type = 'none'   " // mine, foldcc, system, none
" }


" --- @ 検索関連 --------------------------------------------------------{
" // " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" インクリメンタルサーチを行う
set incsearch

" 検索をファイルの先頭へループ
set wrapscan

" ハイライト
set hlsearch

" Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" diff 時の空白無効化
set diffopt+=iwhite

" }


" --- @ help ------------------------------------------------------------{
" Help (! help ) で Vsplit して help を日本語で表示
command! -nargs=* -complete=help Help vertical belowright help <args>@ja
" }


" --- @ ウィンドウ関連 --------------------------------------------------{
set splitright  " Window Split時に新Windowを右に表示
set splitbelow  " Window Split時に新windowを下に表示
" }


" --- @ CTags -----------------------------------------------------------{
" set tags+=.ctag;
set tags+=.ctag;~
set notagrelative


" open ctag in tab/vertical split
"   http://wknar.hatenablog.com/entry/vim-ctags
"   cf: https://gist.github.com/jondkinney/8563281

" - nnoremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <C-]> :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR>
" - nnoremap <leader><ESC> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
" nnoremap <C-]> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <leader><ESC> :vsp <CR>:exe("tjump ".expand("<cword>"))<CR>
nnoremap <localleader><ESC> :sp <CR>:exe("tjump ".expand("<cword>"))<CR>
nnoremap <c-[>  :pop<CR>

" for plug: tagbar
nmap <F8> :TagbarToggle<CR>

" }




" --- @ Mouse -----------------------------------------------------------{
" 端末上でもマウスを使う
if has('mouse')
    set mouse=a

    if has('macunix')
        set ttymouse=xterm2
    else
        if has('mouse_sgr')
            set ttymouse=sgr
        elseif v:version > 703 || v:version is 703 && has('patch632') " I couldn't use has('mouse_sgr') :-(
            set ttymouse=sgr
        else
            set ttymouse=xterm2
        endif
    endif
endif
" }


" --- @ ClipBoard #1 ----------------------------------------------------{
"   see also: http://nanasi.jp/articles/howto/editing/clipboard.html
if has("gui_running")
    set clipboard+=autoselect
    set guioptions+=a
else
"   set clipboard+=autoselect
"   set clipboard+=unnamed

    if has('macunix')
        set clipboard+=unnamed
    else
        set clipboard=unnamedplus
    endif
endif
 " }


" --- @ ClipBoard #2 ----------------------------------------------------{
" 上の設定しても、X-Window 間で ClipBoard 共有できないので、
" 以下を参考に ,y  ,p でコピペできるようにする
"   see also: http://ar156.dip.jp/tiempo/publish/108
if has("clipboard")
    vmap ,y "+y
    nmap ,p "+gP
    " exclude:{pattern} must be last ^= prepend += append
    if has('xxx_macunix')
        if has("gui_running") || has("xterm_clipboard")
            silent! set clipboard^=unnamedplus
            set clipboard^=unnamed
        endif
    else
        if has("gui_running") || has("xterm_clipboard")
            silent! set clipboard^=unnamedplus
            set clipboard^=unnamed
        endif
    endif
endif
 " }

" hehehe clipboard at last
set clipboard=autoselect



" --- @ Funcs: 文字コード取得関連 ---------------------------------------{
" カーソルの下の文字コード取得の為の関数群
" function! s:GetByte()
function! s:GetByte()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &enc, &fenc)
    return String2Hex(c)
endfunction

function! s:String2Hex(str)
    let out = ''
    let ix = 0
    while ix < strlen(a:str)
        let out = out . Nr2Hex(char2nr(a:str[ix]))
        let ix = ix + 1
    endwhile
    return out
endfunction

function! s:Nr2Hex(nr)
    let n = a:nr
    let r = ""
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunction

 " }


" --- @ ステータス表示関連 ----------------------------------------------{
" ステータス表示において、コマンドバッファ表示領域も確保
set laststatus=2

" 色指定
hi StatusLine ctermfg=darkyellow "// bg=dark
hi StatusLineNC cterm=none


" }


" }}} // End As Main




" === Mappings ========================================================={{{

" --- .vimrc の再読み込み ------------------------------------------------{
" nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>s. :<C-u>source $MYVIMRC<CR>
" }


" --- 行移動: 論理行, 物理行, 表示行 -------------------------------------{
" 行が折り返されている時(set wrap) j k
" キーによる上下移動が論理行単位ではなく表示行単位で行われるようにする
nnoremap j gj
nnoremap k gk
" 逆に普通の行単位で移動したい時のために逆の map も設定しておく
nnoremap gj j
nnoremap gk k
" }


" --- 最後の変更箇所に戻りやすく -----------------------------------------{
nnoremap <C-g> g;
" }


" --- Tab 操作 -----------------------------------------------------------{

" as super shortcut
" nnoremap <C-c> :tablast <bar> tabnew<CR>
nnoremap <C-c> :tabnew<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-n> :tabnext<CR>

" as 2-stroke assign
nnoremap      [Tag] <Nop>
nmap        t [Tag]
nmap <silent> [Tag]n :tabnext<CR>
nmap <silent> [Tag]p :tabprevious<CR>
nmap <silent> [Tag]x :tabclose<CR>
nmap <silent> [Tag]o :tabonly<CR>
nmap <silent> [Tag]N :execute 'silent! tabmove ' . tabpagenr()<CR>
nmap <silent> [Tag]P :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>

for n in range(1, 15)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" }


" --- ウィンドウ移動を楽に -----------------------------------------------{
nnoremap ww <C-w>w
nnoremap wh <C-w>h
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wl <C-w>l
" }


" --- < > キーによるインデントでビジュアルモード解除無効化 ---------------{
vnoremap < <gv
vnoremap > >gv
" }


" --- 検索語が真ん中に来るように -----------------------------------------{
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" }


" --- カーソルから行末までコピー(Yank) -----------------------------------{
nnoremap Y y$
" }


" --- コマンドラインモード: %$ でカレントファイルのフォルダパスに展開 ----{
"; --- cnoremap <expr> %^ getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> %$ getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" }

" --- コマンドラインモード: %% でカレントファイルのフルパスに展開 --------{
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p') : '%%'
" }


" --- コマンドラインモードでのキーバインドを Emacs スタイルに ------------{
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" // Alt + Ctrl + B で前の単語へ移動
cnoremap <Esc> <C-B> <S-Left>

" // Alt + Ctrl + F で次の単語へ移動
cnoremap <Esc> <C-F> <S-Right>
" }


" --- インサートモードでのキーバインドを Emacs スタイルに ----------------{
inoremap <C-a> <C-o>^
inoremap <C-b> <Left>
inoremap <C-d> <Del>
inoremap <C-e> <End>
inoremap <C-f> <Right>

" ESCでIMEを確実にOFF
" - inoremap <ESC> <ESC>:set iminsert=0<CR>
" }


" --- 検索パターンの入力を改善 -------------------------------------------{
" 検索パターン入力中は/および?をエスケープ
" そのまま入力するには<C-v>{/?}で
" always escape / and ? in search character.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
" }


" --- 日付関連短縮入力 ---------------------------------------------------{
inoremap <Leader>dtf <C-R>=strftime('%Y-%m-%d(%a) %H:%M:%S')<CR>
inoremap <Leader>dtd <C-R>=strftime('%Y%m%d')<CR>
inoremap <Leader>dtt <C-R>=strftime('%Y%m%d_%H%M')<CR>
" }


" --- highlight ----------------------------------------------------------{
" ハイライトON/OFF
" cf: https://qiita.com/ggtmtmgg/items/244acf7edc43d23e566c#_reference-d05d42c0aa17fba79b0f
"   vimrcにこちらのコード1行を追加すれば「,f」コマンドでON/OFFできるようになりかなり快適です。
noremap <silent> <Leader>f :if exists("g:syntax_on")\|syntax off\|else\|syntax enable\|endif<CR>
" }



" --- 矩形選択設定 -------------------------------------------------------{
" 矩形選択で行末を超えてブロックを選択できるようにする
" -> これを有効化すると、行末より先も選択できるが、ペースト時に空白として取り扱われる
"    また、行末($) 指定してヤンクしたものも、行末がスペースとして取り扱われる
" --- set virtualedit+=block
" }


" }}} // End As Mappings




" === Plugin Settings =================================================={{{



" --- Folding( 折りたたみ ) with system and foldCC -----------------------{
" use my arg: s:my_flag__fold_type
if s:my_flag__fold_type == 'mine'
    " --- folding as mine logic ------------------------------------------
    set foldenable                  " enable folding
    set foldcolumn=2                " add a fold column
    set foldmethod=marker           " detect triple-{ style fold markers
    set foldlevelstart=0            " start out with everything folded
    set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                    " which commands trigger auto-unfold
    function! s:MyFoldText()
        let line = getline(v:foldstart)

        let nucolwidth = &fdc + &number * &numberwidth
        let windowwidth = winwidth(0) - nucolwidth - 3
        let foldedlinecount = v:foldend - v:foldstart

        " expand tabs into spaces
        let onetab = strpart('          ', 0, &tabstop)
        let line = substitute(line, '\t', onetab, 'g')

        let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
        let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
        return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
    endfunction
    set foldtext=MyFoldText()
    "  // End As folding as system based
elseif s:my_flag__fold_type == 'foldcc'
    " --- folding as plugin: foldCC --------------------------------------
    " see also: http://leafcage.hateblo.jp/entry/2013/04/24/053113

    set foldtext=foldCC#foldtext()
    let g:foldCCtext_tail = 'v:foldend-v:foldstart+1'
"   let g:foldCCtext_head = '"(  ﾟｪﾟ)"'
"   let g:foldCCtext_tail = '"(ﾟｪﾟ  )". (v:foldend-v:foldstart+1)'
    let g:foldCCtext_head = '"----->>"'
    let g:foldCCtext_tail = '"<<-----". (v:foldend-v:foldstart+1)'
    let g:foldCCtext_enable_autofdc_adjuster = 1
    set foldcolumn=3

    " --- :: l(開く) -----------------------------------------------------
    nnoremap <expr>l  foldclosed('.') != -1 ? 'zo' : 'l'
    "

    " --- :: <C-_>(閉じる) -----------------------------------------------
    nnoremap <silent><C-_> :<C-u>call <SID>smart_foldcloser()<CR>
    function! s:smart_foldcloser()
        if foldlevel('.') == 0
            norm! zM
            return
        endif

        let foldc_lnum = foldclosed('.')
        norm! zc
        if foldc_lnum == -1
            return
        endif

        if foldclosed('.') != foldc_lnum
            return
        endif
        norm! zM
    endfunction
    "
    "

    " --- :: z[ , z] (FoldingMarkerを挿入する) ---------------------------
    "   FoldingMarkerを現在行の末尾に挿入します。z[で'{ { {'が、z]で'} } }'が挿入されます。
    "   カウントを指定すると、数字付きのFoldingMarkerが挿入されます。5z[だと'{ { {5'が、1z]だと'} } }1'が挿入されます。
    "   また、自動的にマーカーをコメント化したり、間に空白文字を挟むなどしてくれるので便利です。
    nnoremap  z[     :<C-u>call <SID>put_foldmarker(0)<CR>
    nnoremap  z]     :<C-u>call <SID>put_foldmarker(1)<CR>
    function! s:put_foldmarker(foldclose_p)
        let crrstr = getline('.')
        let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '
        let [cms_start, cms_end] = ['', '']
        let outside_a_comment_p = synIDattr(synID(line('.'), col('$')-1, 1), 'name') !~? 'comment'
        if outside_a_comment_p
            let cms_start = matchstr(&cms,'\V\s\*\zs\.\+\ze%s')
            let cms_end = matchstr(&cms,'\V%s\zs\.\+')
        endif
        let fmr = split(&fmr, ',')[a:foldclose_p]. (v:count ? v:count : '')
        exe 'norm! A'. padding. cms_start. fmr. cms_end
    endfunction
    "
    "

    " --- :: z<C-_> (現在折り畳みを閉じて、他の折り畳みをすべて閉じる) ---
    nnoremap <silent>z<C-_>    zMzvzc
    "

    " --- :: z0 (現在いる折り畳みと同じ階層までの全ての折り畳みを開く) ---
    nnoremap <silent>z0    :<C-u>set foldlevel=<C-r>=foldlevel('.')<CR><CR>
    "

    " --- :: [z , ]z  ----------------------------------------------------
    "   現在自分がいる折り畳みの先頭や末尾にジャンプします。
    "   特に大見出しなどの役割を果たしている巨大な折り畳み内で威力を発揮します。
    "   逆に小さな折り畳みではそれほど役に立ちません。
    "

    " --- :: zj , zk  ----------------------------------------------------
    "   いらない子
    "


    "  // End As folding as plugin: foldCC
else
    "// as none: use system default logics
endif
" } // End As Folding( 折りたたみ ) with system and foldCC


" --- json / vim-json ----------------------------------------------------{
" cf:
"   JSONにはコメント構文がない - Qiita
"   http://qiita.com/guimihanui/items/f9a10edf2315be0a2a64
"
"   vim-jsonのダブルクォート非表示機能を無効化する - Qiita
"   http://qiita.com/kadoppe/items/ffaef1f5a69f2cfcf12e
"
"   Vim で JSON のダブルクォーテーションが表示されない場合の解決法 - 大学生からの Web 開発
"   http://karur4n.hatenablog.com/entry/2015/03/13/034307
let g:vim_json_syntax_conceal = 0
" }


" --- vimfiler -----------------------------------------------------------{
let g:vimfiler_as_default_explorer = 1

" --- data_directory はramdiskを指定
" --- if has('win32')
" ---     let g:vimfiler_data_directory = 'R:\.vimfiler'
" --- elseif  has('macunix')
" ---     let g:vimfiler_data_directory = '/Volumes/RamDisk/.vimfiler'
" --- else
" ---     let g:vimfiler_data_directory = '/mnt/ramdisk/.vimfiler'
" --- endif

" vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1

" セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0

" tabdrop/tabopen モードで開く
" --- let g:vimfiler_edit_action = 'tabdrop'
let g:vimfiler_edit_action = 'tabopen'

" 現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
nnoremap <silent> <Space>ee :<C-u>VimFilerBufferDir -quit<CR>

" 現在開いているバッファをIDE風に開く
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=45 -no-quit<CR>
nnoremap <silent> <Space>ei :<C-u>VimFilerBufferDir -split -simple -winwidth=45 -no-quit<CR>

" デフォルトのキーマッピングを変更
augroup vimrc
    autocmd FileType vimfiler call s:vimfiler_my_settings()
augroup END
function! s:vimfiler_my_settings()
    nmap <buffer> q <Plug>(vimfiler_exit)
    nmap <buffer> Q <Plug>(vimfiler_hide)
endfunction
" } // End As vimfiler




" --- Excide Translator --------------------------------------------------{
" 開いたバッファを q で閉じれるようにする
autocmd BufEnter ==Translate==\ Excite nnoremap <buffer> <silent> q :<C-u>close<CR>
xnoremap E :ExciteTranslate<CR>
" }


" === AutoCmd =========================================================={{{

" Set tab per FileType
autocmd FileType html setlocal ts=2 sts=2 sw=2
autocmd FileType ruby setlocal ts=2 sts=2 sw=2
autocmd FileType javascript setlocal ts=2 sts=2 sw=2


" --- tidies: misc -------------------------------------------------------{
autocmd BufRead,BufNewFile *.blade.php set filetype=blade
" } // End As tidies: misc



" --- tidies: tt: TemplateToolKit( perl ) --------------------------------{
augroup templatetoolkitfiletypes
  autocmd!
  au! BufRead,BufNewFile,BufWinEnter *.tt2 set filetype=tt2
augroup END
" }


" --- mine auto commnds --------------------------------------------------{
augroup MyAutoCmd
  autocmd!

  au BufRead,BufNewFile *.haml set ft=haml
  au BufRead,BufNewFile *.sass set ft=sass

  "自動的に QuickFix リストを表示する
  autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
  autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

augroup END
" }

" }}} // End As AutoCmd




" === Include: Host Specific file ======================================{{{
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" }}} // End As Include
