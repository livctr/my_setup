#######

# Downloads miniconda to /gpfs/scratch/<user_id>/miniconda3.
# Why scratch? The home folder has a stricter quota, and you want to keep your
# important files there (i.e. this script, your project codes etc).
# Used for Big Purple, not Greene.

# Steps
# (1) `bash ./setup-conda.sh -u <user_id>`
# (2) ``

# See https://docs.anaconda.com/miniconda/#miniconda-latest-installer-links
# See https://github.com/jackzhu727/wiki/tree/main/bigpurple

USER_ID=""

# Get USER_ID
usage() {
    echo "Usage: $0 -u <user_id>"
    exit 1
}

# Parse command-line options
while getopts ":u:" opt; do
    case $opt in
        u)
            USER_ID=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Shift to remove processed options
shift $((OPTIND - 1))

# Check if the required argument is provided
if [ -z "$USER_ID" ]; then
    usage
fi

SCRATCH=/gpfs/scratch
DIR=$SCRATCH/$USER_ID


# Print USER_ID
echo "Installing miniconda3 for: $USER_ID"
echo "Installing miniconda3 in $DIR"

# Create miniconda3 folder and install miniconda in scratch
cd $DIR
mkdir -p miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $DIR/miniconda3/miniconda.sh
bash "$DIR/miniconda3/miniconda.sh" -b -u -p "$DIR/miniconda3"
rm "$DIR/miniconda3/miniconda.sh"

# initialize conda (adds to .bashrc file, possibly among other things)
conda init
