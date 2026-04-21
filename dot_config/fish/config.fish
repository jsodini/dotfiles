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

# Match the prompt/fastfetch palette in plain `ls` across BSD and GNU variants.
set -gx LSCOLORS "DxExGxbxCxbxbxBxFxxDxBEx"
set -gx LS_COLORS "di=38;2;255;145;77:ln=38;2;0;119;194:so=38;2;0;137;123:pi=38;2;224;93;101:ex=38;2;124;179;66:bd=38;2;224;93;101:cd=38;2;224;93;101:su=38;2;255;255;255;48;2;224;93;101:sg=38;2;255;255;255;48;2;0;137;123:tw=38;2;0;0;0;48;2;255;145;77:ow=38;2;255;255;255;48;2;224;93;101:or=38;2;224;93;101;1:mi=38;2;224;93;101;1"

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
