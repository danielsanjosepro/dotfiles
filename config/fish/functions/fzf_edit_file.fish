function fzf_edit_file
    if not command -q fzf
        return
    end

    set -l file (fzf --walker=file,hidden,follow --scheme=path --height=40% --reverse)
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
