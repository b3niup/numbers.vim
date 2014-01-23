numbers.vim
===========

numbers.vim is a plugin for intelligently toggling line numbers.  
It is a fork of @myusuf3 [plugin][o].

This plugin alternates between relative (`relatihenumber`), absolute (`number`)  
and hidden line numbering for active window depending on the mode you are in.

In `hidden` mode all event-based mode changes are turned off to keep numbers  
hidden untill next `NumbersToggle` or `NumbersEnable` call.

Commands are included for toggling the line numbering method and for enabling and disabling the plugin.


Requirements
------------

  - Vim 7.3+


Installation
------------

Using [vundle][v] or [pathogen][p] for installation is recommended.

For vundle users, add the following to your `.vimrc` and then run a `:BundleInstall`:

    Bundle "b3niup/numbers.vim"

For pathogen users, clone the repo:

    git clone https://github.com/b3niup/numbers.vim.git ~/.vim/bundle/numbers


Usage
-----

Once installed, no action is *required* on your part.  
But for convenience, you may want to add mappings in your `.vimrc` for some of the commands, e.g.,

    nnoremap <silent> <F2> :NumbersToggle<CR>


It is though *strongly recommended* to use following mapping:

    inoremap <C-c> <Esc><Esc>

It is a workaround for issue where `InsertLeave` event is not working with Ctrl+c.  
Another way to fix this is add `autocmd CursorMoved * :call NumbersReset()` in `NumbersEnable()` function   
around line 104 in `plugin/numbers.vim`, but personally I do not like idea of calling even such light function with every cursor move.


[o]: https://github.com/myusuf3/numbers.vim
[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
