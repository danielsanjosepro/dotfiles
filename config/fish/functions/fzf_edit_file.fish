function fzf_edit_file
    if not command -q fzf
        return
    end

    set -l file (fzf \
        --walker=file,hidden,follow \
        --scheme=path \
        --height=40% \
        --reverse \
        --preview='if command -q bat; bat --style=numbers --color=always --line-range=:500 -- {}; else; cat -- {}; end' \
        --preview-window=right:60%:wrap)
    if test -z "$file"
        commandline -f repaint
        return
    end

    commandline -f repaint

    if set -q EDITOR
        eval $EDITOR (string escape -- $file)
    else
        command vi -- $file
    end

    commandline -f repaint
end
