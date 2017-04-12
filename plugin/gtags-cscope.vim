" File: gtags-cscope.vim
" Author: Tama Communications Corporation
" Version: 0.4
" Last Modified: January 16, 2011
" Basic command
" -------------
" Then you can use cs commands except for the 'd'(2) command.
" Profitable commands are assigned to keys like follows:
"
"	explanation		command	
"	----------------------------------------------------------
"	Find symbol		:cs find 0 or s
"	Find definition		:cs find 1 or g
"	Find functions called by this function	(not implemented)
"	Find reference		:cs find 3 or c
"	Find text string	:cs find 4 or t
"	Find egrep pattern	:cs find 6 or e
"	Find path		:cs find 7 or f
"	Find include file	:cs find 8 or i
"
" You can move tag list using:
"	Go to the next tag	 :tn
"	Go to the previous tag	 :tp
"	Pop tag stack		 :pop
"
" About the other tag command, you can see the help like this:
"
" :h tagsrch
"
" Enhancing command
" -----------------
" You can use the context jump function. To use this function, put the cursor
" on a word and type <C-\><C-\><C-]>.
" If you can use mouse then please double click on the left button.
" To pop tag, please type 'g' and click on the right button.
"
" Configure
" ---------
" You can use the following variables in $HOME/.vimrc.
"
" To ignore letter case when searching:
"	let GtagsCscope_Ignore_Case = 1
" To use absolute path name:
"       let GtagsCscope_Absolute_Path = 1
" To deterring interruption:
"	let GtagsCscope_Keep_Alive = 1
" If you hope auto loading:
"	let GtagsCscope_Auto_Load = 1
" To use 'vim -t ', ':tag' and '<C-]>'
"	set cscopetag

if exists("loaded_gtags_cscope")
    finish
endif

if !has("cscope")
    call Error('This vim does not include cscope support.')
    finish
endif

let s:global_command = $GTAGSGLOBAL
if s:global_command == ''
    let s:global_command = "global"
endif

if !exists("GtagsCscope_Auto_Load")
    let GtagsCscope_Auto_Load = 0
endif

if !exists("GtagsCscope_Auto_Map")
    let GtagsCscope_Auto_Map = 0
endif

if !exists("GtagsCscope_Use_Old_Key_Map")
    let GtagsCscope_Use_Old_Key_Map = 0
endif

if !exists("GtagsCscope_Quiet")
    let GtagsCscope_Quiet = 0
endif

if !exists("GtagsCscope_Ignore_Case")
    let GtagsCscope_Ignore_Case = 0
endif

if !exists("GtagsCscope_Absolute_Path")
    let GtagsCscope_Absolute_Path = 0
endif

if !exists("GtagsCscope_Keep_Alive")
    let GtagsCscope_Keep_Alive = 0
endif

function! s:Error(msg)
    if (g:GtagsCscope_Quiet == 0)
        echohl WarningMsg |
           \ echomsg 'Gtags-cscope: ' . a:msg |
           \ echohl None
    endif
endfunction

function! s:GtagsCscope_GtagsRoot()
    let cmd = s:global_command . " -pq"
    let cmd_output = system(cmd)
    if v:shell_error != 0
        if v:shell_error == 3
            call s:Error('GTAGS not found.')
        else
            call s:Error('global command failed. command line: ' . cmd)
        endif
        return ''
    endif
    return strpart(cmd_output, 0, strlen(cmd_output) - 1)
endfunction

function! s:GtagsCscope()
    let gtagsroot = s:GtagsCscope_GtagsRoot()
    if gtagsroot == ''
        return
    endif
    set csprg=gtags-cscope
    let s:command = "cs add " . gtagsroot . "/GTAGS"
    let s:option = ''
    if g:GtagsCscope_Ignore_Case == 1
        let s:option = s:option . 'C'
    endif
    if g:GtagsCscope_Absolute_Path == 1
        let s:option = s:option . 'a'
    endif
    if g:GtagsCscope_Keep_Alive == 1
        let s:option = s:option . 'i'
    endif
    if s:option != ''
        let s:command = s:command . ' . -' . s:option
    endif
    set nocscopeverbose
    exe s:command
    set cscopeverbose
    nmap \s :cs find s <C-R>=expand("<cword>")<CR>
    nmap \g :cs find g <C-R>=expand("<cword>")<CR>
    nmap \c :cs find c <C-R>=expand("<cword>")<CR>
    nmap \t :cs find t <C-R>=expand("<cword>")<CR>
    nmap \e :cs find e <C-R>=expand("<cword>")<CR>
    nmap \f :cs find f <C-R>=expand("<cfile>")<CR>
    nmap \i :cs find i <C-R>=expand("<cfile>")<CR>
    " tag command
    nmap \<C-n> :tn
    nmap \<C-p> :tp
    nmap <C-n> :cn
    nmap <C-p> :cp
    " Context search. See the --from-here option of global(1).
    nmap \<C-]> :cs find d <C-R>=expand("<cword>")<CR>:<C-R>=line('.')<CR>:%

    " nmap \s :cs find s <C-R>=expand("<cword>")<CR><CR>
    " nmap \g :cs find g <C-R>=expand("<cword>")<CR><CR>
    " nmap \c :cs find c <C-R>=expand("<cword>")<CR><CR>
    " nmap \t :cs find t <C-R>=expand("<cword>")<CR><CR>
    " nmap \e :cs find e <C-R>=expand("<cword>")<CR><CR>
    " nmap \f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    " nmap \i :cs find i <C-R>=expand("<cfile>")<CR><CR>

    " nmap \S :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    " nmap \G :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    " nmap \C :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    " nmap \T :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    " nmap \E :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    " nmap \F :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    " nmap \I :vert scs find i <C-R>=expand("<cfile>")<CR><CR>

endfunction

command! -nargs=0 GtagsCscope call s:GtagsCscope()

let g:GtagsCscope_Auto_Load = 0
let g:GtagsCscope_Auto_Map = 0

let loaded_gtags_cscope = 1
