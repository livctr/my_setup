# Aliases

Aliases are shorthands for long commands, e.g. commands for requesting GPU, using git, etc.

I created some in `.aliases` in the `my_setup` folder that are useful to me. You can do the same in yours too.

1. Add aliases files (e.g., Github, Slurm, moving around the directory) into an alias folder.
2. Source them by adding the following to your `.bashrc` folder. It detects if you're on Greene or Bigpurple and sources either `gr.aliases` vs. `bp.aliases`, and everything else. That's all.
3. Start another terminal (or `source ~/.bashrc`).
4. Use git or some other sync method to connect them between the two remotes.

```
HOSTNAME=$(hostname)
echo "Host name for setting aliases: $HOSTNAME"

# sets up aliases based on hostname, may change if NYU changes their hostnames
if [[ "$HOSTNAME" == log-* || "$HOSTNAME" == *.hpc.nyu.edu ]]; then
  echo "On Greene"
  for file in $HOME/my_setup/.aliases/*; do
    if [[ $file == $HOME/my_setup/.aliases/bp.aliases ]]; then
      echo "Skipping $file"
      continue
    fi
    [ -r "$file" ] && [ -f "$file" ] && echo "Sourcing $file" && source "$file"
  done
elif [[ "$HOSTNAME" =~ ^(c|f|g)n-[0-9]{4}$ || "$HOSTNAME" =~ ^gpu-[0-9]{4}$ || "$HOSTNAME" =~ bigpurple-* ]]; then
  echo "On Bigpurple"
  for file in $HOME/my_setup/.aliases/*; do
    if [[ $file == $HOME/my_setup/.aliases/gr.aliases ]]; then
      echo "Skipping $file"
      continue
    fi
    [ -r "$file" ] && [ -f "$file" ] && echo "Sourcing $file" && source "$file"
  done
else
  echo "Not on Greene or Bigpurple"
fi
```
