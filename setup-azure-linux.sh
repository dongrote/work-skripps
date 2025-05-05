#!/bin/sh

install_neovim() {
  # install neovim
  NVIM_TARBALL=nvim-linux-x86_64.tar.gz
  wget https://github.com/neovim/neovim/releases/download/nightly/$NVIM_TARBALL &&
    tar -zxf $NVIM_TARBALL &&
    rm $NVIM_TARBALL &&
    ln -s $HOME/nvim-linux-x86_64/bin/nvim $HOME/bin/nvim
}

setup_tmux() {
  sudo dnf install -y tmux

  mkdir -p $HOME/.config/tmux/plugins/catppuccin
  if [ -d $HOME/.config/tmux/plugins/catppuccin/tmux ] ; then
    rm -rf $HOME/.config/tmux/plugins/catppuccin/tmux
  fi
  git clone -b v2.1.3 https://github.com/catppuccin/tmux.git $HOME/.config/tmux/plugins/catppuccin/tmux

  mkdir -p $HOME/.tmux/plugins
  if [ -d $HOME/.tmux/plugins/tpm ] ; then
    rm -rf $HOME/.tmux/plugins/tpm
  fi
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
  cat <<EOF >$HOME/.tmux.conf
# rebind prefix
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# Bind Ctrl-h, Ctrl-j, Ctrl-k, and Ctrl-l to switch panes
# instead of arrow keys
bind C-h select-pane -L
bind C-j select-pane -D
bind C-k select-pane -U
bind C-l select-pane -R

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-cpu'

set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "basic"
set -g @catppuccin_window_text "#W"
set -g @catppuccin_window_default_text "#W"
set -g @catppuccin_window_current_text "#W"

run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux

# set vi key schema
setw -g status-keys vi

set -g status-left-length 100
set -g status-right-length 100
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -agF status-right "#{E:@catppuccin_status_date_time}"
set -agF status-right "#{E:@catppuccin_status_host}"

# Initialize TMUX plugin manager *keep this line at the very bottom)

run '~/.tmux/plugins/tpm/tpm'
EOF
}

# establish $HOME/bin
mkdir -p $HOME/bin

# set timezone to eastern
sudo rm /etc/localtime && \
  sudo ln -s /usr/share/zoneinfo/EST5EDT /etc/localtime

sudo dnf install -y \
  htop \
  tmux \
  build-essential

install_neovim
setup_tmux

echo -e "You should reload your profile:\n\n\tsource \$HOME/.bash_profile\n"
