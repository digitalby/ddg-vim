# ddg.vim

Search DuckDuckGo from Vim's command mode. No external dependencies, no
configuration required.

## Features

- `:DDG {query}` — search for any query, including multiple words
- `:DDGWord` — search the word under the cursor
- `<Leader>dg` — normal and visual mode mappings included out of the box
- Cross-platform: macOS, Linux, Windows
- Configurable browser command and mappings

## Requirements

- Vim 7.4.2122+ or any Neovim release
- Python 3 support in Vim is optional but improves multi-byte URL encoding

## Installation

### Vundle

Add to your `.vimrc`:

```vim
Plugin 'digitalby/ddg-vim'
```

Run `:PluginInstall`.

### vim-plug

```vim
Plug 'digitalby/ddg-vim'
```

Run `:PlugInstall`.

### Manual (Vim 8+ packages)

```sh
git clone https://github.com/digitalby/ddg-vim \
  ~/.vim/pack/plugins/start/ddg-vim
```

## Usage

| Command / Mapping       | Action                                       |
|-------------------------|----------------------------------------------|
| `:DDG {query}`          | Search DuckDuckGo for `{query}`              |
| `:DDGWord`              | Search for the word under the cursor         |
| `<Leader>dg` (normal)   | Search for the word under the cursor         |
| `<Leader>dg` (visual)   | Search for the selected text                 |

## Configuration

```vim
" Override the command used to open URLs (default: auto-detected per platform)
let g:ddg_open_command = 'firefox'
" macOS example: open in a specific browser
let g:ddg_open_command = 'open -a "Google Chrome"'

" Disable the default <Leader>dg mappings
let g:ddg_no_mappings = 1
```

### Custom mappings

Use the `<Plug>` targets to bind any key you prefer:

```vim
nmap <Leader>s <Plug>(ddg-search-word)
xmap <Leader>s <Plug>(ddg-search-visual)
```

## Testing

An isolated test environment is included. It loads only ddg.vim, leaving
your `~/.vimrc` and `~/.vim` untouched.

```sh
chmod +x test/run.sh   # first time only
./test/run.sh
```

Inside Vim, try:

```
:DDG hello world
:DDGWord
```

Or open the plugin source, move your cursor over any word, and press
`<Leader>dg`.

## Help

```vim
:help ddg
```

## License

MIT. See [LICENSE](LICENSE).
