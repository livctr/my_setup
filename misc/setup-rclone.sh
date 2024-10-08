#### Set up for rclone
### rclone allows you to sync files on a remote with cloud.
### I tried using this for syncing this folder, but I found Git to be easier.
### Kept here in case rclone is useful to you.
### https://rclone.org/

scratch  # cd to scratch folder
mkdir rclone
cd rclone
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
chmod 755 rclone
cd ..
mv rclone-*-linux-amd64/rclone rclone
rm rclone-*.zip 

# add to PATH in .bashrc
if ! grep -q "rclone" ~/.bashrc; then
    cat <<'RCLONE_TEXT' >> ~/.bashrc


# >>> rclone init >>>
export PATH="/gpfs/scratch/$USER/rclone:$PATH"
# <<< rclone init <<<
RCLONE_TEXT
fi
