vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("require(\"nvim-tree\") failed.")
  return
end

nvim_tree.setup({
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
    highlight_git = "name",
    highlight_diagnostics = "name",
  },
  filters = {
    git_ignored = false,
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    severity = {
      min = vim.diagnostic.severity.WARN,
    },
  },
  -- actions = {
  --   open_file = {
  --     quit_on_open = true,
  --   },
  -- },
})

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap('n', '<leader>e', ':NvimTreeFindFile<CR>', opts)
