# Configuration
## 1. update repositories
```bash
sudo apt update
```
## 2 install zsh
```bash
sudo apt install zsh git
```
## 3. install oh my zsh
```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
## 4. run install.sh with sudo
```bash
sudo ./install.sh
```
**note:**
    Dar permisos de ejecución `chmod +x install.sh`
## 5. Optional
```bash
source ~/.zshrc
```
## 6. install tmux plugins
```bash
tmux
```
presionar `ctrl` + `b` luego `I` (i mayúscula)

presionar `ctrl` + `shift` + `r` o  `ctrl` + `R`

esperar 30-40 segundos aproximadamente

## Uninstall

# 1. run uninstall.sh with sudo
```bash
sudo ./uninstall.sh
chsh -s /bin/bash
```
**note:**
    Dar permisos de ejecución `chmod +x uninstall.sh`
