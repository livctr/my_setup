# written for greene (setup-conda.sh setup-rclone.sh are for bigpurple)

# Change PIP_CACHE_DIR
# add to PATH in .bashrc
mkdir /scratch/$USER/.cache
if ! grep -q "PIP_CACHE_DIR" ~/.bashrc; then
    cat <<'PIP_CACHE_DIR_TEXT' >> ~/.bashrc

# >>> pip cache >>>
export PIP_CACHE_DIR="/scratch/$USER/.cache/pip"
# <<< pip cache <<<
PIP_CACHE_DIR_TEXT
fi
