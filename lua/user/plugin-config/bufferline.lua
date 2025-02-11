local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  vim.notify("require(\"bufferline\") failed.")
  return
end

bufferline.setup {
  options = {
    right_mouse_command = "",
    middle_mouse_command = "Bdelete! %d",
    diagnostics = "nvim_lsp",
    diagnostics_update_on_event = true,
    diagnostics_indicator = function(count, level, _, _)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = { { filetype = "NvimTree" } },
  },
}

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap('n', '<S-h>', ':BufferLineCyclePrev<CR>', opts)
keymap('n', '<S-l>', ':BufferLineCycleNext<CR>', opts)
