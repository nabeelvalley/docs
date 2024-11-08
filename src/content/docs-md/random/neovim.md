---
published: true
title: Neovim
subtitle: Neovim setup and general info
---

# Installation

The following need to be installed to use Neovim with Plugins

- [Neovim](https://neovim.io)
- [vim-plug](https://www.google.com/search?client=safari&rls=en&q=neovim+plug&ie=UTF-8&oe=UTF-8)

> I had an issue installing `vim-plug` that ended up putting the config into the wrong folder, just ensure that `~/.vim/autoload` contents are copied to `~/.config/nvim/autoload` if nvim can't find the `plug` function - create the `.config/nvim` directory if it doesn't exist

# Setup

## Vim Plug

> [Vim Plug GitHub](https://github.com/junegunn/vim-plug)

First, create a `~/.config/nvim/init.vim` file if it doesn't already exist, and add the following to setup `vim-plug`

`init.vim`

```vim
call plug#begin(stdpath('data') . '/plugged')

" Plugins will be defined in this block

call plug#end()
```

After adding a plugin and saving (`:w`), you will need to reload the nvim config:

```vim
:source path/to/nvim.init
```

And then install the plugins again with:

```vim
:PlugInstall
```

## CoC

> [CoC GitHub](https://github.com/neoclide/coc.nvim)

CoC is a Vim plugin for code completion, it can be installed using `Plug` like so:

```vim
call plug#begin(stdpath('data') . '/plugged')

" Plugins will be defined in this block
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
```

Next, run `nvim` and install the relevant language servers, for example we can install `ts`, `eslint`, `prettier`, and `json` support like so:

```vim
:CocInstall coc-json coc-tsserver
```

Alternatively, you can add the CoC extensions into the `init.vim` file like so:

```vim
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-eslint', 'coc-prettier', 'coc-json' ]
```

The relevant CoC extensions will be automatically installed the next time you open an editor if they aren't already

## Key Bindings/Mappings

We can add keybindings for CoC by copying the base keybindings from their documentation, you can also see them below:

```vim
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
```

Additionally, you can add the following for some spacing preferences and line numbers:

```vim
" tab size
set tabstop=2
set shiftwidth=2

" spaces instead of tab
set expandtab

" show line numbers
set number
```

## Themes

You can use Vim themes by downliading them and adding to the `~/.config/nvim/colors` folder. For example, you can use the [Molokai Theme](https://github.com/tomasr/molokai/blob/master/colors/molokai.vim)

Then, use the `:Colors` command to select at theme - this should automatically load any themes in the `colors` directory as available

You can also set a default theme like so:

```vim
" Molokai theme options
colorscheme molokai
```

## FZF

> [FZF.vim GitHub](https://github.com/junegunn/fzf.vim)

FZF Is a Command Line Fuzzy Search and can be installed in the `init.vim` file like so:

```vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
```

I'm using this along with the below settings:

```vim
" FZF settings
" Open at bottom 40% of screen
let g:fzf_layout = { 'down': '~40%' }
```

After that, resource and install plugins, and then you can use the following commands:

| Command    | Description                  |
| ---------- | ---------------------------- |
| `:Files`   | Search all Files             |
| `:GFiles`  | Search all Git Tracked Files |
| `:Buffers` | View Open Buffers            |
| `:Rg`      | Search in Files (see below)  |

You can then search for files and press enter to open a file

Adding a `!` to the end of the FZF Command will open the search window in full screen

Additionally, we can use [ripgrep](https://github.com/BurntSushi/ripgrep) via the `:Rg` command to search for text content inside of files

It should also be noted that unless [`bat`](https://github.com/sharkdp/bat) is installed, you will not have syntax highlighting in the FZF search results

# NERDTree

`:NERDTree` provides a file explorer within NVIM

| Command     | Description            |
| ----------- | ---------------------- |
| `:NERDTree` | Open the file explorer |
| `?`         | View Help              |
| `m`         | Open the file manu     |

Note that `NERDTree` can also be used from the `:Explore` menu by using `:Explore` followed by `x` (special option) which will launch `NERDTree` in place of the explore but will be in the file context so you can do things like create files, etc. more easily

# Useful Keybindings

| Shortcut        | Description                       |
| --------------- | --------------------------------- |
| `[space] c`     | View Commands w/ Search           |
| `[space] a`     | View Language Server Errors       |
| `\f [enter]`    | Format File                       |
| `\rn`           | Rename Symbol                     |
| `gd`            | Go to Definition                  |
| `gr`            | Go to References                  |
| `\a`            | Code Action                       |
| `[g`            | Previous Error                    |
| `]g`            | Next Error                        |
| `qf`            | Code Fix                          |
| `[ctr] [space]` | View Suggestions                  |
| `[shift] k`     | View Code Doc                     |
| `[space] o`     | View Symbols                      |
| `[ctrl] t`      | From GFiles View, open in new tab |
| `gt` `gT`       | Go to next tab/previous tab       |

# Using NuShell with Vim

You can configure Nushell with Vim using Lua config as:

```lua
-- setting the shell to use "nu" - all of these are required for correct behaviour
-- not setting all the below options will break the `:!command` mode in vim
vim.opt.shell = 'nu'
vim.opt.shellcmdflag = '-c'
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
```

# Telescope + Quickfix

[Telescope](https://github.com/nvim-telescope/telescope.nvim) is used often as a UI for finding stuff and integrates with a lot of other tools in the Neovim ecosystem. Something particularly handy with telescope is the ability to create a quickfix list from a telescope search/filter. This can be done from Telescope with `ctrl + q` which will close telescope and open a quickfix list with the current set of results

Using telescope this way is a nice method to get quickfix lists from a few other things:

- LSP references
- LazyGit Status (faster than the viewing the git file tree)
- Ripgrep
- Telescope file search
