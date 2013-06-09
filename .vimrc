" vim (not vi)
set nocompatible

" DiffOrig
set diffexpr=MyDiff()
function! MyDiff()
   let opt = '-a --binary '
   if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
   if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
   let arg1 = v:fname_in
   if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
   let arg2 = v:fname_new
   if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
   let arg3 = v:fname_out
   if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
   let eq = ''
   if $VIMRUNTIME =~ ' '
     if &sh =~ '\<cmd'
       let cmd = '""' . $VIMRUNTIME . '\diff"'
       let eq = '"'
     else
       let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
     endif
   else
     let cmd = $VIMRUNTIME . '\diff'
   endif
   silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

function! TabMessage(cmd)
	redir => message
	silent execute a:cmd
	redir END
	vnew
	silent put=message
	set nomodified
endfunction
" can use Tab scriptname/.. etc to send output of vim command to a new tab
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
 
" set fileformats for compatibility
" whichever fileformat comes first will be the default
" unless you set fileformat=x later
set fileformats=unix,dos
" behave mswin
" set fileformat for default format
set fileformat=unix
" set font type and size
" always enable status line
set laststatus=2
" make the leader commands/motion commands show up in the command bar
set showcmd
" setup statusline format
set statusline=%t\    "name "
set statusline+=%y\   "file type"
set statusline+=%{&ff}\  "file format (unix/dos)"
set statusline+=%M\   "changed or not"
set statusline+=%=   "go to right hand side of status bar"
"%{} evaluates everything inside of it"
set statusline+=[%<%-.50{expand('%:~:h')}\\]\ 
"column (first # is 1 == after tab; second # counts tab whitespace"
" set statusline+=col(%c/%v)\ 
set statusline+=%l\|%L\|   "row- current vs total"
set statusline+=%P    "% through file"
"allow chging buffers without saving
set hidden

"put swp files and ~ files into /.vim/temp
"to figure out windows location without spaces, 
"go to \C. cmd dir \x
"then see that 'program files (x86)' has 
"shortform 'PROGRA~2'
" set backupdir=~/Temp
" set directory=~/Temp
set nobackup
set noswapfile

"" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo'
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"set leader
let mapleader = " "
" remaps <leader>hjkl to ctrl+w hjkl to move buffers quickly
" note alt keys don't work well with terminal (gets caught somewhere)
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>q <C-w>q
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
" <alt-r> forces screen update if txts get messed up
nnoremap <leader>r :redraw!<CR>
" command to edit vimrc save time from opening it
nnoremap <leader>ev :e $MYVIMRC<CR>
" <M-o> during normal mode toggles upper/lower case
nnoremap <leader>u g~iw
" toggles copy and paste mode so indenting doesn't get screwed up
nnoremap <leader>p :set paste!<CR>
" toggles wrapline
nnoremap <leader>w :set wrap!<CR>
" toggle tabs/indentation
nnoremap <leader>i :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nnoremap <leader>I :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

" exit search highlight mode by pressing enter again
nnoremap <CR> :set hlsearch!<CR><CR>
" change word to upper case when in insert mode and press <M-o>
inoremap <C-u> <esc>gUiwi
" for long lines, j goes to same line next row
nnoremap j gj
nnoremap k gk
" if needed sudo access to write file
cmap w!! w !sudo tee % >/dev/null

augroup vimgroup
	au!

	" change status line color based on mode
	" bg = font color; fg = background
	if version >= 700
		autocmd InsertEnter * hi StatusLine term=reverse ctermfg=DarkRed ctermbg=White gui=undercurl guisp=DarkRed
		autocmd InsertLeave * hi StatusLine term=reverse ctermfg=DarkGreen ctermbg=White gui=bold,reverse
	endif
	
	" update and implement vimrc chgs once it is written
	" might have some problems with recursion/duplication
	autocmd bufwritepost $MYVIMRC source $MYVIMRC

	"auto open error window on make/compiling
	autocmd QuickFixCmdPost [^l]* nested copen
	autocmd QuickFixCmdPost    l* nested lopen

	" save the za folds for access next time
	autocmd BufWritePost * silent! mkview
	autocmd BufWinEnter * silent! loadview
augroup end

