
" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

 "python << EOF
 "# Insert python here
 "EOF

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set mouse-=a		" disable mouse usage (all modes)
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" turn on line numbers:
set number
" Turnoff highlighting previous search term
set nohlsearch
" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
"highlight NonText #4a4a59
"highlight SpecialKey #4a4a59
" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=200		" keep 50 lines of command line history

" always use 4 spaces for a tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" show tab and spacing characters
""set listchars=tab:▸\ ,eol:¬
""set list

" stops the cscope tags (cstag) from overriding ctags
set nocst

" use pathogen for installing plug-ins from bundle directory
call pathogen#infect()

syntax on

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

ab #d #define
ab #i #include
ab #b /****************************************
ab #e <Space>****************************************/
ab #l /*-------------------------------------------- */
" don't forget can use macros within alias declarations, can send ^M as
" \new-line character, ^ [ as carriage return??

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

"if has("cscope") && filereadable("/usr/bin/csco
"   set csprg=/usr/bin/cscope
 "#   set csto=0
 "#   set cst
 "#   set nocsverb
 "#   " add any database in current directory
 "#   if filereadable("cscope.out")
 "#      cs add cscope.out
 "#   " else add database pointed to by environment
 "#   elseif $CSCOPE_DB != ""
 "#      cs add $CSCOPE_DB
 "#   endif
 "#   set csverb
 "#endif

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Ctags auto updates
function! UPDATE_TAGS()
  let _f_ = expand("%:p")
  let _cmd_ = '"ctags -a -f /dvr/tags --c++-kinds=+p --fields=+iaS --extra=+q " ' . '"' . _f_ . '"'
  let _resp = system(_cmd_)
  unlet _cmd_
  unlet _f_
  unlet _resp
endfunction

 "map <F5> :UPDATE_TAGS()<CR>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " automatically update the tags in selected file extensions
  autocmd BufWritePost *.java, *.cpp,*.h,*.c,*.py call UPDATE_TAGS()

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  autocmd FileType * set formatoptions=tcql
  \ nocindent comments&
  autocmd FileType java,c,h,cpp set formatoptions=croql
  \ cindent comments=sr:/*,mb:*,ex:*/,://

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  autocmd FileType * set textwidth=99
  autocmd FileType c,cpp,h,python set textwidth=79

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Key mappings for plug-ins and customisations
" 11-12: many have been removed due to using python mode plug-in defaults

" Taglist
let Tlist_GainFocus_On_ToggleOpen = 1
map <c-P> :TlistToggle<CR>
map <a-V> :TlistSessionSave vim_session<CR>
map <a-L> :TlistSessionLoad vim_session<CR>

"  Not sure if this is still necessary with python mode
map <c-G> :TaskList<CR>


" python Mode related key bindings
" Set key 'R' for run python code
"" not currently using this, could map to something else is needed
let g:pymode_run_key = 'R'
" Key for show python documentation
let g:pymode_doc_key = 'K'
" Skip annoying error for libraries without information
let g:pymode_lint_ignore = "W*"
let g:pymode_lint_ignore = "E*"
" Key for set/unset breakpoint
"" not currently using this, could map to something else is needed
""let g:pymode_breakpoint_key = '<s-b>' 'leader>b'
" default: ctrl-space is short for rope auto complete

" toggle fold (single open, all open, all close respectively)
 "  <space> already toggle single fold
"inoremap f <C-O>za
"nnoremap f za
"onoremap f <C-C>za
"vnoremap f zf
"inoremap F <C-O>zR
"nnoremap F zR
"onoremap F <C-C>zR
"vnoremap F zf
"inoremap <s-F> <C-O>zM
"nnoremap <s-F> zM
"onoremap <s-F> <C-C>zM
"vnoremap <s-F> zf
"map f za
map <c-F> zR
map <s-F> zM

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" autopep8 corrections

"" useful for autopep8 corrections within vim 
"" tells vim not to automatically reload changed files
set noautoread 

function! DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

          " sets up mappings to function

com! DiffSaved call DiffWithSaved()
"map <Leader>ds :DiffSaved<CR>
"          Once you run that, you can use the vim copy-diff and other diff commands to quickly go
"          through and accept/not accept changes. Plus, all will be stored in undo history.
"
"          " run these commands after sourcing the above function
"
"          " % expands to filename (also %:h to head, %:t to tail)
"          " if it throws an error, just do :cd %:h first
"
"          :!autopep8 --in-place %
"          :DiffSaved
"          use :%diffpu to push all changes in scratch buffer to file


" This needs to be improved
"Press downset tags=/home/tan/tags,./tags
set tags+=tags;~/tags
"~/src/scratch/tags
"set tags+=tags;/

" Don't use Ex mode, use Q for formatting
"map Q gq
" Replace with Harvard Prof fine's:
map Q 0ma}b:'a,.j<CR>070 ?  *<Esc>dwi<CR><Esc>
