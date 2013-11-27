" Stephen Diehl .vimrc
" Most aimed at Haskell / Agda / Python / C / LaTeX 
"
" This is about 5 years of work. Feel free to copy any of it!

syntax on                     " syntax highlighing
filetype plugin indent on     " enable loading indent file for filetype

set nocompatible
set number
set nowrap
set noshowmode
set tw=110
set formatprg=par
set pumheight=12             " Keep a small completion window
set conceallevel=0
set smartcase

set smarttab
set smartindent
set autoindent
set softtabstop=2
set shiftwidth=2
set expandtab

set completeopt=menuone,menu,longest

set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu

set t_Co=256

let g:SuperTabDefaultCompletionType = "context"

" ----------------------------------------------
" GUI Options
" ----------------------------------------------

" Prevent buggy resizing with xmonad
set guiheadroom=0

set mouse=a
set mousemodel=popup

set guioptions-=m
set guioptions-=r
set guioptions-=T
set guioptions-=L
set background=dark

set wildmenu
set wildmode=longest:list

set dictionary="/usr/dict/words"

function! Tab_Or_Complete()
  return 'foo'
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

inoremap <tab> <c-r>=Tab_Or_Complete()<CR>

" ----------------------------------------------
" Airline
" ----------------------------------------------

let g:syntastic_auto_loc_list=0

let g:airline_symbols = {}
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" ----------------------------------------------
" Other Languages
" ----------------------------------------------

autocmd BufNewFile,BufRead *.agda set filetype=agda
autocmd BufNewFile,BufRead *.idr set filetype=idris
autocmd BufNewFile,BufRead *.ocaml set filetype=ocaml
autocmd BufNewFile,BufRead *.go set filetype=go
autocmd BufNewFile,BufRead *.pure set filetype=pure
autocmd BufNewFile,BufRead *.js set filetype=javascript
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *.md set filetype=markdown

" ----------------------------------------------
" Racket / Scheme Lisp
" ----------------------------------------------

if has("autocmd")
    au BufReadPost *.rkt,*.rktl set filetype=racket
    au filetype racket set lisp
endif

" ----------------------------------------------
" C
" ----------------------------------------------
autocmd BufEnter *.c set formatprg=astyle\ --style=1tbs
autocmd BufEnter *.c compiler splint
autocmd BufWritePre *.c :%s/\s\+$//e

" ----------------------------------------------
" Haskell
" ----------------------------------------------

" -- Don't flicker when executing macros/functions
"set lazyredraw

let g:ctrlp_custom_ignore = '\v[\/]static$'

set wildignore+=*.o
set wildignore+=*.hi
set wildignore+=*.chi

au FileType cabal setl et ts=2 sw=2 sts=2
au Bufread,BufNewFile *.hsc set filetype=haskell

autocmd Bufenter *.hs compiler ghc
autocmd BufEnter *.hs set formatprg=pointfree

let g:hdevtools_options = '-g -isrc -g -Wall -g -hide-package -g transformers'
let g:ghcmod_ghc_options = []

" Reload
map <silent> tu :call GHC_BrowseAll()<CR>
" Type Lookup
map tt :call GHC_ShowType(0)<CR>
" Type Infer
map <silent> tw :call GHC_ShowType(1)<CR>

"map ti :call GHC_ShowInfo()<CR>
map trai :call GHC_MkImportsExplicit()<CR>

map <silent> <Leader>e :Errors<CR>
map <Leader>s :SyntasticToggleMode<CR>

if has("gui_running")
  map tghc :popup ]OPTIONS_GHC<cr>
else
  map tghc :emenu ]OPTIONS_GHC.
endif

if has("gui_running")
  map tlo :popup ]LANGUAGES_GHC<cr>
else
  map tlo :emenu ]LANGUAGES_GHC.
endif

au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>

" ----------------------------------------------
" Python
" ----------------------------------------------

autocmd BufNewFile,BufRead *.py set formatprg=par

" ----------------------------------------------
" Fix trailing Whitespace
" ----------------------------------------------

" Autofix all whitespace on save
autocmd BufWritePre *.py :%s/\s\+$//e
" Delete all trailing empty lines on files
autocmd BufWritePre *.py :%s/\(\s*\n\)\+\%$//e

" Autofix all whitespace on save
autocmd BufWritePre *.hs :%s/\s\+$//e
" Delete all trailing empty lines on files
autocmd BufWritePre *.hs :%s/\(\s*\n\)\+\%$//e

" ----------------------------------------------
" Clipboard
" ----------------------------------------------

