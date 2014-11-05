""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:           numbers.vim
" Maintainer:     Benedykt Przybyło b3niup@gmail.com
" Version:        0.5.0
" Description:    my fork of vim global plugin for better line numbers.
" Last Change:    5 November, 2014
" License:        MIT License
" Location:       plugin/numbers.vim
" Website:        https://github.com/b3niup/numbers.vim
"
" See numbers.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:numbers_version = '0.5.0'

if exists("g:numbers_loaded") && g:numbers_loaded
    finish
endif
let g:numbers_loaded = 1

if (!exists('g:numbers_enable'))
    let g:numbers_enable = 1
endif

if (!exists('g:numbers_exclude'))
    let g:numbers_exclude = ['minibufexpl', 'nerdtree', 'unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m']
endif

if v:version < 703 || &cp
    echomsg "numbers.vim: you need at least Vim 7.3 and 'nocp' set"
    echomsg "Failed loading numbers.vim"
    finish
endif


"Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

function! NumbersRelativeOff()
    if v:version > 703 || (v:version == 703 && has('patch1115'))
        set norelativenumber
    else
        set number
    endif
endfunction

function! SetRelative()
    let w:mode = 0
    call NumbersReset()
endfunc

function! SetNumbers()
    let w:mode = 1
    call NumbersReset()
endfunc

function! SetHidden()
    let w:mode = 2
    call NumbersReset()
endfunc

function! NumbersToggle()
    if (w:mode == 1)
        call SetHidden()
        let w:lock = 1
    elseif (w:mode == 2)
        let w:lock = 0
        call SetRelative()
    elseif (w:mode == 0)
        let w:lock = 0
        call SetNumbers()
    endif
endfunc

function! NumbersReset()
    if (!exists('w:mode'))
        let w:mode = 0
    endif
    if (!exists('w:lock'))
        let w:lock = 0
    endif

    if (w:lock == 1)
        return
    endif

    if index(g:numbers_exclude, &ft) >= 0
        let w:mode = 2
    endif

    if (w:mode == 0)
        set relativenumber
        set number
    elseif (w:mode == 1)
        call NumbersRelativeOff()
        set number
    elseif (w:mode == 2)
        call NumbersRelativeOff()
        set nonumber
    endif
endfunc

function! NumbersEnable()
    let g:numbers_enable = 1
    let w:lock = 0
    call SetRelative()
    augroup enable
        au!
        autocmd InsertEnter * :call SetNumbers()
        autocmd InsertLeave * :call SetRelative()
        autocmd BufNewFile  * :call NumbersReset()
        autocmd BufReadPost * :call NumbersReset()
        autocmd FileType    * :call NumbersReset()
        autocmd WinEnter    * :call SetRelative()
        autocmd WinLeave    * :call SetNumbers()
    augroup END
endfunc

function! NumbersDisable()
    call SetHidden()
    let w:lock = 1
    let g:numbers_enable = 0
    augroup disable
        au!
        au! enable
    augroup END
endfunc

function! NumbersOnOff()
    if (g:numbers_enable == 1)
        call NumbersDisable()
    else
        call NumbersEnable()
    endif
endfunc

" Commands
command! -nargs=0 NumbersToggle  call NumbersToggle()
command! -nargs=0 NumbersEnable  call NumbersEnable()
command! -nargs=0 NumbersDisable call NumbersDisable()
command! -nargs=0 NumbersOnOff   call NumbersOnOff()

" reset &cpo back to users setting
let &cpo = s:save_cpo

if (g:numbers_enable)
    call NumbersEnable()
endif
