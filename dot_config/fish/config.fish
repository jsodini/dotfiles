# Minimal fish baseline.
set -g fish_greeting

if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv fish)
else if test -x /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv fish)
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)
end

if test -d "$HOME/.local/bin"
    fish_add_path -g "$HOME/.local/bin"
end

if test -d "$HOME/bin"
    fish_add_path -g "$HOME/bin"
end

if test -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    fish_add_path -g "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
end

alias ducks 'du -cks * | sort -rn | head -n 10'

function __jim_maybe_run_fastfetch
    if not status is-interactive
        return
    end

    if not command -sq fastfetch
        return
    end

    if set -q FASTFETCH_DISABLE; or set -q FASTFETCH_SHOWN; or set -q CI; or set -q INSIDE_EMACS; or set -q SSH_TTY
        return
    end

    set -gx FASTFETCH_SHOWN 1
    fastfetch
end

__jim_maybe_run_fastfetch

if command -sq oh-my-posh
    oh-my-posh init fish --config "$HOME/.config/ohmyposh/config.omp.json" | source
end
