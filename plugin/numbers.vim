""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:           numbers.vim
" Maintainer:     Benedykt Przybyło b3niup@gmail.com
" Version:        0.4.1
" Description:    my fork of vim global plugin for better line numbers.
" Last Change:    23 January, 2014
" License:        MIT License
" Location:       plugin/numbers.vim
" Website:        https://github.com/b3niup/numbers.vim
"
" See numbers.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:numbers_version = '0.4.1'

if exists("g:loaded_numbers") && g:loaded_numbers
    finish
endif
let g:loaded_numbers = 1

if (!exists('g:enable_numbers'))
    let g:enable_numbers = 1
endif

if v:version < 703 || &cp
    echomsg "numbers.vim: you need at least Vim 7.3 and 'nocp' set"
    echomsg "Failed loading numbers.vim"
    finish
endif


"Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

let s:mode = 0
let s:lock = 0

function! NumbersRelativeOff()
    if v:version > 703 || (v:version == 703 && has('patch1115'))
        set norelativenumber
    else
        set number
    endif
endfunction

function! SetRelative()
    if (s:lock == 0)
        let s:mode = 0
        set relativenumber
        set number
    endif
endfunc

function! SetNumbers()
    if (s:lock == 0)
        let s:mode = 1
        call NumbersRelativeOff()
        set number
    endif
endfunc

function! SetHidden()
    if (s:lock == 0)
        let s:mode = 2
        call NumbersRelativeOff()
        set nonumber
    endif
endfunc

function! NumbersToggle()
    if (s:mode == 1)
        call SetHidden()
        let s:lock = 1
    elseif (s:mode == 2)
        let s:lock = 0
        call SetRelative()
    elseif (s:mode == 0)
        let s:lock = 0
        call SetNumbers()
    endif
endfunc

function! NumbersReset()
    if (s:mode == 0)
        call SetRelative()
    elseif (s:mode == 1)
        call SetNumbers()
    elseif (s:mode == 1)
        call SetHidden()
    endif
endfunc

function! NumbersEnable()
    let s:lock = 0
    let g:enable_numbers = 1
    :set relativenumber
    augroup enable
        au!
        autocmd InsertEnter * :call SetNumbers()
        autocmd InsertLeave * :call SetRelative()
        autocmd BufNewFile  * :call NumbersReset()
        autocmd BufReadPost * :call NumbersReset()
        autocmd WinEnter    * :call SetRelative()
        autocmd WinLeave    * :call SetNumbers()
    augroup END
endfunc

function! NumbersDisable()
    let s:lock = 1
    let g:enable_numbers = 0
    :set nu
    :set nu!
    :set rnu!
    augroup disable
        au!
        au! enable
    augroup END
endfunc

function! NumbersOnOff()
    if (g:enable_numbers == 1)
        call NumbersDisable()
    else
        call NumbersEnable()
    endif
endfunc

" Commands
command! -nargs=0 NumbersToggle call NumbersToggle()
command! -nargs=0 NumbersEnable call NumbersEnable()
command! -nargs=0 NumbersDisable call NumbersDisable()
command! -nargs=0 NumbersOnOff call NumbersOnOff()

" reset &cpo back to users setting
let &cpo = s:save_cpo

if (g:enable_numbers)
    call NumbersEnable()
endif
