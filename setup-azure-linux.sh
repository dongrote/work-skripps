#!/bin/sh

install_neovim() {
  # install neovim
  NVIM_TARBALL=nvim-linux-x86_64.tar.gz
  wget https://github.com/neovim/neovim/releases/download/nightly/$NVIM_TARBALL &&
    tar -zxf $NVIM_TARBALL &&
    rm $NVIM_TARBALL &&
    ln -s $HOME/nvim-linux-x86_64/bin/nvim $HOME/bin/nvim
}

setup_neovim() {
  if [ -d $HOME/.config/nvim ] ; then
    rm -rf $HOME/.config/nvim
  fi
  mkdir -p $HOME/.config/nvim/lua/dongrote/plugins
  cat <<EOF >$HOME/.config/nvim/init.lua
require('dongrote.autocmds')
require('dongrote.remap')
require('dongrote.set')
require('dongrote.lazy')
EOF
  cat <<EOF >$HOME/.config/nvim/lua/dongrote/autocmds.lua
-- Define an autocommand group to organize your autocmds
local augroup = vim.api.nvim_create_augroup("BuildKeymapGroup", { clear = true })

-- Rust-specific keymap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  group = augroup,
  callback = function()
    vim.keymap.set("n", "<leader>b", function()
      vim.cmd("!cargo b")
    end, { desc = "Run cargo build", buffer = true })
    vim.keymap.set("n", "<leader>B", function()
      vim.cmd("!cargo b -r")
    end, { desc = "Run cargo release build", buffer = true })
    vim.keymap.set("n", "<leader>t", function()
      vim.cmd("!cargo t")
    end, { desc = "Run cargo test", buffer = true })
  end,
})

-- C#-specific keymap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  group = augroup,
  callback = function()
    vim.keymap.set("n", "<leader>b", function()
      vim.cmd("!dotnet build")
    end, { desc = "Run dotnet build", buffer = true })
    vim.keymap.set("n", "<leader>B", function()
      vim.cmd("!dotnet build -c Release")
    end, { desc = "Run dotnet release build", buffer = true })
    vim.keymap.set("n", "<leader>t", function()
      vim.cmd("!dotnet test")
    end, { desc = "Run dotnet test", buffer = true })
  end,
})
EOF

  cat <<EOF >$HOME/.config/nvim/lua/dongrote/remap.lua
vim.g.mapleader = " "

-- split window
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })
-- switch windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- show full path
vim.keymap.set("n", "<leader>P", "1<C-g>", { desc = "show full file path" })

-- open file explorer
vim.keymap.set("n", "<leader>us", "<cmd>:setlocal spell<CR>", { desc = "Spellcheck On", })
vim.keymap.set("n", "<leader>uS", "<cmd>:setlocal nospell<CR>", { desc = "Spellcheck Off", })

-- open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle, { desc = "File Tree Toggle", })

-- set executable bit on current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- run custom test.sh script
-- vim.keymap.set("n", "<leader>t", "<cmd>!test.sh %<CR>", { desc = "Run Tests", })
-- vim.keymap.set("n", "<leader>b", "<cmd>!build.sh %<CR>", { desc = "Run Build", })

-- clear highlight
vim.keymap.set("n", "<ESC>", "<cmd>noh<CR>", { desc = "Clear Highlight", })

-- csharp (dotnet) shell commands
vim.keymap.set("n", "<leader>cst", "<cmd>!dotnet test<CR>", { desc = "Run C# Tests", })
vim.keymap.set("n", "<leader>csb", "<cmd>!dotnet build<CR>", { desc = "C# Build", })
vim.keymap.set("n", "<leader>csr", "<cmd>!dotnet restore<CR>", { desc = "C# Restore", })

-- nodejs shell commands
vim.keymap.set("n", "<leader>npmb", "<cmd>!npm run build<CR>")
vim.keymap.set("n", "<leader>npmt", "<cmd>!npm test<CR>")

-- lsp stuffs
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format", })

-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration,  "Go to declaration")
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition,  "Go to definition")
-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation,  "Go to implementation")
-- vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help,  "Show signature help")
-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,  "Add workspace folder")
-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,  "Remove workspace folder")

-- vim.keymap.set("n", "<leader>gd", "<cmd>lua require('omnisharp_extended').telescope_lsp_definition({ jump_type = 'vsplit' })<CR>")
-- navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Comment
vim.keymap.set("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- telescope
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
vim.keymap.set("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "telescope find files" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
vim.keymap.set("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
vim.keymap.set("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
vim.keymap.set("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
vim.keymap.set("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
EOF

  cat <<EOF >$HOME/.config/nvim/lua/dongrote/set.lua
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = '80'

-- Trying to change line numbers to be more visible
-- vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'white', })
-- vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'white', })

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.termguicolors = true

-- automatically create folds based on indentation
vim.opt.foldmethod = 'indent'
vim.opt.foldcolumn = '4'
vim.opt.foldlevelstart = 2

-- disable virtual text because lsp_lines makes them redundant
vim.diagnostic.config({ virtual_text = false })
EOF

  cat <<EOF >$HOME/.config/nvim/lua/dongrote/lazy.lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "dongrote/plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
EOF

  cat <<EOF >$HOME/.config/nvim/lua/dongrote/plugins/telescope.lua
return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find Files", })
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}
EOF

  cat <<EOF >$HOME/.config/nvim/lua/dongrote/plugins/which-key.lua
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({global = false})
			end,
			desc = "Buffer local Keymaps (which-key)",
		},
	},
}
EOF
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
