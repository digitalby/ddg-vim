# ddg.vim

[![CI](https://github.com/digitalby/ddg-vim/actions/workflows/ci.yml/badge.svg)](https://github.com/digitalby/ddg-vim/actions/workflows/ci.yml)

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

### Automated tests (CI)

Tests run automatically on every push and pull request via GitHub Actions.
The suite uses [vader.vim](https://github.com/junegunn/vader.vim) and covers
URL encoding correctness and end-to-end search URL construction.

To run the suite locally:

```sh
# Clone vader.vim once
git clone --depth 1 https://github.com/junegunn/vader.vim /tmp/vader.vim

# Run all tests headlessly
vim -u test/ci_vimrc -N --not-a-term -c 'Vader! test/ddg.vader'
```

### Manual smoke test

An isolated environment is included that loads only ddg.vim, leaving your
`~/.vimrc` and `~/.vim` untouched.

```sh
./test/run.sh
```

Inside Vim:

```
:DDG hello world
:DDGWord
```

## Help

```vim
:help ddg
```

## License

MIT. See [LICENSE](LICENSE).
