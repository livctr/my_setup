add_alias() {
    # Check if at least two arguments are provided
    if [ $# -lt 2 ]; then
        echo "Usage: add_alias <alias_name> <command> [file_path]"
        return 1
    fi
    
    local alias_name="$1"
    local command="$2"
    local aliases_dir="$HOME/my_setup/.aliases/"
    local file_name="${3:-misc.aliases}"  # Default to misc file if not provided
    local file_path="$aliases_dir$file_name"
    
    # Expand the file path to handle ~ correctly
    file_path=$(eval echo "$file_path")

    # Check if the alias already exists in the file
    if grep -q "alias $alias_name=" "$file_path"; then
        echo "Alias '$alias_name' already exists in $file_path."
        return 1
    fi

    if [ -e "$file_path" ] && [ -n "$(tail -c 1 "$file_path")" ]; then
        # If it doesn't end with a newline, append one
        echo "" >> "$file_path"
    fi

    # Append the alias to the specified file
    echo "alias $alias_name='$command'" >> "$file_path"
    echo "Alias '$alias_name' added successfully to $file_path."
}

add_alias_file() {
    local aliases_dir="$HOME/my_setup/.aliases/"

    if [ $# -ne 1 ]; then
        echo "Usage: add_alias_file <file_name>"
        return 1
    fi

    touch "$aliases_dir$1"
}

see_alias_files() {
    local aliases_dir="$HOME/my_setup/.aliases/"
    ls -al $aliases_dir
}

get_alias_dir() {
    echo "$HOME/my_setup/.aliases/"
}

git_store_my_setup() {

    if [ $# -gt 1 ]; then
        echo "Usage: git_store_aliases [commit message]"
        return 1
    fi

    cd ~/my_setup
    git pull
    git add .
    msg=$(date +"%Y-%m-%d %H:%M:%S")
    if [ $# -eq 1 ]; then
        msg="$1"
    fi

    git commit -m "$msg"
    git push
}

git_pull_my_setup() {
    cd ~/my_setup
    git pull
}
