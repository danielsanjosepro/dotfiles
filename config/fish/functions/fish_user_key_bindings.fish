function fish_user_key_bindings
  fish_vi_key_bindings

  for mode in insert default visual
    bind -M $mode \ce fzf_edit_file
  end
end