"X Clipboard
set clipboard=unnamedplus,autoselect

noremap <F11> :set invpaste paste?<CR>
set pastetoggle=<F11>
set showmode

set shellslash
set showmatch


" Latex Stuff
let g:tex_flavor='latex'
let python_highlight_all=1


map <silent> <Leader>m :!make > /dev/null &<CR>
map <Leader>n :NERDTreeToggle<CR>

map <Leader>u :source $MYVIMRC<CR>
map <Leader>ig :IndentGuidesToggle<CR>

" ----------------------------------------------
" CTRL+P
" ----------------------------------------------
map <silent> <Leader>t :CtrlP()<CR>

" ----------------------------------------------
" Javascript, ick
" ----------------------------------------------
map <silent> <leader>jb :call g:Jsbeautify()<CR>
map <Leader>jl :JSLintUpdate<CR>

" configure browser for haskell_doc.vim
let g:haddock_browser = "chromium"


command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    ccl
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction

" Coffeescript Stuff
"let coffee_compile_on_save=0
"map cv :CoffeeView<CR>
"map cm :CoffeeMake<CR>

func! Todos()
    exec "noautocmd vimgrep /TODO/j **/*.py"
    exec "cw"
endfunc

" ----------------------------------------------
" Flush
" ----------------------------------------------
" Flush swap files recursively in this directory, usefull if Vim
" crashes.
command! Flush :call Flush()
func! Flush()
    exec "!find . -name \".*.swp\" | xargs rm -f"
endfunc
" ----------------------------------------------

command! Todo :call Todos()
command! Pep8 :call Pep8()

func! CompileRunGcc()
  exec "w"
  exec "!gcc -g % -o %<"
  exec "! ./%<"
endfunc

if has("gui_running")
    " For gvim
    "colorscheme molokai
    colorscheme vanzan
    "colorscheme fruity
    "set guifont=Tamsyn\ 10
    "set guifont=Monaco\ 10
    set guifont=Monaco\ 8
else
    " For terminal
    colorscheme jellybeans
    "set guifont=ProggyCleanTT\ 12
    autocmd FocusGained * call s:CommandTFlush()
endif

nnoremap <C-j> <C-W>w

" tab navigation like firefox
map tn :tabnext<CR>
map tp :tabprevious<CR>

map <C-t> :tabnew<CR>
"map <C-w> :tabclose<CR>

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a, :Tabularize /,<CR>

highlight SpellBad term=underline gui=underline guisp=Blue
highlight Error term=underline gui=underline guibg=#00ff00

" ----------------------------------------------
" Slime
" ----------------------------------------------

let g:slime_target = "tmux"
let g:slime_paste_file = tempname()

" ----------------------------------------------
" Git Version Traversal
" ----------------------------------------------
map gd :Gdiff<CR>
map gb :Gblame<CR>

" Git checkout at block level
vmap do :diffget<CR>
map gd :Gdiff<CR>

" ----------------------------------------------
" Fast Navigation
" ----------------------------------------------
" Use space to jump between paragraphs
"map <Space> }}
"map <S-Space> {{

