# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

Shared personal values live in `.chezmoidata.yaml` so they can be reused across
templates. For example, `dot_gitconfig.tmpl` reads `identity.name` and
`identity.email` from that file, and other templates can use
`identity.username` for login-name-style values without hard-coding them.

Package installs are also declared in `.chezmoidata.yaml`. On macOS,
`chezmoi apply` will:

- install Homebrew if it is missing
- tap `d12frosted/emacs-plus`
- install the declared Homebrew packages with `brew bundle`

On Linux, if Homebrew is already present, the same package script will install
the declared Linuxbrew packages too.

Fish is bootstrapped through Homebrew and configured by
`dot_config/fish/config.fish`.

Fish plugins are managed declaratively through `dot_config/fish/fish_plugins`,
with Fisher bootstrapped by a chezmoi script after fish is installed.

Fish is currently using Oh My Posh for the prompt, initialized from
`dot_config/fish/config.fish` and a local theme config in
`dot_config/ohmyposh/config.omp.json`.
Fisher stays installed for actual Fish plugins, but Oh My Posh itself is
managed through Homebrew rather than Fisher.
Interactive Fish shells also run `fastfetch` once per terminal session when it
is installed, while skipping SSH, CI, and nested shells.

Additional Oh My Posh themes are stored locally in `dot_config/ohmyposh/themes`
for easy later switching, including `agnoster`, `dracula`, `gruvbox`, and
`larserikfinholt`.

On macOS, the recommended Meslo Nerd Font is also installed via Homebrew cask
as `font-meslo-lg-nerd-font`.

Emacs is bootstrapped through Homebrew and configured from
`dot_emacs.d/init.el.tmpl` plus small modules under `dot_emacs.d/lisp/`.

On macOS, Emacs is installed with `emacs-plus`, and the Dock icon is managed by
`dot_config/emacs-plus/build.yml.tmpl`.

Emacs packages are declared in `.chezmoidata.yaml` and synced with Emacs'
built-in `package.el`. `chezmoi apply` will run the package sync script after
the Emacs config changes, and Emacs startup will install anything still missing
as a fallback.

The Emacs setup currently includes:

- declarative package management via `package.el`
- `use-package` for configuration structure
- `doom-ayu-dark` as the default theme, with `badwolf` available
- `doom-modeline` and a few Doom-adjacent UI/performance tweaks
- Vertico, Orderless, Marginalia, Consult, and Embark for completion/search
- Corfu and Cape for in-buffer auto-completion
- Magit for Git
- tree-sitter integration via `treesit-auto`
- Org mode with `org-modern`
- lightweight language support for Python, Swift, Ruby, Go, and Rust
- `hl-todo`, `line-reminder`, and `indent-guide` for code-focused editing feedback

Language support is intentionally lightweight:

- built-in tree-sitter modes for Python, Ruby, Go, and Rust
- `swift-mode` for Swift
- `eglot` starts only when a suitable language server executable is present
- buffer-local `compile-command` defaults are set for quick script/test runs
- Makefiles use built-in `make-mode` with tabs preserved and `make -k` as the default compile command

`ripgrep` and `fd` are installed through Homebrew so Consult's project/file
search commands work well out of the box.

CLI defaults are also managed where it helps:

- `bat` uses a shared config in `dot_config/bat/config`
- `fastfetch` uses a cross-platform config in `dot_config/fastfetch/config.jsonc`

`~/org` is created by dotfiles, but your actual Org notes are not managed by
chezmoi by default. The `.keep` file just makes sure the directory exists for
captures and agenda files.

Once fish feels solid as your daily shell, make it your login shell with:

```sh
echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/fish"
```
