rsync -a --info=progress2 ~/.vscode-server /scratch/$USER/.vscode-server && rm -rf ~/.vscode-server
ln -s /scratch/$USER/.vscode-server ~/.vscode-server
