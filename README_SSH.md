# Setting up `ssh` for VSCode

How to Set Up Greene and Big Purple on VSCode with Windows (WSL)

*A note before starting: The following steps assume you already have VSCode and VPN'ed into the respective domains. For Greene, you need to be in NYU Wi-Fi or use VPN. For Big Purple, you need to install [BIG-IP Edge Client](http://insidenyulmc.org/help-documentation/NYU-Langone-Advanced-Access-App).*

This guide centers around the local `.ssh` directory and how to set up password-less authentication. I have Windows and WSL (note that WSL is independent of `ssh`-ing, it doesn't matter if you have it or not). The same steps can be one in a Mac terminal.

Key references
- [ssh setup](https://sites.google.com/nyu.edu/nyu-hpc/accessing-hpc?authuser=0)
- [HPC Tutorial from DSGA 1011 (set up on the remote side)](https://colab.research.google.com/drive/1v0M4XwEPysR7_EnnyjMGAJlZBjYqqHWh?usp=sharing#scrollTo=gh1SrzRp9LIV)

## Section 1: Workflow for Logging In

Before beginning the set up process, see the below workflow for connecting to a Greene compute node and setting up the environment. If you have a better way, let me know 😊. If you think it can work well for you, you can follow [Section 2](#section-2-guide-for-setting-up) on setting this process up.

1. `ssh greene`
2. `gdgpu [# hours]` on the remote. I keep the `gdgpu` function in `.aliases/gr.aliases`, which is `.gitignore`-ed since I have personal configurations in there.
3. Copy the name of the node I'm allocated (e.g. `grxxx`) and change the `HostName` under `Host (grc)` (see the config file in `README_SSH.md`) to the node's name (I have a program to do this from the command line).
4. Use VSCode to remote into the compute node.
5. In the terminal, type `sing` to start Singularity and then `cae [env_name]` to activate the environment.

At the end, you should see `SSH: [compute_node]` in blue in the bottom left of VSCode and be able to connect your Jupyter notebooks directly to the compute node (for larger files, the login nodes will cause the kernels to crash).

```bash
gdgpu() {
    local gpu_hours=$1
    local commands=${2:-""}

    # Ensure hours are in a valid range (between 1 and 24 for this example)
    if ! [[ "$gpu_hours" =~ ^[1-9][0-9]?$ ]] || [ "$gpu_hours" -gt 24 ]; then
        echo "Error: GPU hours must be between 1 and 24."
        return 1
    fi

    # Convert hours to the format required for the --time parameter (HH:MM:SS)
    time_str=$(printf "%02d:00:00" "$gpu_hours")

    # Run the srun command
    srun -c8 --gres=gpu:rtx8000:1 --mem=32000 --time=$time_str --pty /bin/bash

}
```


## Section 2: Guide for Setting Up

### `.ssh` with WSL (skip if you're on Mac)
On my system, I have two `.ssh` folders. One lives in the Linux directory created by WSL and the other lives on the original Windows directory. Both folders are referred to as `~/.ssh/`, where `~` means the respective "home directories". In the WSL terminal, `~/.ssh` refers to `/home/[user_name_1]/.ssh`, and in the command prompt, `~/.ssh` refers to `C:\Users\[user_name_2]\.ssh`. I will refer to the latter as the **Windows `.ssh` directory**.
. `user_name_1` and `user_name_2` may or may not be equal depending on the set up. **The latter `~/.ssh` can be referenced by the Linux subsystem at `/mnt/c/Users/[user_name_2]/.ssh`.** Notice the forwards vs. backwards slashes. We want to work with the directory in Windows, **e.g.`~/.ssh` in the command prompt** OR **`/mnt/c/Users/[user_name_2]/.ssh` in the terminal.**

### Files in the `.ssh` directory

The files you'll want to look at are `config` and any public/private key files.
* `config`: configuration file, important for configuring VSCode
* `known_hosts`: contains a list of remote computers your local machine may connect to. Sometimes this can cause issues because Greene has multiple login nodes that `greene.hpc.nyu.edu`: Please see [SSH Configuration and X11 Forwarding](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/tunneling-and-x11-forwarding). If it's causing issues, you can always do remove the file by calling `rm known_hosts` in the **Windows `.ssh` directory**. You might have to type "yes" before you log in.
* `known_hosts.old`: don't know, not too important (I think)
* Other file: for example, `id_rsa` and `id_rsa.pub`. Generally, files without an extension are private keys (sometimes, these have the `.pem` extension) and those with an extension are public keys.

### Set up ssh access from the command prompt (and terminal)

For those who have read `README.md`, skip step 1.
1. See [ssh setup](https://sites.google.com/nyu.edu/nyu-hpc/accessing-hpc?authuser=0#h.utvqwwiuouxv).
2. If you don't want to enter the password every time, you can create an SSH key pair. Move the public key to the remote computer. See [Set up ssh (without password) like a boss](https://www.youtube.com/watch?v=j2vBT3T79Pg). Store these key pairs in the Windows `.ssh` directory. Note that the command prompt also supports the `ssh` command.
3. See [SSH Configuration and X11 Forwarding](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/tunneling-and-x11-forwarding) for setting up a tunnel to Greene.


#### On SSH Keys (my notes from step 2 above)

1) Private keys stay with your computer; public keys go to the remote server.
2) Generate the key-pair using `ssh-keygen -t rsa`. Specify the location/name of the key (an identifying name inside the `~/.ssh` folder, e.g. `id_rsa_nyu`) and a password. There should be `id_rsa_nyu` and `id_rsa_nyu.pub` files in the `~/.ssh` folder.
3) Move the public key to remote. The dumb way (dumb isn't bad! This is also how I do it) is to cat `id_rsa_nyu.pub`, copy it, ssh to your remote, find its `.ssh` folder, and append the key to its authorized keys. A faster way is to do `ssh-copy-id -i ~/.ssh/id_rsa_nyu.pub [username]@[remote]`.

### Set up ssh access from VSCode
1. [optional] Install WSL. This is if you want to develop locally.
2. Install VSCode (on the Windows side, this means click on "Download for Windows").
3. Fill in and append the code below to the config file in your **Windows `.ssh` directory**. Anything in `()` is something you can name, and I show my naming inside the parentheses. Fill in `<>` appropriately. You may need to create the file (`touch`) if it's not there.
4. Open VSCode (can be done with `code .` in terminal). Hit `<Ctrl>+<Shift>+<P>` to open the Command Palette, type `Remote-SSH: Connect to Host...`, and hit enter. You should see a drop down of the host names that you named in the configuration file. Click on the one you'd like to connect to.
5. If everything is set up properly, you should see `SSH: [Host]` in blue in the bottom left corner of your VSCode window. If you're still prompted for a password, please visit step 2 [setting up ssh](#set-up-ssh-access-from-the-command-prompt-and-terminal) and/or check that your private key is where you think it is locally and the public key is on the remote.
6. The below code came from multiple sources, many of which are on [Greene's HPC documentation](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene). The compute nodes are not immediately provisioned. You'll need to go into the respective login nodes, provision them, change the HostName line with the node that shows up under `squeue -u $USER`, copy them into the config file, and then ssh.
7. [optional] If you'd like to understand the code, feel free to use ChatGPT 😊. Briefly, `Host` is your alias, `[User]@[HostName]` is what follows `ssh` when you `ssh` from the command line,  `IdentityFile` specifies the location of your private key (for password-less ssh), anything with `Forward` means tunneling, and `ProxyJump` allows you to directly connect to a compute node through a login node.

NOTE 9/30/2024: Logging into Greene and its compute nodes is finicky for me. Often have retry >1 times until it prompts for a password and type it.


```bash
# nyu gateway node
Host (gw-nyu)
    HostName gw.hpc.nyu.edu
    ForwardX11 no
    LocalForward 8027 greene.hpc.nyu.edu:22
    User <nyu-id>
    IdentityFile <path-to-respective-identity-file>

# greene login node
Host (greene)
    HostName greene.hpc.nyu.edu
    ForwardAgent yes
    StrictHostKeyChecking no
    ServerAliveInterval 60
    UserKnownHostsFile /dev/null
    LogLevel ERROR
    User <nyu-id>
    IdentityFile <path-to-respective-identity-file>

# greene compute node
Host (grc)
    HostName <name-of-greene-compute-node>
    User <nyu-id>
    ProxyJump <nyu-id>@greene.hpc.nyu.edu
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
    IdentityFile <path-to-respective-identity-file>

# greene data transfer node
Host (dtn)
    HostName dtn.hpc.nyu.edu
    StrictHostKeyChecking no
    ServerAliveInterval 60
    ForwardAgent yes
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
    User <nyu-id>
    IdentityFile <path-to-respective-identity-file>


# big purple login node
Host (bp)
    HostName bigpurple.nyumc.org
    ForwardAgent yes
    StrictHostKeyChecking no
    ServerAliveInterval 60
    UserKnownHostsFile /dev/null
    LogLevel ERROR
    User <langone-id>
    IdentityFile <path-to-respective-identity-file>


# big purple compute node, change the hostname
Host (bpc)
    HostName <name-of-bigpurple-compute-node>
    User <langone-id>
    ProxyJump <langone-id>@bigpurple.nyumc.org
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
    IdentityFile <path-to-respective-identity-file>
```