" Go to last edited line one keystroke 
map ` g;
map gl <C-^> 

" ----------------------------------------------
" Searching
" ----------------------------------------------

set incsearch
map ff /\c

if &t_Co > 2 || has("gui_running")
    set hlsearch                "Highlight all search matches if color is
endif                           "possible (:noh to toggle off)
nnoremap <silent> <return> :noh<return>

" ----------------------------------------------
" Tagbar
" ----------------------------------------------

nmap <leader>= :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" ----------------------------------------------
" Autocorect
" ----------------------------------------------

ab teh the
ab sefl self

" ----------------------------------------------
" Unicode Entry
" ----------------------------------------------

autocmd BufReadPost *.agda cal s:AgdaKeys()

nmap <C-c> <C-l> :Reload<CR>
nmap <C-c> <C-r> :Refine("False")<CR>
nmap <C-c> <C-space> :call Give()<CR>

function s:AgdaKeys()
    imap <buffer> \bn ℕ
    imap <buffer> \to →
    imap <buffer> \all →

    imap <buffer> \alpha α
    imap <buffer> \beta β
    imap <buffer> \gamma γ
    imap <buffer> \delta δ
    imap <buffer> \epsilon ∊
    imap <buffer> \varepsilon ε
    imap <buffer> \zeta ζ
    imap <buffer> \eta η
    imap <buffer> \theta θ
    imap <buffer> \vartheta ϑ
    imap <buffer> \iota ι
    imap <buffer> \kappa κ
    imap <buffer> \lambda λ
    imap <buffer> \mu μ
    imap <buffer> \nu ν
    imap <buffer> \xi ξ
    imap <buffer> \pi π
    imap <buffer> \varpi ϖ
    imap <buffer> \rho ρ
    imap <buffer> \varrho ϱ
    imap <buffer> \sigma σ
    imap <buffer> \varsigma ς
    imap <buffer> \tau τ
    imap <buffer> \upsilon υ
    imap <buffer> \phi φ
    imap <buffer> \varphi ϕ
    imap <buffer> \chi χ
    imap <buffer> \psi ψ
    imap <buffer> \omega ω
    imap <buffer> \Gamma Γ
    imap <buffer> \Delta Δ
    imap <buffer> \Theta Θ
    imap <buffer> \Lambda Λ
    imap <buffer> \Xi Ξ
    imap <buffer> \Pi Π
    imap <buffer> \Upsilon Υ
    imap <buffer> \Phi Φ
    imap <buffer> \Psi Ψ
    imap <buffer> \Omega Ω
    imap <buffer> \leq ≤
    imap <buffer> \ll ≪
    imap <buffer> \prec ≺
    imap <buffer> \preceq ≼
    imap <buffer> \subset ⊂
    imap <buffer> \subseteq ⊆
    imap <buffer> \sqsubset ⊏
    imap <buffer> \sqsubseteq ⊑
    imap <buffer> \in ∈
    imap <buffer> \vdash ⊢
    imap <buffer> \mid ∣
    imap <buffer> \smile ⌣
    imap <buffer> \geq ≥
    imap <buffer> \gg ≫
    imap <buffer> \succ ≻
    imap <buffer> \succeq ≽
    imap <buffer> \supset ⊃
    imap <buffer> \supseteq ⊇
    imap <buffer> \sqsupset ⊐
    imap <buffer> \sqsupseteq ⊒
    imap <buffer> \ni ∋
    imap <buffer> \dashv ⊣
    imap <buffer> \parallel ∥
    imap <buffer> \frown ⌢
    imap <buffer> \notin ∉
    imap <buffer> \equiv ≡
    imap <buffer> \doteq ≐
    imap <buffer> \sim ∼
    imap <buffer> \simeq ≃
    imap <buffer> \approx ≈
    imap <buffer> \cong ≅
    imap <buffer> \Join ⋈
    imap <buffer> \bowtie ⋈
    imap <buffer> \propto ∝
    imap <buffer> \models ⊨
    imap <buffer> \perp ⊥
    imap <buffer> \asymp ≍
    imap <buffer> \neq ≠
    imap <buffer> \pm ±
    imap <buffer> \cdot ⋅
    imap <buffer> \times ×
    imap <buffer> \cup ∪
    imap <buffer> \sqcup ⊔
    imap <buffer> \vee ∨
    imap <buffer> \oplus ⊕
    imap <buffer> \odot ⊙
    imap <buffer> \otimes ⊗
    imap <buffer> \bigtriangleup △
    imap <buffer> \lhd ⊲
    imap <buffer> \unlhd ⊴
    imap <buffer> \mp ∓
    imap <buffer> \div ÷
    imap <buffer> \setminus ∖
    imap <buffer> \cap ∩
    imap <buffer> \sqcap ⊓
    imap <buffer> \wedge ∧
    imap <buffer> \ominus ⊖
    imap <buffer> \oslash ⊘
    imap <buffer> \bigcirc ○
    imap <buffer> \bigtriangledown ▽
    imap <buffer> \rhd ⊳
    imap <buffer> \unrhd ⊵
    imap <buffer> \triangleleft ◁
    imap <buffer> \triangleright ▷
    imap <buffer> \star ⋆
    imap <buffer> \ast ∗
    imap <buffer> \circ ∘
    imap <buffer> \bullet ∙
    imap <buffer> \diamond ⋄
    imap <buffer> \uplus ⊎
    imap <buffer> \dagger †
    imap <buffer> \ddagger ‡
    imap <buffer> \wr ≀
    imap <buffer> \sum ∑
    imap <buffer> \prod ∏
    imap <buffer> \coprod ∐
    imap <buffer> \int ∫
    imap <buffer> \bigcup ⋃
    imap <buffer> \bigcap ⋂
    imap <buffer> \bigsqcup ⊔
    imap <buffer> \oint ∮
    imap <buffer> \bigvee ⋁
    imap <buffer> \bigwedge ⋀
    imap <buffer> \bigoplus ⊕
    imap <buffer> \bigotimes ⊗
    imap <buffer> \bigodot ⊙
    imap <buffer> \biguplus ⊎
    imap <buffer> \leftarrow ←
    imap <buffer> \rightarrow →
    imap <buffer> \leftrightarrow ↔
    imap <buffer> \Leftarrow ⇐
    imap <buffer> \Rightarrow ⇒
    imap <buffer> \Leftrightarrow ⇔
    imap <buffer> \mapsto ↦
    imap <buffer> \hookleftarrow ↩
    imap <buffer> \leftharpoonup ↼
    imap <buffer> \leftharpoondown ↽
    imap <buffer> \hookrightarrow ↪
    imap <buffer> \rightharpoonup ⇀
    imap <buffer> \rightharpoondown ⇁
    imap <buffer> \longleftarrow ←
    imap <buffer> \longrightarrow →
    imap <buffer> \longleftrightarrow ↔
    imap <buffer> \Longleftarrow ⇐
    imap <buffer> \Longrightarrow ⇒
    imap <buffer> \Longleftrightarrow ⇔
    imap <buffer> \longmapsto ⇖
    imap <buffer> \uparrow ↑
    imap <buffer> \downarrow ↓
    imap <buffer> \updownarrow ↕
    imap <buffer> \Uparrow ⇑
    imap <buffer> \Downarrow ⇓
    imap <buffer> \Updownarrow ⇕
    imap <buffer> \nearrow ↗
    imap <buffer> \searrow ↘
    imap <buffer> \swarrow ↙
    imap <buffer> \nwarrow ↖
    imap <buffer> \leadsto ↝
    imap <buffer> \dots …
    imap <buffer> \cdots ⋯
    imap <buffer> \vdots ⋮
    imap <buffer> \ddots ⋱
    imap <buffer> \hbar ℏ
    imap <buffer> \ell ℓ
    imap <buffer> \Re ℜ
    imap <buffer> \Im ℑ
    imap <buffer> \aleph א
    imap <buffer> \wp ℘
    imap <buffer> \forall ∀
    imap <buffer> \exists ∃
    imap <buffer> \mho ℧
    imap <buffer> \partial ∂
    imap <buffer> \prime ′
    imap <buffer> \emptyset ∅
    imap <buffer> \infty ∞
    imap <buffer> \nabla ∇
    imap <buffer> \triangle △
    imap <buffer> \Box □
    imap <buffer> \Diamond ◇
    imap <buffer> \bot ⊥
    imap <buffer> \top ⊤
    imap <buffer> \angle ∠
    imap <buffer> \surd √
    imap <buffer> \diamondsuit ♢
    imap <buffer> \heartsuit ♡
    imap <buffer> \clubsuit ♣
    imap <buffer> \spadesuit ♠
    imap <buffer> \neg ¬
    imap <buffer> \flat ♭
    imap <buffer> \natural ♮
    imap <buffer> \sharp ♯
    imap <buffer> \digamma Ϝ
    imap <buffer> \varkappa ϰ
    imap <buffer> \beth ב
    imap <buffer> \daleth ד
    imap <buffer> \gimel ג
    imap <buffer> \lessdot ⋖
    imap <buffer> \leqslant ≤
    imap <buffer> \leqq ≦
    imap <buffer> \lll ⋘
    imap <buffer> \lesssim ≲
    imap <buffer> \lessgtr ≶
    imap <buffer> \lesseqgtr ⋚
    imap <buffer> \preccurlyeq ≼
    imap <buffer> \curlyeqprec ⋞
    imap <buffer> \precsim ≾
    imap <buffer> \Subset ⋐
    imap <buffer> \sqsubset ⊏
    imap <buffer> \therefore ∴
    imap <buffer> \smallsmile ⌣
    imap <buffer> \vartriangleleft ⊲
    imap <buffer> \trianglelefteq ⊴
    imap <buffer> \gtrdot ⋗
    imap <buffer> \geqq ≧
    imap <buffer> \ggg ⋙
    imap <buffer> \gtrsim ≳
    imap <buffer> \gtrless ≷
    imap <buffer> \gtreqless ⋛
    imap <buffer> \succcurlyeq ≽
    imap <buffer> \curlyeqsucc ⋟
    imap <buffer> \succsim ≿
    imap <buffer> \Supset ⋑
    imap <buffer> \sqsupset ⊐
    imap <buffer> \because ∵
    imap <buffer> \shortparallel ∥
    imap <buffer> \smallfrown ⌢
    imap <buffer> \vartriangleright ⊳
    imap <buffer> \trianglerighteq ⊵
    imap <buffer> \doteqdot ≑
    imap <buffer> \risingdotseq ≓
    imap <buffer> \fallingdotseq ≒
    imap <buffer> \eqcirc ≖
    imap <buffer> \circeq ≗
    imap <buffer> \triangleq ≜
    imap <buffer> \bumpeq ≏
    imap <buffer> \Bumpeq ≎
    imap <buffer> \thicksim ∼
    imap <buffer> \thickapprox ≈
    imap <buffer> \approxeq ≊
    imap <buffer> \backsim ∽
    imap <buffer> \vDash ⊨
    imap <buffer> \Vdash ⊩
    imap <buffer> \Vvdash ⊪
    imap <buffer> \backepsilon ∍
    imap <buffer> \varpropto ∝
    imap <buffer> \between ≬
    imap <buffer> \pitchfork ⋔
    imap <buffer> \blacktriangleleft ◀
    imap <buffer> \blacktriangleright ▷
    imap <buffer> \dashleftarrow ⇠
    imap <buffer> \leftleftarrows ⇇
    imap <buffer> \leftrightarrows ⇆
    imap <buffer> \Lleftarrow ⇚
    imap <buffer> \twoheadleftarrow ↞
    imap <buffer> \leftarrowtail ↢
    imap <buffer> \leftrightharpoons ⇋
    imap <buffer> \Lsh ↰
    imap <buffer> \looparrowleft ↫
    imap <buffer> \curvearrowleft ↶
    imap <buffer> \circlearrowleft ↺
    imap <buffer> \dashrightarrow ⇢
    imap <buffer> \rightrightarrows ⇉
    imap <buffer> \rightleftarrows ⇄
    imap <buffer> \Rrightarrow ⇛
    imap <buffer> \twoheadrightarrow ↠
    imap <buffer> \rightarrowtail ↣
    imap <buffer> \rightleftharpoons ⇌
    imap <buffer> \Rsh ↱
    imap <buffer> \looparrowright ↬
    imap <buffer> \curvearrowright ↷
    imap <buffer> \circlearrowright ↻
    imap <buffer> \multimap ⊸
    imap <buffer> \upuparrows ⇈
    imap <buffer> \downdownarrows ⇊
    imap <buffer> \upharpoonleft ↿
    imap <buffer> \upharpoonright ↾
    imap <buffer> \downharpoonleft ⇃
    imap <buffer> \downharpoonright ⇂
    imap <buffer> \rightsquigarrow ⇝
    imap <buffer> \leftrightsquigarrow ↭
    imap <buffer> \dotplus ∔
    imap <buffer> \ltimes ⋉
    imap <buffer> \Cup ⋓
    imap <buffer> \veebar ⊻
    imap <buffer> \boxplus ⊞
    imap <buffer> \boxtimes ⊠
    imap <buffer> \leftthreetimes ⋋
    imap <buffer> \curlyvee ⋎
    imap <buffer> \centerdot ⋅
    imap <buffer> \rtimes ⋈
    imap <buffer> \Cap ⋒
    imap <buffer> \barwedge ⊼
    imap <buffer> \boxminus ⊟
    imap <buffer> \boxdot ⊡
    imap <buffer> \rightthreetimes ⋌
    imap <buffer> \curlywedge ⋏
    imap <buffer> \intercal ⊺
    imap <buffer> \divideontimes ⋇
    imap <buffer> \smallsetminus ∖
    imap <buffer> \circleddash ⊝
    imap <buffer> \circledcirc ⊚
    imap <buffer> \circledast ⊛
    imap <buffer> \hbar ℏ
    imap <buffer> \hslash ℏ
    imap <buffer> \square □
    imap <buffer> \blacksquare ■
    imap <buffer> \circledS Ⓢ
    imap <buffer> \vartriangle △
    imap <buffer> \blacktriangle ▲
    imap <buffer> \complement ∁
    imap <buffer> \triangledown ▽
    imap <buffer> \blacktriangledown ▼
    imap <buffer> \lozenge ◊
    imap <buffer> \blacklozenge ◆
    imap <buffer> \bigstar ★
    imap <buffer> \angle ∠
    imap <buffer> \measuredangle ∡
    imap <buffer> \sphericalangle ∢
    imap <buffer> \backprime ‵
    imap <buffer> \nexists ∄
    imap <buffer> \Finv Ⅎ
    imap <buffer> \varnothing ∅
    imap <buffer> \eth ð
    imap <buffer> \mho ℧
endfunction
