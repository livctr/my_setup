# Remote Environment Set Up

A guide to installing conda. Currently, I have Singularity and conda on Greene and conda on Big Purple. Perhaps I will find out which one is easier to work with at some point and update this 😊.

Before you do anything, add `export NYU_NET_ID=<nyu-id>` into your `~/.bashrc` file on your remote. 

### Section 1: Singularity and conda

NOTE: move the `miniconda3` folder out of `ext3` so that the conda kernels can access the envs

See [DSGA 1011 Google Colab](https://colab.research.google.com/drive/1v0M4XwEPysR7_EnnyjMGAJlZBjYqqHWh?usp=sharing#scrollTo=KkG_1WrS9XA6). This is a good step-by-step guide. Luckily for you, I did this. I believe you can copy-paste the following code into your login terminal on Greene. You may need to change the first line depending on what you can access and if you're on Big Purple.

#### Install Singularity

```bash
srun -c8 --gres=gpu:rtx8000:1 --mem=32000 -t 2:00:00 --pty bash << 'EOF'
    echo "Running on compute node: $(hostname)"
    cd "/scratch/$NYU_NET_ID"
    scp greene-dtn:/scratch/work/public/overlay-fs-ext3/overlay-25GB-500K.ext3.gz .
    gunzip -vvv ./overlay-25GB-500K.ext3.gz
    scp -rp greene-dtn:/scratch/work/public/singularity/cuda11.8.86-cudnn8.7-devel-ubuntu22.04.2.sif .
EOF
```

#### Install Conda

On the *GPU compute* node, type

```bash
singularity exec --bind /scratch --nv --overlay  /scratch/$NYU_NET_ID/overlay-25GB-500K.ext3:rw /scratch/$NYU_NET_ID/cuda11.8.86-cudnn8.7-devel-ubuntu22.04.2.sif /bin/bash
```

Then, inside singularity, install conda

```bash
Singularity> mkdir /scratch/$USER/conda
Singularity> cd /scratch/$USER/conda
Singularity> wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /scratch/$USER/conda/miniconda3
source /ext3/miniconda3/etc/profile.d/conda.sh
export PATH=/ext3/miniconda3/bin:$PATH
```

Create environment
```bash
conda create -n nlp_env python==3.9
conda activate nlp_env
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
```

For VSCode to be able to detect the conda kernels, also do `conda install ipykernel nb_conda_kernels`. As of 10/10/2024, Python 3.12 is not yet supported.

Test the setup
```python
python
>>> import torch
>>> torch.cuda.is_available()
True
>>> x = torch.tensor([1, 2])
>>> x
tensor([1, 2])
```

### Section 2: just conda
1) First, `cd ~`. Typing `pwd` should give something like `$HOME/<user_id>`. Please copy this `my_setup` folder to the home directory, or optionally, do a line-by-line install with the code there (I followed miniconda3 installation instructions). Its access should be `~/my_setup`.
1) In the terminal, `cd ~`. Then type `ls -al | grep conda`. If there is a `.conda` file or directory, you'll want to remove it (but first see what it says). For me, there was a warning message about `.conda` taking up memory in the home directory.
2) Make sure you removed the `.conda` file. Then type `bash my_setup/setup-conda.sh -u <user_id>` in the terminal and press enter.
3) Open `~/.bashrc` and append the following lines to the bottom:

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DIR/miniconda3/lib/
export PATH=$DIR/miniconda3/bin:$PATH
```

4) Test that the conda installation went through: `conda --version`. Mine says `conda 24.7.1`.
