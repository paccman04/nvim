-- Ensure Packer is installed.
-- Returns true if packer was just installed, false otherwise.
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Attempt to retrieve Packer. Return if failed.
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("require(\"packer\") failed.")
  return
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  -- Dependencies
  use {
    "wbthomason/packer.nvim",
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons"
  }

  -- Color scheme
  use {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup()
    end
  }
  require "user.plugin-config.colorscheme"

  -- File tree
  use {
    "nvim-tree/nvim-tree.lua",
  }
  require "user.plugin-config.tree"

  -- Language Server Protocol
  use {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "windwp/nvim-autopairs",
  }
  require "user.plugin-config.lsp-cmp"

  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require("lualine").setup()
    end
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
  }
  require "user.plugin-config.telescope"

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  require "user.plugin-config.treesitter"

  -- Bufferline
  use {
    "akinsho/bufferline.nvim",
    "moll/vim-bbye",
  }
  require "user.plugin-config.bufferline"

  if packer_bootstrap then
    require('packer').sync()
  end
end)
