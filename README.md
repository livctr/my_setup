# Scripts and a conceptual guide to set up on Greene and/or BigPurple.

Compute clusters generally consist of **login nodes and compute nodes**. When you first `ssh` from your local computer to a compute cluster, you will be met with a **login node**. The login node allows you to ask for compute resources like CPUs and GPUs, which are hosted on **compute nodes**. `srun` is the command to ask for interactive compute, and is useful for development.

```bash
Local -- ssh --> login node -- srun --> compute node (NOT USING FOR THIS COURSE)
```

Note that I save this folder in the home directory of my remotes as `~/my_setup`. You can copy this using `cd ~ ; git clone https://github.com/livctr/my_setup.git`. You can remove git tracking by removing the `.git` folder inside it.

### Step 1. VPN

#### BigPurple
Access the BigPurple VPN with [Big-IP Edge Client](http://insidenyulmc.org/help-documentation/NYU-Langone-Advanced-Access-App). Use your Langone Health email password. If the link doesn't work, do a Google search for *NYU Langone VPN*. You may need to ask your advisor to get you access to the VPN (if your password doesn't work).

#### Greene
Access the Greene VPN with Cisco AnyConnect. Follow the download instructions [here](https://nyu.service-now.com/sp?id=search&spa=1&q=VPNMFA). If the link doesn't work, see [this page](https://www.nyu.edu/life/information-technology/infrastructure/network-services/vpn.html) or do a Google search for *NYU VPN.* Use the password for your NYU edu email. Note that *if you are using NYU Wi-Fi, you are connected to the network and do not need a VPN.*

### Step 2. ssh
If you're able to VPN, great, you can continue. If you are on Windows (even if you use WSL), open the command prompt. (Note that you can also connect through your WSL environment. If you want to set up VSCode, however, I recommend you use the command prompt). If you are on Mac, open the terminal. From now, I will refer to either as the terminal.

#### BigPurple
Type `ssh <langoneid>@bigpurple.nyumc.org`, where `<langoneid>` is the string preceding the `@` in your NYU Langone email. You will be prompted for a password. Type your Langone email password. You should be able to see a login screen and something like `[<langoneid>@bigpurple-ln<1-4> ~]$` in your terminal. This is the login node.

#### Greene
Greene is slightly more involved. First, you'll have to `ssh` into a gateway server that sits between your local computer and Greene. Type `ssh <nyuid>@gw.hpc.nyu.edu`, where `<nyuid>` is the string preceding the `@` in your NYU email. Type in your NYU email password. You should be able to see a login screen and something like `[<nyuid>@pco01la-1520a:~]$` in your terminal. Then do another `ssh` into Greene with `ssh <nyuid>@greene.hpc.nyu.edu`. If you're prompted for a password, use the same one. You should see the NYU HPC Greene login letters and something like `[<nyuid>@log-<1-3> ~]$` in your terminal.

### Step 3. Request compute

There are two ways to submit jobs.
1) `srun`: a Slurm command used to submit **interactive** jobs to a compute cluster.
2) `sbatch`: a Slurm command used to submit **batch** jobs to a compute cluster. Submit these so you don't have to sit in front of your computer waiting for things to finish so you can type your next command.

#### BigPurple
Type the following to request a GPU on BigPurple.

```bash
srun -p gpu4_dev --ntasks-per-node=1 --cpus-per-task=2 --gres=gpu:1 --time=00:05:00 --pty bash
```

What does each component mean? Use ChatGPT to find out 😊. But `srun` is a Slurm command used to submit interactive jobs to a compute cluster. Here, you are requesting 5 minutes of GPU time with a job named `gpu4_dev`. This is what I see after I run the command:

```bash
srun: job 52038204 queued and waiting for resources
srun: job 52038204 has been allocated resources
[<userid>@gn-0002 ~]$ 
```

This means we have access to a GPU! `gn-0002` is the hostname of the compute node (type `hostname` to find out). After 5 minutes, the session should disconnect. You can type `exit` to close the connection.

#### Greene

Do the same as above and type the following to request a GPU on Greene.
```bash
srun -c8 --gres=gpu:rtx8000:1 --mem=32000 -t 0:10:00 --pty bash
```

You can type `exit` twice to go back to your local terminal.

### Wrap Up and More Information
That's it! That's all there is to `ssh`-ing! However, you'll need to do some extra things so you can develop quickly:
1) See `README_SSH.md` for setting up `ssh`-ing with VSCode (and doing it without passwords). Also how to bypass the gateway server and forward directly to Greene.
2) See `README_REMOTE_ENV.md` for setting up Singularity and conda so you can get started quickly. 
3) See `README_SLURM_REFERENCES.md` for already-very-good references on Slurm.
4) See `README_ALIASES.md` for setting up aliases so you don't have to keep typing very long commands.
5) See `misc/` for miscellaneous. Includes bash scripts for moving two large files in my home directory to scratch (unsure what the effect of moving `.vscode-server` is when `scratch` does its quarterly erase... we will see 😊).
6) Please make sure to read [Greene HPC](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene), even if you are primarily on BigPurple. It's good. For example, read [Greene HPC Data Management](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management) so that you don't overload your home directory and get headaches. You'll have to create symlinks from your `home` directory to your `scratch` directory.

For more information, the following links (some may not be available to non-NYU students) are useful:
1) [Greene HPC](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene): Very, very useful. I recommend reading this fairly thoroughly. You can use it to understand how to get started, the hardware available, what `dtn` means, what `home` and `scratch` mean, how to run jobs, and how to set up VSCode.
2) [BigPurple HPC](https://med.nyu.edu/research/scientific-cores-shared-resources/high-performance-computing-core). This is less documented than Greene, but it contains useful information for working with BigPurple.
3) [DSGA 1011 HPC Tutorial](https://colab.research.google.com/drive/1v0M4XwEPysR7_EnnyjMGAJlZBjYqqHWh?usp=sharing#scrollTo=KkG_1WrS9XA6): for setting up on your remote side.
