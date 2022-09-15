function fish_greeting
end

function fish_user_key_bindings
  fzf_key_bindings
end

alias kc="kubectl"

alias ku="kubectl config unset current-context"

alias kx="kubectx"

alias la="exa -la"

alias ls="exa --sort=type --icons"

starship init fish | source
