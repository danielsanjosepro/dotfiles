function load_env_file
    for line in (cat $argv[1])
        if test -n "$line" -a (string sub -s 1 $line) != "#"
            set -l key (echo $line | cut -d '=' -f 1)
            set -l value (echo $line | cut -d '=' -f 2-)
            set -g -x $key $value
        end
    end
end

