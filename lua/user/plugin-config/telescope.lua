local status_ok, builtin = pcall(require, "telescope.builtin")
if not status_ok then
  vim.notify("require(\"telescope.builtin\") failed.")
  return
end

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap('n', '<leader>ff', builtin.find_files, opts)
keymap('n', '<leader>fo', builtin.oldfiles, opts)
keymap('n', '<leader>fs', builtin.live_grep, opts)
keymap('n', '<leader>km', builtin.keymaps, opts)