" pep8 etc needs this to run
filetype plugin indent on
"setup pathogen and plugins
call pathogen#infect()
call pathogen#helptags()
"NERDTREE plugin
nnoremap <F2> :NERDTreeToggle<CR>
" gundo plugin (redo/undo tree)
nnoremap <F3> :GundoToggle<CR>
" taglist plugin
nnoremap <F4> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1 " exit if taglist is last window open 
let Tlist_Show_One_File = 1 " Only show tags for current buffer 
let Tlist_Use_Right_Window = 0 " Open on right side
" pep8 plugin
let g:pep8_map='<F6>'

" fugitive plugin (make git commands G[command])
nnoremap <leader>gadd :Gwrite
nnoremap <leader>grm :Gremove
nnoremap <leader>gmv :Gmove
nnoremap <leader>gcommit :Gcommit
" other commands include :Gread == :Git checkout % == revert 
" all changes to git save

" pylint plugin (for .py files, :w will autocall :make which will run pylint)
autocmd FileType python compiler pylint
" pydoc help plugin
" TODO: figure out how to use pydoc
let g:pydoc_cmd = 'python -m pydoc'


" set <F5> to run python script
" if executed in visual mode, then the text block selected will be
" evaluated as python code; 
" the result will be put in place of the text
nnoremap <F5> :!python %<CR>
" to pass file into commandline, use :%! grep xyz
" when in visual mode, <F5> passes in selected text
vnoremap <F5> :!python<CR>
" set <F7> to automatically email code
nnoremap <F7> :TOhtml<CR>:!vim_email.py -f "%:p"<CR>:w<bar>bd<CR>
" set <F8> to create template unittest file
nnoremap <F8> :!make_unittest.py -f "%:p"<CR>


set tabstop=4
set shiftwidth=4
set softtabstop=4
"indent rounded to next full shift width
set shiftround
"auto-indent code blocks
set autoindent
"show line numbers
set number
" set code folding (press za to open/close)
set foldmethod=indent
set foldlevel=10
"syntax highlighting on
syntax on
" don't breakup lines longer than textwidth=x
set textwidth=0
" search highlighting 
" and highlight next match as you are typing search
set hlsearch incsearch
" do not show whitespace (python au will show whitespace later)
set nolist

augroup python_group
    " TODO: make everything buffer specific
    " long line and \t becomes matched in vimrc
    
	au!

	" tab width = 4 spaces
	au FileType python setlocal tabstop=4
	" indent width = 4
	au FileType python setlocal shiftwidth=4

	"delete multiple spaces like it was a single tab
	au FileType python setlocal softtabstop=4

	" expand tabs to spaces
	au FileType python setlocal expandtab

	" autocmd FileType python set nowrap
	" show tabs as >----
	autocmd FileType python setlocal list
	autocmd FileType python setlocal listchars=tab:>-

	" not wrap lines since python lines shouldn't go past 80 chars
	" to only highlight letters > 70: use '\%>50v.\+'
	" b: means specific to this buffer"
	autocmd BufEnter *.py
		\ let long_line=matchadd("IncSearch", '^.\{80\}.*$')
		\| let bad_tab=matchadd("ErrorMsg", '\t')
	" makes nonpython docs not match"
	autocmd BufLeave *.py
		\ call clearmatches()

	" set <M-3> and <M-4> to comment/uncomment python code
	autocmd FileType python nnoremap <buffer> <leader>c ^i## <esc>
	autocmd FileType python nnoremap <buffer> <leader>C ^dw
augroup end

augroup html_group
	au!
	autocmd FileType html
		\ setlocal nowrap
		\| setlocal tabstop=2
		\| setlocal softtabstop=2
		\| setlocal shiftwidth=2
	autocmd FileType djangohtml
		\ setlocal nowrap
		\| setlocal tabstop=2
		\| setlocal softtabstop=2
		\| setlocal shiftwidth=2
augroup end


" need this line to be before loading colorscheme
" TODO: make this colorscheme stay after :w
autocmd ColorScheme * highlight CohoHighlight ctermbg=DarkRed guibg=red
" highlight tabs; needs to be before color scheme is set

colorscheme blackboard

set guifont=Monospace\ 12


" extra stuff"
" remaps q to bd so that buffer is also closed when quitting file
" cnoreabbrev wq w<bar>bd
" cnoreabbrev q bd

" remaps ; to : for easier commands during normal and insert phase
" already remapped in autohotkey"
" "nnoremap ; :
" "inoremap ; :
" "cnoremap ; :
" "vnoremap ; :
" "nnoremap : ;
" "inoremap : ;
" "cnoremap : ;
" "vnoremap : ;

